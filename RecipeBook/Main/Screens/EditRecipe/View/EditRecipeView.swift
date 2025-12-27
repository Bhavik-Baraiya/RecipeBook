//
//  UpdateRecipeView.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 31/03/25.
//

import SwiftData
import SwiftUI
import PhotosUI

struct EditRecipeView: View {
    
    @State private var viewModel: EditRecipeViewModel
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var recipeModelContext
    
    init(recipeData: RecipeData) {
        _viewModel = State(initialValue: EditRecipeViewModel(recipeData: recipeData))
    }
    
    var body: some View {
        VStack {
            RecipeFormView(
                recipeData: $viewModel.recipeData,
                selectedCategory: $viewModel.selectedCategory,
                levelSelection: $viewModel.recipeData.level,
                selectedPhotos: $viewModel.selectedPhotos,
                selectedVideos: $viewModel.selectedVideos,
                selectedPhotosItems: $viewModel.selectedItems,
                cameraPicture: $viewModel.cameraPicture,
                photosSelected: $viewModel.photosSelected,
                videoSelected: $viewModel.videoSelected,
                showingAddMediaDialog: $viewModel.showingAddMediaDialog,
                showingPhotoPicker: $viewModel.showingPhotoPicker,
                showingVideoPicker: $viewModel.showingVideoPicker,
                showingPhotoCapture: $viewModel.showingPhotoCapture,
                mode: .edit,
                onPrimaryAction: { handleUpdate() },
                onSecondaryAction: { dismiss() },
                onRemovePhoto: { index in
                    viewModel.removePhoto(at: index)
                },
                onRemoveVideo: { video in
                    viewModel.removeVideo(video)
                },
                onTogglePhotoPicker: {
                    viewModel.togglePhotoPicker()
                },
                onToggleVideoPicker: {
                    viewModel.toggleVideoPicker()
                },
                onOpenCamera: {
                    viewModel.openCamera()
                }
            )
        }
        .confirmationDialog(
            label_UploadMediaText,
            isPresented: $viewModel.showingAddMediaDialog,
            titleVisibility: .visible
        ) {
            uploadMediaActionOptionsView()
        }
        .sheet(isPresented: $viewModel.showingPhotoCapture) {
            ImagePicker(
                image: $viewModel.cameraPicture,
                isShown: $viewModel.showingPhotoCapture,
                sourceType: viewModel.sourceType
            )
        }
        .photosPicker(
            isPresented: $viewModel.showingPhotoPicker,
            selection: $viewModel.selectedItems,
            maxSelectionCount: 5,
            matching: .images
        )
        .sheet(isPresented: $viewModel.showingVideoPicker) {
            VideoPickerView { selectedURL in
                viewModel.handleVideoSelection(url: selectedURL)
            }
        }
        .onChange(of: viewModel.cameraPicture) { oldValue, newValue in
            if newValue != nil {
                viewModel.handleCameraPictureChange()
            }
        }
        .onChange(of: viewModel.selectedItems) { oldValue, newValue in
            if !newValue.isEmpty {
                Task {
                    await viewModel.handlePhotosItemsChange()
                }
            }
        }
        .alert(
            popupTitle_InformationRequired,
            isPresented: $viewModel.showInformationRequiredAlert
        ) {
            Button("Dismiss", role: .cancel) {
                viewModel.showInformationRequiredAlert = false
            }
        } message: {
            Text(viewModel.validationError?.errorDescription ?? "An unknown error occurred.")
        }
        .navigationTitle("Update Recipe")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadExistingData()
        }
    }
    
    private func handleUpdate() {
        do {
            try viewModel.validateRecipe()
            viewModel.performUpdateOperation()
            dismiss()
        } catch {
            viewModel.handleValidationError(error)
        }
    }
    
    @ViewBuilder
    private func uploadMediaActionOptionsView() -> some View {
        Button("Camera") {
            viewModel.openCamera()
        }
        
        Button("Photos") {
            viewModel.togglePhotoPicker()
        }
        
        Button("Videos") {
            viewModel.toggleVideoPicker()
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        let tmpData = RecipeData(
            title: "Mango juice",
            ingredients: "...",
            instructions: "...",
            category: "Indian",
            level: 1,
            preparationTimeInHours: 1,
            preparationTimeInMinutes: 45,
            imageNames: ["", ""],
            videos: [],
            isFavourite: false
        )
        EditRecipeView(recipeData: tmpData)
    }
}
