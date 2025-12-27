//
//  EditRecipeViewModel.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 27/12/25.
//

import SwiftData
import SwiftUI
import PhotosUI

// MARK: - ViewModel
@Observable
class EditRecipeViewModel {
    
    // MARK: - Recipe Data
    var recipeData: RecipeData
    
    // MARK: - Selection States
    var selectedCategory: Category = .none
    var selectedItems: [PhotosPickerItem] = []
    var selectedPhotos: [UIImage] = []
    var selectedVideos: [URL] = []
    var cameraPicture: UIImage?
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    // MARK: - Presentation Flags
    var showWarningMessage: Bool = false
    var showInformationRequiredAlert: Bool = false
    var showingAddMediaDialog: Bool = false
    var showingPhotoPicker: Bool = false
    var showingVideoPicker: Bool = false
    var showingPhotoCapture: Bool = false
    
    // MARK: - Operation Flags
    var photosSelected: Bool = false
    var videoSelected: Bool = false
    
    // MARK: - Error Handling
    var validationError: RecipeValidationError?
    
    // MARK: - Managers
    let videoManager = VideoStorageManager()
    
    // MARK: - Initialization
    init(recipeData: RecipeData) {
        self.recipeData = recipeData
    }
    
    // MARK: - Computed Properties
    var shouldShowWarningMessage: Bool {
        selectedPhotos.count > 4
    }
    
    var shouldShowVideoWarningMessage: Bool {
        selectedVideos.count > 4
    }
    
    var hasMediaSelected: Bool {
        photosSelected || videoSelected
    }
    
    // MARK: - Actions
    func toggleAddMediaDialog() {
        showingAddMediaDialog.toggle()
    }
    
    func togglePhotoPicker() {
        showingPhotoPicker.toggle()
    }
    
    func toggleVideoPicker() {
        showingVideoPicker = true
    }
    
    func openCamera() {
        showingPhotoCapture = true
        sourceType = .camera
    }
    
    func handleCameraPictureChange() {
        if let picture = cameraPicture {
            selectedPhotos.append(picture)
            photosSelected = true
            cameraPicture = nil // Reset after adding
        }
    }
    
    @MainActor
    func handlePhotosItemsChange() async {
        let itemsToProcess = selectedItems
        selectedItems.removeAll()
        
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
    
    func handleVideoPickerDismiss() {
        videoManager.loadSavedVideos(for: recipeData.id)
        selectedVideos = videoManager.savedVideoURLs
    }
    
    func handleVideoSelection(url: URL) {
        let recipeVideoLocalPath = videoManager.getVideoLocalDirectory(recipeID: recipeData.id)
        videoManager.saveVideoLocally(from: url, for: recipeData.id)
        selectedVideos.append(recipeVideoLocalPath)
        videoSelected = true
    }
    
    func removePhoto(at index: Int) {
        guard index >= 0 && index < selectedPhotos.count else {
            print("⚠️ Invalid photo index: \(index)")
            return
        }
        selectedPhotos.remove(at: index)
        
        // Update photosSelected flag
        if selectedPhotos.isEmpty {
            photosSelected = false
        }
        
        checkWarningMessageStatus()
    }
    
    func removeVideo(_ video: URL) {
        if let realIndex = selectedVideos.firstIndex(of: video) {
            selectedVideos.remove(at: realIndex)
            videoManager.removeVideoAt(path: video)
            
            // Update videoSelected flag
            if selectedVideos.isEmpty {
                videoSelected = false
            }
        }
    }
    
    func checkWarningMessageStatus() {
        showWarningMessage = selectedPhotos.count > 4
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
        showInformationRequiredAlert = true
    }
    
    // MARK: - Update Operations
    func performUpdateOperation() {
        recipeData.category = selectedCategory.title
        updateImagesLocally()
        updateVideosLocally()
    }
    
    private func updateImagesLocally() {
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
    
    private func updateVideosLocally() {
        recipeData.videos.removeAll()
        for video in selectedVideos {
            recipeData.videos.append(video.lastPathComponent)
        }
    }
    
    // MARK: - Load Operations
    func loadExistingData() {
        selectedCategory = Category.allCases.first {
            $0.title == recipeData.category
        } ?? .none
        loadRecipeImages()
        loadRecipeVideos()
        checkWarningMessageStatus()
    }
    
    private func loadRecipeImages() {
        if !recipeData.imageNames.isEmpty {
            photosSelected = true
        }
        
        let imageStorage = ImageStorageManager(recipeId: recipeData.id)
        for imageName in recipeData.imageNames {
            if let uiImage = imageStorage.loadImageFromDocuments(name: imageName) {
                selectedPhotos.append(uiImage)
            }
        }
    }
    
    private func loadRecipeVideos() {
        videoManager.loadSavedVideos(for: recipeData.id)
        selectedVideos = videoManager.savedVideoURLs
        
        if !selectedVideos.isEmpty {
            videoSelected = true
        }
    }
}
