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
    
    @State var recipeData = RecipeData()
    @State var selectedCategory = "Indian"
    @State var selectedItems:[PhotosPickerItem] = []
    @State var selectedImages: [UIImage] = []
    @State var showWarningMessage: Bool = false
    @Binding var dataReloadRequest: Bool
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var recipeModelContext
    
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
                    placeHolder: placeHolder_RecipeIngredients.capitalized,
                    textData: $recipeData.ingredients
                )
                
                recipeInputView(
                    headLabelText: label_RecipeInstructionsText,
                    placeHolder: placeHolder_RecipeInstructions.capitalized,
                    textData: $recipeData.instructions
                )
                
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
                    
                    Text(label_AddPicturesText)
                        .font(.headline)
                    Text(maxUploadWarning_Message)
                        .font(.footnote)
                        .foregroundStyle(.accent)
                    
                    if $recipeData.imageNames.wrappedValue.count > 4 {
                    
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
                                            selectedImages.remove(at: index)
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
                        let maxImageSelectionLimit = 5
                        PhotosPicker(label_UploadText, selection: $selectedItems, maxSelectionCount: maxImageSelectionLimit, matching: .images)
                            .buttonStyle(.bordered)
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
                                            selectedImages.remove(at: index)
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
                })
                .onChange(of: selectedItems, {
                    checkWarningMessageStatus()
                    Task {
                       for item in selectedItems {
                            do {
                                if let data = try await item.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                    selectedImages.append(uiImage)
                                }
                            } catch {
                                print("Failed to load item: \(error.localizedDescription)")
                            }
                        }
                    }
                })
                let primaryButton = BottomActionButton(title: "Add",action: {
                    let datamanager = DataManager(modelContext: recipeModelContext)
                    recipeData.category = self.selectedCategory
                    datamanager.insert(data: recipeData)
                    saveImagesLocally()
                    dataReloadRequest.toggle()
                    dismiss()
                })
                let secondaryButton = BottomActionButton(title: "Cancel", action: {
                    dismiss()
                })
                
                let bottomBtns = [primaryButton, secondaryButton]
                RecipeBottomActionBar(buttons: bottomBtns)
            }
        }
        .navigationTitle("Add Recipe")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            for index in 0..<$recipeData.imageNames.wrappedValue.count {
                if let uiImage = ImageStorageManager.loadImageFromDocuments(name: $recipeData.imageNames.wrappedValue[index]) {
                    self.selectedImages.append(uiImage)
                }
            }
            checkWarningMessageStatus()
        })
    }
    
    private func saveImagesLocally() {
        $recipeData.imageNames.wrappedValue.removeAll()
        for index in 0..<selectedImages.count {
            ImageStorageManager.saveImageToDocuments(
                image: selectedImages[index],
                name: "\($recipeData.title.wrappedValue.lowercased())\(index)"
            )
            $recipeData.imageNames.wrappedValue.append("\($recipeData.title.wrappedValue.lowercased())\(index)")
        }
    }
    
    private func checkWarningMessageStatus() {
        if(selectedImages.count > 4) {
            showWarningMessage = true
        } else {
            showWarningMessage = false
        }
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
    AddRecipeView(dataReloadRequest: .constant(false))
}
