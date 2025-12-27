//
//  AddRecipeViewModel.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 26/12/25.
//


import PhotosUI
import SwiftData
import SwiftUI

// MARK: - ViewModel
@Observable
class AddRecipeViewModel {
    
    // MARK: - Recipe Data
    var recipeData = RecipeData.mockData
    
    // MARK: - Selection States
    var selectedCategory: Category = .none
    var selectedPhotosItems: [PhotosPickerItem] = []
    var selectedPhotos: [UIImage] = []
    var selectedVideos: [URL] = []
    var levelSelection = 0
    var cameraPicture: UIImage?
    var sourceType: UIImagePickerController.SourceType = .camera
    
    // MARK: - Presentation Flags
    var showingWarningMessage: Bool = false
    var showingAddMediaDialog: Bool = false
    var showingPhotoPicker: Bool = false
    var showingVideoPicker: Bool = false
    var showingInformationRequiredAlert: Bool = false
    var showingPhotoCapture: Bool = false
    
    // MARK: - Operation Flags
    var photosSelected: Bool = false
    var videoSelected: Bool = false
    var isRecipeSaved: Bool = false
    var isProcessingVideo: Bool = false
    
    // MARK: - Error Handling
    var validationError: RecipeValidationError?
    
    // MARK: - Managers
    let videoManager = VideoStorageManager()
    
    // MARK: - Computed Properties
    var shouldShowWarningMessage: Bool {
        selectedPhotos.count > 4
    }
    
    var hasMediaSelected: Bool {
        photosSelected || videoSelected
    }
    
    // MARK: - Actions
    func toggleAddMediaDialog() {
        showingAddMediaDialog = true
    }
    
    func togglePhotoPicker() {
        showingVideoPicker = false
        showingPhotoCapture = false
        showingPhotoPicker.toggle()
    }
    
    func toggleVideoPicker() {
        showingPhotoPicker = false
        showingPhotoCapture = false
        showingVideoPicker = true
    }
    
    func openCamera() {
        showingVideoPicker = false
        showingPhotoPicker = false
        showingPhotoCapture = true
        sourceType = .camera
    }
    
    func handleCameraPictureChange() {
        if let picture = cameraPicture {
            selectedPhotos.append(picture)
            photosSelected = true
            cameraPicture = nil
        }
    }
    
    @MainActor
    func handlePhotosItemsChange() async {
        let itemsToProcess = selectedPhotosItems
        selectedPhotosItems.removeAll()
        
        var newImages: [UIImage] = []
        for item in itemsToProcess {
            if let data = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                newImages.append(image)
            }
        }
        
        if !newImages.isEmpty {
            selectedPhotos.append(contentsOf: newImages)
            photosSelected = true
            checkWarningMessageStatus()
        }
    }
    
    func handleVideoSelection(url: URL) {
        guard !isProcessingVideo else { return }
        isProcessingVideo = true
        
        videoManager.saveVideoLocally(from: url, for: recipeData.id)
        videoManager.loadSavedVideos(for: recipeData.id)
        selectedVideos = videoManager.savedVideoURLs
        videoSelected = true
        isProcessingVideo = false
    }
    
    func removePhoto(at index: Int) {
        guard index >= 0 && index < selectedPhotos.count else {
            print("Invalid photo index: \(index)")
            return
        }
        selectedPhotos.remove(at: index)
        
        if selectedPhotos.isEmpty {
            photosSelected = false
        }
        checkWarningMessageStatus()
    }
    
    func removeVideo(_ video: URL) {
        if let realIndex = selectedVideos.firstIndex(of: video) {
            selectedVideos.remove(at: realIndex)
            videoManager.removeVideoAt(path: video)
        }
    }
    
    func checkWarningMessageStatus() {
        showingWarningMessage = selectedPhotos.count > 4
    }
    
    // MARK: - Validation
    func validateRecipe() throws {
        try Validator.validateRecipe(
            title: recipeData.title,
            ingredients: recipeData.ingredients,
            instructions: recipeData.instructions,
            category: selectedCategory.title,
            prepTimeInHour: recipeData.preparationTimeInHours,
            prepTimeInMinute: recipeData.preparationTimeInMinutes,
            images: selectedPhotos
        )
    }
    
    func handleValidationError(_ error: Error) {
        if let validationError = error as? RecipeValidationError {
            self.validationError = validationError
        }
        showingInformationRequiredAlert = true
    }
    
    // MARK: - Save Operations
    func performSaveOperation(modelContext: ModelContext, dataReloadRequest: Binding<Bool>) {
        let dataManager = DataManager(modelContext: modelContext)
        recipeData.category = selectedCategory.title
        recipeData.level = levelSelection
        saveImagesLocally()
        saveVideosLocally()
        dataManager.insert(data: recipeData)
        dataReloadRequest.wrappedValue.toggle()
        isRecipeSaved = true
    }
    
    private func saveImagesLocally() {
        recipeData.imageNames.removeAll()
        let imageStorage = ImageStorageManager(recipeId: recipeData.id)
        
        for index in 0..<selectedPhotos.count {
            let imageName = "\(recipeData.title.lowercased())\(index)"
            imageStorage.saveImageToDocuments(
                image: selectedPhotos[index],
                name: imageName
            )
            recipeData.imageNames.append(imageName)
        }
    }
    
    private func saveVideosLocally() {
        recipeData.videos.removeAll()
        for video in selectedVideos {
            recipeData.videos.append(video.lastPathComponent)
        }
    }
    
    // MARK: - Load Operations
    func loadExistingImages() {
        let imageStorage = ImageStorageManager(recipeId: recipeData.id)
        for imageName in recipeData.imageNames {
            if let uiImage = imageStorage.loadImageFromDocuments(name: imageName) {
                selectedPhotos.append(uiImage)
            }
        }
        checkWarningMessageStatus()
    }
    
    // MARK: - Cleanup
    func resetVideoSelection() {
        for video in selectedVideos {
            videoManager.removeVideoAt(path: video)
        }
    }
    
    func cleanup() {
        if isRecipeSaved {
            resetVideoSelection()
        }
    }
}
