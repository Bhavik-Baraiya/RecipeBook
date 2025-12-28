//
//  RecipeFormView.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 27/12/25.
//

import SwiftUI
import PhotosUI

// MARK: - Reusable Recipe Form View
struct RecipeFormView: View {
    
    @Binding var recipeData: RecipeData
    @Binding var selectedCategory: Category
    @Binding var levelSelection: Int
    @Binding var selectedPhotos: [UIImage]
    @Binding var selectedVideos: [URL]
    @Binding var selectedPhotosItems: [PhotosPickerItem]
    @Binding var cameraPicture: UIImage?
    @Binding var photosSelected: Bool
    @Binding var videoSelected: Bool
    @Binding var showingAddMediaDialog: Bool
    @Binding var showingPhotoPicker: Bool
    @Binding var showingVideoPicker: Bool
    @Binding var showingPhotoCapture: Bool
    
    let mode: RecipeFormMode
    let onPrimaryAction: () -> Void
    let onSecondaryAction: () -> Void
    let onRemovePhoto: (Int) -> Void
    let onRemoveVideo: (URL) -> Void
    let onTogglePhotoPicker: () -> Void
    let onToggleVideoPicker: () -> Void
    let onOpenCamera: () -> Void
    
    var shouldShowWarningMessage: Bool {
        selectedPhotos.count > 4
    }
    
    var hasMediaSelected: Bool {
        photosSelected || videoSelected
    }
    
    var body: some View {
        Form {
            recipeInputView(
                headLabelText: label_RecipeTitleText,
                placeHolder: placeHolder_RecipeTitle,
                textData: $recipeData.title
            )
            
            recipeInputView(
                headLabelText: label_RecipeIngredientsText,
                placeHolder: placeHolder_RecipeIngredients,
                textData: $recipeData.ingredients
            )
            
            recipeInputView(
                headLabelText: label_RecipeInstructionsText,
                placeHolder: placeHolder_RecipeInstructions,
                textData: $recipeData.instructions
            )
            
            levelSelectionView()
            categorySelectionView()
            timeSetterView()
            mediaUploadView()
            bottomActions()
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
            
            Picker(selection: $levelSelection, label: Text("Picker")) {
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
            Picker(label_SelectCategoryText, selection: $selectedCategory) {
                ForEach(Category.allCases) { category in
                    Text(LocalizedStringKey(category.title))
                        .tag(category)
                }
            }
            
            Text(label_SelectedCategoryText) +
            Text(" : ") +
            Text(LocalizedStringKey(selectedCategory.title))
                .font(.headline)
        }
    }
    
    @ViewBuilder
    private func timeSetterView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            TimeSetterView(
                selectedHour: $recipeData.preparationTimeInHours,
                selectedMinutes: $recipeData.preparationTimeInMinutes
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
                    showingAddMediaDialog.toggle()
                }
            
            if hasMediaSelected {
                configureMediaList()
            }
        }
    }
    
    @ViewBuilder
    private func configureMediaList() -> some View {
        VStack {
            if shouldShowWarningMessage {
                Text(removeUploadedPhotos_Message)
                    .font(.footnote)
                    .foregroundStyle(.accent)
            }
            
            if selectedPhotos.count > 0 {
                configurePhotosListView()
            }
            
            if selectedVideos.count > 0 {
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
                    onTogglePhotoPicker()
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
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(selectedPhotos.indices, id: \.self) { index in
                    if index < selectedPhotos.count {
                        PhotoItemView(photo: selectedPhotos[index], index: index, onRemove: {
                            onRemovePhoto(index)
                        })
                    }
                }
            }
            .padding(.horizontal, 4)
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
                    onToggleVideoPicker()
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
            LazyHStack(spacing: 10) {
                ForEach(selectedVideos.indices, id: \.self) { index in
                    if index < selectedVideos.count {
                        let video = selectedVideos[index]
                        VideoItemView(video: video, onRemove: {
                            onRemoveVideo(video)
                        })
                    }
                }
            }
            .padding(.horizontal, 4)
        }
    }
    
    @ViewBuilder
    private func bottomActions() -> some View {
        let primaryButton = BottomActionButton(
            title: mode.primaryButtonTitle,
            action: onPrimaryAction
        )
        let secondaryButton = BottomActionButton(
            title: mode.secondaryButtonTitle,
            action: onSecondaryAction
        )
        
        let bottomBtns = [primaryButton, secondaryButton]
        RecipeBottomActionBar(buttons: bottomBtns)
    }
}
