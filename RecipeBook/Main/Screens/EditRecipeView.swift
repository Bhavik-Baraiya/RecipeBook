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
    @State var selectedCategory = "None"
    @State var selectedItems:[PhotosPickerItem] = []
    @State var selectedImages: [UIImage] = []
    @State var showWarningMessage: Bool = false
    @State var showInformationRequiredAlert: Bool = false
    @State private var validationError: RecipeValidationError?
    @Environment(\.dismiss) var dismiss
    
    //Defined categories
    private let categories = [
      "Beverage",
      "Meal",
      "Dessert",
      "Snacks",
      "Soup"
    ]
    
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
                    Text("\(label_SelectCategoryText): \($recipeData.category.wrappedValue)")
                        .font(.headline)
                    Picker(label_SelectedCategoryText, selection: $recipeData.category, content: {
                        ForEach(categories, id: \.self) { category in
                            Text(category)
                        }
                    })
                })
                
                VStack(alignment: .leading,spacing: 20.0, content: {
                    TimeSetterView(selectedHour: $recipeData.preparationTimeInHours, selectedMinutes: $recipeData.preparationTimeInMinutes)
                })
                
                VStack(alignment: .leading,spacing: 20.0, content: {
                    
                    Text(label_UpdatePicturesText)
                        .font(.headline)
                    Text(maxUploadWarning_Message)
                        .font(.footnote)
                        .foregroundStyle(.accent)
                    
                    
                    Group {
                        if selectedImages.count > 4 {
                        
                            if showWarningMessage {
                                Text(removeUploadedMedia_Message)
                                    .font(.footnote)
                                    .foregroundStyle(.accent)
                            }
                            
                            ScrollView(.horizontal) {
                                HStack(spacing: 10) {
                                    ForEach(selectedImages.indices, id: \.self) { index in
                                        
                                        ZStack(alignment: .topTrailing) {
                                            Image(uiImage: selectedImages[index])
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 90, height: 90)
                                                .clipShape(
                                                    RoundedRectangle(cornerRadius: 10)
                                                )
                                            
                                            Button {
                                                removeRecipeImages(itemIndex: index)
                                                checkWarningMessageStatus()
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
                        } else {
                            let imagesCount = $recipeData.imageNames.wrappedValue.count
                            let maxImageSelectionLimit = 5 - imagesCount
                            PhotosPicker("\(label_UploadText)", selection: $selectedItems, maxSelectionCount: maxImageSelectionLimit, matching: .images)
                                .buttonStyle(.bordered)
                            
                            if showWarningMessage {
                                Text(removeUploadedMedia_Message)
                                    .font(.footnote)
                                    .foregroundStyle(.accent)
                            }
                            
                            ScrollView(.horizontal) {
                                HStack(spacing: 10) {
                                    ForEach(selectedImages.indices, id: \.self) { index in
                                        
                                        ZStack(alignment: .topTrailing) {
                                            Image(uiImage: selectedImages[index])
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 90, height: 90)
                                                .clipShape(
                                                    RoundedRectangle(cornerRadius: 10)
                                                )
                                            
                                            Button {
                                                removeRecipeImages(itemIndex: index)
                                                checkWarningMessageStatus()
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
                    
                })
                .onChange(of: selectedItems, {
                    checkWarningMessageStatus()
                    Task {
                        
                        for index in 0..<selectedItems.count {
                            
                            do {
                                if let data = try await selectedItems[index].loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                    selectedImages.append(uiImage)
                                    $recipeData.imageNames.wrappedValue.append("\($recipeData.title.wrappedValue.lowercased())\(index)")
                                }
                            } catch {
                                print("Failed to load item: \(error.localizedDescription)")
                            }
                        }
                    }
                })
                let primaryButton = BottomActionButton(title: "Update",action:handleUpdate)
                let secondaryButton = BottomActionButton(title: "Cancel", action: {
                    dismiss()
                })
                
                let bottomBtns = [primaryButton, secondaryButton]
                RecipeBottomActionBar(buttons: bottomBtns)
            }
        }
        .alert(popupTitle_InformationRequired, isPresented: $showInformationRequiredAlert) {
            Button("Dismiss", role: .cancel) {
                showInformationRequiredAlert = false
            }
        } message: {
            Text(validationError?.errorDescription ?? "An unknown error occurred.")
        }
        .navigationTitle("Update Recipe")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            loadRecipeImages()
            checkWarningMessageStatus()
        })
    }
    
    private func handleUpdate() {
        do {
            try Validator.validateRecipe(
                title: recipeData.title,
                ingredients: recipeData.ingredients,
                instructions: recipeData.instructions,
                category: recipeData.category,
                prepTimeInHour:recipeData.preparationTimeInHours,
                prepTimeInMinute: recipeData.preparationTimeInMinutes,
                images: selectedImages
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
        dismiss()
    }
    
    private func updateImagesLocally() {
        $recipeData.imageNames.wrappedValue.removeAll()
        for index in 0..<selectedImages.count {
            ImageStorageManager.saveImageToDocuments(
                image: selectedImages[index],
                name: "\($recipeData.title.wrappedValue.lowercased())\(index)"
            )
            $recipeData.imageNames.wrappedValue.append("\($recipeData.title.wrappedValue.lowercased())\(index)")
        }
    }
    
    private func loadRecipeImages() {
        for index in 0..<$recipeData.imageNames.wrappedValue.count {
            if let uiImage = ImageStorageManager.loadImageFromDocuments(name: $recipeData.imageNames.wrappedValue[index]) {
                self.selectedImages.append(uiImage)
            }
        }
    }
    
    private func removeRecipeImages(itemIndex: Int) {
        $recipeData.imageNames.wrappedValue.remove(at: itemIndex)
        selectedImages.remove(at: itemIndex)
    }
    
    private func checkWarningMessageStatus() {
        if(selectedImages.count > 4) {
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
    private func recipeInputView(headLabelText: String, placeHolder: String, textData: Binding<String>) -> some View{
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
    
    do {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let modelContainer = try ModelContainer(for: RecipeData.self, configurations: configuration)
        let tmpData = RecipeData(title: "Mango juice", ingredients: "...", instructions: "...", category: "Indian", preparationTimeInHours: 1, preparationTimeInMinutes: 45, imageNames: ["",""], isFavourite: false)
        return EditRecipeView(recipeData: tmpData)
            .modelContainer(modelContainer)
        
        
    } catch {
        fatalError("Error in model configuration")
    }
}
