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
    
    @Bindable var recipeData: RecipeData
    @State private var selectedCategory: Category = .none
    @State var selectedItems:[PhotosPickerItem] = []
    @State private var selectedPhotos: [UIImage] = []
    @State private var selectedVideos: [URL] = []
    @State var showWarningMessage: Bool = false
    @State var showInformationRequiredAlert: Bool = false
    @State private var validationError: RecipeValidationError?
    @State private var cameraPicture: UIImage?
    
    //Defined categories
    private let categories = [
      "Beverage",
      "Meal",
      "Dessert",
      "Snacks",
      "Soup"
    ]
    
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
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    // MARK: - StateObjects
    
    @StateObject var videoManager = VideoStorageManager()
    
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
                    placeHolder: placeHolder_RecipeIngredients,
                    textData: $recipeData.ingredients
                )
                
                recipeInputView(
                    headLabelText: label_RecipeInstructionsText,
                    placeHolder: placeHolder_RecipeInstructions,
                    textData: $recipeData.instructions
                )
                
                VStack(alignment: .leading,spacing: 20.0, content: {
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
                })
                
                VStack(alignment: .leading,spacing: 20.0, content: {
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
        .photosPicker(
            isPresented: $showingPhotoPicker,
            selection: $selectedItems,
            maxSelectionCount: 5,
            matching: .images
        )
        .onChange(of: selectedItems, {
            selectedPhotos = []
            for item in selectedItems {
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
        .alert(popupTitle_InformationRequired, isPresented: $showInformationRequiredAlert) {
            Button("Dismiss", role: .cancel) {
                showingInformationRequiredAlert = false
            }
        } message: {
            Text(validationError?.errorDescription ?? "An unknown error occurred.")
        }
        .navigationTitle("Update Recipe")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            selectedCategory =
            Category.allCases.first {
                $0.title == recipeData.category
            } ?? .none
            loadRecipeImages()
            loadRecipeVideos()
            checkWarningMessageStatus()
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
            
            if selectedVideos.count > 4 {
                showRemoveVideosMessage()
            }
            
            self.mediaListView()
        }
    }

    @ViewBuilder
    private func bottomActions() -> some View {
        let primaryButton = BottomActionButton(title: "Update", action: { handleUpdate() })
        let secondaryButton = BottomActionButton(title: "Cancel", action: {
            dismiss()
        })
        
        let bottomBtns = [primaryButton, secondaryButton]
        RecipeBottomActionBar(buttons: bottomBtns)
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
        ScrollView(.horizontal, showsIndicators: false) {
            HStack() {
                
                ForEach(Array(selectedVideos.reversed()), id: \.self) { video in
                    ZStack(alignment: .topTrailing) {
                        Button {
                            
                        } label: {
                            VideoThumbnailView(videoURL: video, size: 90)
                                .frame(width: 90, height: 90)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }

                        Button {
                            
                            if let realIndex = selectedVideos.firstIndex(of: video) {
                                selectedVideos.remove(at: realIndex)
                                videoManager.removeVideoAt(path: video)
                            }
                            
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
    
    private func handleUpdate() {
        recipeData.category = selectedCategory.title
        do {
            try Validator.validateRecipe(
                title: recipeData.title,
                ingredients: recipeData.ingredients,
                instructions: recipeData.instructions,
                category: selectedCategory.title,
                prepTimeInHour:recipeData.preparationTimeInHours,
                prepTimeInMinute: recipeData.preparationTimeInMinutes,
                images: selectedPhotos
            )
            performUpdateOperation()
            dismiss()
        } catch let error as RecipeValidationError {
            validationError = error
            showInformationRequiredAlert = true
        } catch {
            showInformationRequiredAlert = true
        }
    }
    
    private func performUpdateOperation() {
        updateImagesLocally()
        updateVideosLocally()
        dismiss()
    }
    
    private func updateImagesLocally() {
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
    
    private func updateVideosLocally() {
        self.recipeData.videos.removeAll()
        for index in 0..<selectedVideos.count {
            self.recipeData.videos.append(self.selectedVideos[index].lastPathComponent)
        }
    }
    
    private func loadRecipeImages() {
        if($recipeData.imageNames.wrappedValue.count > 0) {
            self.photosSelected = true
        }
        let imageStorage = ImageStorageManager(recipeId: self.$recipeData.id)
        for index in 0..<$recipeData.imageNames.wrappedValue.count {
            
            if let uiImage = imageStorage.loadImageFromDocuments(name: $recipeData.imageNames.wrappedValue[index]) {
                self.selectedPhotos.append(uiImage)
            }
        }
    }
    
    private func loadRecipeVideos() {
        videoManager.loadSavedVideos(for: $recipeData.id)
        selectedVideos = videoManager.savedVideoURLs
    }
    
    private func removeRecipeImages(itemIndex: Int) {
        $recipeData.imageNames.wrappedValue.remove(at: itemIndex)
        selectedPhotos.remove(at: itemIndex)
    }
    
    private func removeRecipeVideo(itemIndex: Int) {
        $recipeData.imageNames.wrappedValue.remove(at: itemIndex)
        selectedPhotos.remove(at: itemIndex)
    }
    
    private func checkWarningMessageStatus() {
        if(selectedPhotos.count > 4) {
            showWarningMessage = true
        } else {
            showWarningMessage = false
        }
    }
    
    private func setBottomBar() {
        let primaryButton = BottomActionButton(title: "Update",action: {
            updateImagesLocally()
            dismiss()
        })
        let secondaryButton = BottomActionButton(title: "Cancel", action: {
            dismiss()
        })
        
        let bottomBtns = [primaryButton, secondaryButton]
        let _ = RecipeBottomActionBar(buttons: bottomBtns)
    }
    
    @ViewBuilder
    private func recipeInputView(headLabelText: LocalizedStringKey, placeHolder: LocalizedStringKey, textData: Binding<String>) -> some View{
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
}

#Preview {
    let tmpData = RecipeData(title: "Mango juice", ingredients: "...", instructions: "...", category: "Indian", level: 1, preparationTimeInHours: 1, preparationTimeInMinutes: 45, imageNames: ["",""], videos: [], isFavourite: false)
    EditRecipeView(recipeData: tmpData)
}
