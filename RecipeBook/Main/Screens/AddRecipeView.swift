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
    @State var selectedCategory = "None"
    @State var selectedItems:[PhotosPickerItem] = []
    @State var selectedImages: [UIImage] = []
    @State var showWarningMessage: Bool = false
    @State var showingAddMediaDialog: Bool = false
    @State var showInformationRequiredAlert: Bool = false
    @State private var validationError: RecipeValidationError?
    @State private var levelSelection = 0
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
                        .frame(width: .infinity,height: 40.0)
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
                    
                })
                let primaryButton = BottomActionButton(title: "Add", action: handleAddAction)
                let secondaryButton = BottomActionButton(title: "Cancel", action: {
                    dismiss()
                })
                
                let bottomBtns = [primaryButton, secondaryButton]
                RecipeBottomActionBar(buttons: bottomBtns)
            }
        }
        .confirmationDialog(label_UploadMediaText, isPresented: $showingAddMediaDialog,titleVisibility: .visible , actions: {
            self.uploadMediaActionOptionsView()
        })
        .alert(popupTitle_InformationRequired, isPresented: $showInformationRequiredAlert) {
            Button("Dismiss", role: .cancel) {
                showInformationRequiredAlert = false
            }
        } message: {
            Text(validationError?.errorDescription ?? "An unknown error occurred.")
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
    
    private func handleAddAction() {
        do {
            try Validator.validateRecipe(
                title: recipeData.title,
                ingredients: recipeData.ingredients,
                instructions: recipeData.instructions,
                category: selectedCategory,
                prepTimeInHour:recipeData.preparationTimeInHours,
                prepTimeInMinute: recipeData.preparationTimeInMinutes,
                images: selectedImages
            )
            performSaveOperation()
            dismiss()
        } catch let error as RecipeValidationError {
            validationError = error
            showInformationRequiredAlert = true
        } catch {
            showInformationRequiredAlert = true
        }
    }
    
    private func performSaveOperation() {
        let datamanager = DataManager(modelContext: recipeModelContext)
        datamanager.insert(data: recipeData)
        recipeData.category = self.selectedCategory
        recipeData.level = self.levelSelection
        saveImagesLocally()
        dataReloadRequest.toggle()
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
    
    @ViewBuilder
    func uploadMediaActionOptionsView() -> some View {
        
        Button(action:{
            debugPrint("Camera option selected")
        }, label: {
            Text("Camera")
        })
        
        Button(action:{
            debugPrint("Photos option selected")
        }, label: {
            Text("Photos")
        })
        
        Button(action:{
            debugPrint("Videos option selected")
        }, label: {
            Text("Videos")
        })
    }
}

#Preview {
    AddRecipeView(dataReloadRequest: .constant(false))
}
