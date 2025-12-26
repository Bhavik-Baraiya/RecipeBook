//
//  AddRecipeView.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 28/03/25.
//

import PhotosUI
import SwiftData
import SwiftUI


struct AddRecipeView: View {
    
    @State private var viewModel = AddRecipeViewModel()
    @Binding var dataReloadRequest: Bool
    
    // MARK: Environment Properties
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var recipeModelContext
    
    var body: some View {
        VStack {
            Form {
                recipeInputView(
                    headLabelText: label_RecipeTitleText,
                    placeHolder: placeHolder_RecipeTitle,
                    textData: $viewModel.recipeData.title
                )
                
                recipeInputView(
                    headLabelText: label_RecipeIngredientsText,
                    placeHolder: placeHolder_RecipeIngredients,
                    textData: $viewModel.recipeData.ingredients
                )
                
                recipeInputView(
                    headLabelText: label_RecipeInstructionsText,
                    placeHolder: placeHolder_RecipeInstructions,
                    textData: $viewModel.recipeData.instructions
                )
                
                levelSelectionView()
                categorySelectionView()
                timeSetterView()
                mediaUploadView()
                bottomActions()
            }
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
        .sheet(isPresented: $viewModel.showingVideoPicker) {
            VideoPickerView { selectedURL in
                viewModel.handleVideoSelection(url: selectedURL)
            }
        }
        .onChange(of: viewModel.cameraPicture) {
            viewModel.handleCameraPictureChange()
        }
        .photosPicker(
            isPresented: $viewModel.showingPhotoPicker,
            selection: $viewModel.selectedPhotosItems,
            maxSelectionCount: 5,
            matching: .images
        )
        .onChange(of: viewModel.selectedPhotosItems) {
            Task {
                await viewModel.handlePhotosItemsChange()
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
    
    // MARK: - Subviews
    @ViewBuilder
    private func recipeInputView(
        headLabelText: LocalizedStringKey,
        placeHolder: LocalizedStringKey,
        textData: Binding<String>
    ) -> some View {
        VStack(alignment: .leading, spacing: 20.0) {
            Text(headLabelText)
                .font(.headline)
            
            TextField(placeHolder, text: textData, axis: .vertical)
                .tint(.accentColor)
        }
    }
    
    @ViewBuilder
    private func levelSelectionView() -> some View {
        VStack(alignment: .leading) {
            Text(label_SelectLevelText)
                .font(.headline)
            
            Spacer().frame(height: 20)
            
            Picker(selection: $viewModel.levelSelection, label: Text("Picker")) {
                Text("Low").tag(0)
                Text("Medium").tag(1)
                Text("High").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            
            Spacer().frame(height: 15)
        }
    }
    
    @ViewBuilder
    private func categorySelectionView() -> some View {
        VStack(alignment: .leading, spacing: 20.0) {
            Picker(label_SelectCategoryText, selection: $viewModel.selectedCategory) {
                ForEach(Category.allCases) { category in
                    Text(LocalizedStringKey(category.title))
                        .tag(category)
                }
            }
            
            Text(label_SelectedCategoryText) +
            Text(" : ") +
            Text(LocalizedStringKey(viewModel.selectedCategory.title))
                .font(.headline)
        }
    }
    
    @ViewBuilder
    private func timeSetterView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            TimeSetterView(
                selectedHour: $viewModel.recipeData.preparationTimeInHours,
                selectedMinutes: $viewModel.recipeData.preparationTimeInMinutes
            )
        }
    }
    
    @ViewBuilder
    private func mediaUploadView() -> some View {
        VStack(alignment: .leading, spacing: 20.0) {
            Text(label_AddMediaText)
                .font(.headline)
            
            Text(maxUploadWarning_Message)
                .font(.footnote)
                .foregroundStyle(.accent)
            
            Text(label_UploadMediaText)
                .frame(height: 40)
                .font(.callout)
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.2))
                }
                .onTapGesture {
                    viewModel.toggleAddMediaDialog()
                }
            
            if viewModel.hasMediaSelected {
                configureMediaList()
            }
        }
    }
    
    @ViewBuilder
    private func bottomActions() -> some View {
        let primaryButton = BottomActionButton(
            title: "Add",
            action: { handleAddAction() }
        )
        let secondaryButton = BottomActionButton(
            title: "Cancel",
            action: {
                viewModel.resetVideoSelection()
                dismiss()
            }
        )
        
        let bottomBtns = [primaryButton, secondaryButton]
        RecipeBottomActionBar(buttons: bottomBtns)
    }
    
    // MARK: - Actions
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
    
    // MARK: - Media Views
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
    
    @ViewBuilder
    private func configureMediaList() -> some View {
        VStack {
            if viewModel.shouldShowWarningMessage {
                Text(removeUploadedPhotos_Message)
                    .font(.footnote)
                    .foregroundStyle(.accent)
            }
            
            if viewModel.selectedPhotos.count > 0 {
                configurePhotosListView()
            }
            
            if viewModel.selectedVideos.count > 0 {
                configureVideoListView()
            }
        }
    }
    
    @ViewBuilder
    private func configurePhotosListView() -> some View {
        VStack {
            HStack {
                Text(label_PhotosHeadingLabel)
                    .font(.headline)
                    .foregroundStyle(.accent)
                
                Spacer()
                
                Button {
                    viewModel.togglePhotoPicker()
                } label: {
                    Image(systemName: "plus.circle")
                        .font(.body)
                        .foregroundStyle(.accent)
                }
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.accent.opacity(0.1))
            }
            
            photosItemList()
        }
    }
    
    @ViewBuilder
    private func photosItemList() -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                ForEach(viewModel.selectedPhotos.indices, id: \.self) { index in
                    if index < viewModel.selectedPhotos.count {
                        ZStack(alignment: .topTrailing) {
                            Image(uiImage: viewModel.selectedPhotos[index])
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 90, height: 90)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            Button {
                                viewModel.removePhoto(at: index)
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.white)
                                    .background(Circle().fill(Color.black.opacity(0.6)))
                                    .padding(6)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func configureVideoListView() -> some View {
        VStack {
            HStack {
                Text(label_VideosHeadingLabel)
                    .font(.headline)
                    .foregroundStyle(.accent)
                
                Spacer()
                
                Button {
                    viewModel.toggleVideoPicker()
                } label: {
                    Image(systemName: "plus.circle")
                        .font(.body)
                        .foregroundStyle(.accent)
                }
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.accent.opacity(0.1))
            }
            
            videosItemList()
        }
    }
    
    @ViewBuilder
    private func videosItemList() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(Array(viewModel.selectedVideos.reversed()), id: \.self) { video in
                    ZStack(alignment: .topTrailing) {
                        Button {
                            // Video playback action
                        } label: {
                            VideoThumbnailView(videoURL: video, size: 90)
                                .frame(width: 90, height: 90)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        
                        Button {
                            viewModel.removeVideo(video)
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .frame(width: 18, height: 18)
                                .foregroundColor(.white)
                                .background(Circle().fill(Color.black.opacity(0.6)))
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        AddRecipeView(dataReloadRequest: .constant(false))
    }
}
