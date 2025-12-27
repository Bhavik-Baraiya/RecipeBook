//
//  AddRecipeView.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 28/03/25.
//

import PhotosUI
import SwiftData
import SwiftUI


// MARK: - Updated AddRecipeView Using Reusable Form
struct AddRecipeView: View {
    
    @State private var viewModel = AddRecipeViewModel()
    @Binding var dataReloadRequest: Bool
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var recipeModelContext
    
    var body: some View {
        VStack {
            RecipeFormView(
                recipeData: $viewModel.recipeData,
                selectedCategory: $viewModel.selectedCategory,
                levelSelection: $viewModel.levelSelection,
                selectedPhotos: $viewModel.selectedPhotos,
                selectedVideos: $viewModel.selectedVideos,
                selectedPhotosItems: $viewModel.selectedPhotosItems,
                cameraPicture: $viewModel.cameraPicture,
                photosSelected: $viewModel.photosSelected,
                videoSelected: $viewModel.videoSelected,
                showingAddMediaDialog: $viewModel.showingAddMediaDialog,
                showingPhotoPicker: $viewModel.showingPhotoPicker,
                showingVideoPicker: $viewModel.showingVideoPicker,
                showingPhotoCapture: $viewModel.showingPhotoCapture,
                mode: .add,
                onPrimaryAction: { handleAddAction() },
                onSecondaryAction: {
                    viewModel.resetVideoSelection()
                    dismiss()
                },
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
        .alert(label_UploadMediaText, isPresented: $viewModel.showingAddMediaDialog) {
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
            selection: $viewModel.selectedPhotosItems,
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
        .onChange(of: viewModel.selectedPhotosItems) { oldValue, newValue in
            if !newValue.isEmpty {
                Task {
                    await viewModel.handlePhotosItemsChange()
                }
            }
        }
        .alert(popupTitle_InformationRequired, isPresented: $viewModel.showingInformationRequiredAlert) {
            Button("Dismiss", role: .cancel) {
                viewModel.showingInformationRequiredAlert = false
            }
        } message: {
            Text(viewModel.validationError?.errorDescription ?? "An unknown error occurred.")
        }
        .navigationTitle("Add Recipe")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadExistingImages()
        }
        .onDisappear {
            viewModel.cleanup()
        }
    }
    
    private func handleAddAction() {
        do {
            try viewModel.validateRecipe()
            viewModel.performSaveOperation(
                modelContext: recipeModelContext,
                dataReloadRequest: $dataReloadRequest
            )
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
        
        Button("Cancel") {
            viewModel.toggleAddMediaDialog()
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        AddRecipeView(dataReloadRequest: .constant(false))
    }
}
