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
    
    @State private var recipeData = RecipeData(title: "", ingredients: "", instructions: "", category: "", level: 1, preparationTimeInHours: 1, preparationTimeInMinutes: 2)
    @State private var selectedCategory = "None"
    @State private var selectedPhotosItems:[PhotosPickerItem] = []
    @State private var selectedPhotos: [UIImage] = []
    @State private var selectedVideos: [URL] = []
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var cameraPicture: UIImage?
    @State private var levelSelection = 0
    @Binding var dataReloadRequest: Bool
    // MARK: Enviornment Properties

    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var recipeModelContext

    // MARK: Presenting Flag Properties
    
    @State private var showingWarningMessage: Bool = false
    @State private var showingAddMediaDialog: Bool = false
    @State private var showingPhotoPicker: Bool = false
    @State private var showingVideoPicker: Bool = false
    @State private var showingInformationRequiredAlert: Bool = false
    @State private var showingPhotoCapture: Bool = false
    
    // MARK: Operation Flag Properties
    
    @State private var photosSelected: Bool = false
    @State private var videoSelected: Bool = false
    
    // MARK: - StateObjects
    
    @StateObject var videoManager = VideoStorageManager()
    
    private let categories = [
      "Beverage",
      "Meal",
      "Dessert",
      "Snacks",
      "Soup"
    ]
    
    // MARK: Error Properties
    @State private var validationError: RecipeValidationError?
    
    var body: some View {
        
        VStack {
            Form {
                
                recipeInputView(
                    headLabelText: label_RecipeTitleText,
                    placeHolder: placeHolder_RecipeTitle,
                    textData: $recipeData.title
                )
                
                recipeInputView(
                    headLabelText: label_RecipeIngredientsText,
                    placeHolder: placeHolder_RecipeIngredients.capitalized,
                    textData: $recipeData.ingredients
                )
                
                recipeInputView(
                    headLabelText: label_RecipeInstructionsText,
                    placeHolder: placeHolder_RecipeInstructions.capitalized,
                    textData: $recipeData.instructions
                )
                
                VStack(alignment:.leading) {
                    
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
                
                VStack(alignment: .leading,spacing: 20.0, content: {
                    
                    Picker(label_SelectCategoryText, selection: self.$selectedCategory, content: {
                        ForEach(categories, id: \.self) { category in
                            Text(category)
                        }
                    })
                    Text("\(label_SelectedCategoryText) \(self.$selectedCategory.wrappedValue)")
                        .font(.headline)
                })
                
                VStack(alignment: .leading,spacing: 0, content: {
                    TimeSetterView(selectedHour: $recipeData.preparationTimeInHours, selectedMinutes: $recipeData.preparationTimeInMinutes)
                })
                
                VStack(alignment: .leading,spacing: 20.0, content: {
                    
                    Text(label_AddMediaText)
                        .font(.headline)
                    
                    Text(maxUploadWarning_Message)
                        .font(.footnote)
                        .foregroundStyle(.accent)
                    
                    Text(label_UploadMediaText)
                        .frame(height:40)
                        .font(.callout)
                        .padding(.vertical,10)
                        .padding(.horizontal,20)
                        .background(content: {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.2))
                        })
                        .onTapGesture(perform: {
                            showingAddMediaDialog.toggle()
                        })
                    
                        if(self.photosSelected == true || self.videoSelected == true) {
                            configureMediaList()
                        }
                })
                self.bottomActions()
            }
        }
        .confirmationDialog(label_UploadMediaText, isPresented: $showingAddMediaDialog,titleVisibility: .visible , actions: {
            self.uploadMediaActionOptionsView()
        })
        .sheet(isPresented: $showingPhotoCapture, content: {
            ImagePicker(image: $cameraPicture, isShown: self.$showingPhotoCapture, sourceType: self.sourceType)
        })
        .sheet(isPresented: $showingVideoPicker, content: {
            VideoPickerView { selectedURL in
                let recipeVideoLocalPath = videoManager.getVideoLocalDirectory(recipeID: $recipeData.id)
                videoManager.saveVideoLocally(from: selectedURL, for: $recipeData.id)
                self.selectedVideos.append(recipeVideoLocalPath)
            }
        })
        .onChange(of: self.cameraPicture, {
            
            if let picture = self.cameraPicture {
                self.selectedPhotos.append(picture)
                self.photosSelected = true
            }
        })
        .onChange(of: self.showingVideoPicker, {
            videoManager.loadSavedVideos(for: $recipeData.id)
            selectedVideos = videoManager.savedVideoURLs
        })
        .onChange(of: self.selectedVideos, {
            self.videoSelected = true
        })
        .photosPicker(
            isPresented: $showingPhotoPicker,
            selection: $selectedPhotosItems,
            maxSelectionCount: 5,
            matching: .images
        )
        .onChange(of: selectedPhotosItems, {
            selectedPhotos = []
            for item in selectedPhotosItems {
                Task {
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        selectedPhotos.append(image)
                    }
                }
            }
            checkWarningMessageStatus()
            self.photosSelected = true
        })
        .alert(popupTitle_InformationRequired, isPresented: $showingInformationRequiredAlert) {
            Button("Dismiss", role: .cancel) {
                showingInformationRequiredAlert = false
            }
        } message: {
            Text(validationError?.errorDescription ?? "An unknown error occurred.")
        }
        .navigationTitle("Add Recipe")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            let imageStorage = ImageStorageManager(recipeId: self.$recipeData.id)
            for index in 0..<$recipeData.imageNames.wrappedValue.count {
                if let uiImage = imageStorage.loadImageFromDocuments(name: $recipeData.imageNames.wrappedValue[index]) {
                    self.selectedPhotos.append(uiImage)
                }
            }
            checkWarningMessageStatus()
        })
    }
    
    
    @ViewBuilder
    private func bottomActions() -> some View {
        let primaryButton = BottomActionButton(title: "Add", action: { handleAddAction() })
        let secondaryButton = BottomActionButton(title: "Cancel", action: {
            dismiss()
        })
        
        let bottomBtns = [primaryButton, secondaryButton]
        RecipeBottomActionBar(buttons: bottomBtns)
    }
    
    private func handleAddAction() {
        do {
            try Validator.validateRecipe(
                title: recipeData.title,
                ingredients: recipeData.ingredients,
                instructions: recipeData.instructions,
                category: selectedCategory,
                prepTimeInHour: recipeData.preparationTimeInHours,
                prepTimeInMinute: recipeData.preparationTimeInMinutes,
                images: selectedPhotos
            )
            // ✅ Only dismiss if validation succeeds
            performSaveOperation()
            dismiss()
        } catch let error as RecipeValidationError {
            validationError = error
            showingInformationRequiredAlert = true
        } catch {
            showingInformationRequiredAlert = true
        }
    }
    
    private func performSaveOperation() {
        
        let datamanager = DataManager(modelContext: recipeModelContext)
        datamanager.insert(data: recipeData)
        recipeData.category = self.selectedCategory
        recipeData.level = self.levelSelection
        saveImagesLocally()
        saveVideosLocally()
        dataReloadRequest.toggle()
    }
    
    private func saveImagesLocally() {
        
        $recipeData.imageNames.wrappedValue.removeAll()
        let imageStorage = ImageStorageManager(recipeId: self.$recipeData.id)
        for index in 0..<selectedPhotos.count {
            imageStorage.saveImageToDocuments(
                image: selectedPhotos[index],
                name: "\($recipeData.title.wrappedValue.lowercased())\(index)"
            )
            $recipeData.imageNames.wrappedValue.append("\($recipeData.title.wrappedValue.lowercased())\(index)")
        }
    }
    
    private func saveVideosLocally() {
        
        $recipeData.videos.wrappedValue.removeAll()
        for video in selectedVideos {
            $recipeData.videos.wrappedValue.append(video)
        }
    }
    
    private func checkWarningMessageStatus() {
        
        if(selectedPhotos.count > 4) {
            showingWarningMessage = true
        } else {
            showingWarningMessage = false
        }
    }
    
    @ViewBuilder
    private func recipeInputView(headLabelText: String, placeHolder: String, textData: Binding<String>) -> some View {
        
        VStack(alignment: .leading,spacing: 20.0, content: {
            Text(headLabelText)
                .font(.headline)
            
            TextField(
                placeHolder,
                text: textData,
                axis: .vertical
            )
            .tint(.accentColor)
        })
    }
    
    @ViewBuilder
    func uploadMediaActionOptionsView() -> some View {
        
        Button(action:{
            self.showingPhotoCapture = true
            self.sourceType = .camera
        }, label: {
            Text("Camera")
        })
        
        Button(action:{
            showingPhotoPicker.toggle()
        }, label: {
            Text("Photos")
        })
        
        Button(action:{
            self.showingVideoPicker = true
        }, label: {
            Text("Videos")
        })
    }
    
    @ViewBuilder
    func configureMediaList() -> some View {
        
        VStack {
            if selectedPhotos.count > 4 {
                showRemoveImageMessage()
            }
            self.mediaListView()
        }
    }

    func mediaListView() -> some View {
        
        return VStack {
            if(self.selectedPhotos.count > 0) {
                self.configurePhotosListView()
            }
            if (self.selectedVideos.count > 0) {
                self.configureVideoListView()
            }
        }
    }
    
    func showRemoveImageMessage() -> some View {
        
        return Text(removeUploadedPhotos_Message)
                .font(.footnote)
                .foregroundStyle(.accent)
    }
    
    func showRemoveVideosMessage() -> some View {
        
        return Text(removeUploadedVideos_Message)
                .font(.footnote)
                .foregroundStyle(.accent)
    }
    
    func configurePhotosListView() -> some View {
        
        return  VStack {
            HStack {
                Text(label_PhotosHeadingLabel)
                    .font(.headline)
                    .foregroundStyle(.accent)
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "plus.circle")
                        .font(.body)
                        .foregroundStyle(.accent)
                }
                .onTapGesture(perform: {
                    showingPhotoPicker.toggle()
                    debugPrint("Add Photos Button Tapped")
                })
            }
            .padding()
            .background(content: {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.accent.opacity(0.1))
            })
            photosItemList()
        }
    }
    
    func photosItemList() -> some View {
        return ScrollView(.horizontal) {
            HStack(spacing: 10) {
                
                ForEach(selectedPhotos.indices, id: \.self) { index in
                    
                    ZStack(alignment: .topTrailing) {
                        Image(uiImage: selectedPhotos[index])
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 90, height: 90)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 10)
                            )
                        
                        Button {
                            selectedPhotos.remove(at: index)
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
    
    func configureVideoListView() -> some View {
        
        return  VStack {
            HStack {
                Text(label_VideosHeadingLabel)
                    .font(.headline)
                    .foregroundStyle(.accent)
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "plus.circle")
                        .font(.body)
                        .foregroundStyle(.accent)
                }
                .onTapGesture(perform: {
                    self.showingVideoPicker = true
                    debugPrint("Add Videos Button Tapped")
                })
            }
            .padding()
            .background(content: {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.accent.opacity(0.1))
            })
            videosItemList()
        }
    }
    
    func videosItemList() -> some View {
        return ScrollView(.horizontal) {
            HStack(spacing: 10) {
                ForEach(selectedVideos.indices, id: \.self) { index in
                    ZStack(alignment: .center, content: {
                        
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "photos.square")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 90, height: 90)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 10)
                                )
                            
                            Button {
                                selectedVideos.remove(at: index)
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .resizable()
                                    .frame(width: 15, height: 15    )
                                    .foregroundColor(.white)
                                    .background(Circle().fill(Color.black.opacity(0.6)))
                                    .padding(3)
                            }
                        }
                        
                        Button {
                            
                        } label: {
                            VideoThumbnailView(videoURL: selectedVideos[index], size: 45)
                        }
                    })
                    
                }
            }
        }
    }
}

#Preview {
    AddRecipeView(dataReloadRequest: .constant(false))
}
