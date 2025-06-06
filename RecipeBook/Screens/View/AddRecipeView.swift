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
        "Indian",
        "Italian",
        "French",
        "Chinese"
    ]
    
    var body: some View {
        
        VStack {
            Form {
                
                recipeInputView(
                    headLabelText: "Recipe title",
                    placeHolder: "Enter recipe title",
                    textData: $recipeData.title
                )
                
                recipeInputView(
                    headLabelText: "Recipe ingredients",
                    placeHolder: "Enter recipe ingredients",
                    textData: $recipeData.ingredients
                )
                
                recipeInputView(
                    headLabelText: "Recipe instructions",
                    placeHolder: "Enter recipe instructions",
                    textData: $recipeData.instructions
                )
                
                VStack(alignment: .leading,spacing: 20.0, content: {
                    
                    Picker("Select category", selection: self.$selectedCategory, content: {
                        ForEach(categories, id: \.self) { category in
                            Text(category)
                        }
                    })
                    Text("You Selected: \(self.selectedCategory)")
                        .font(.headline)
                })
                
                VStack(alignment: .leading,spacing: 0, content: {
                    TimeSetterView(selectedHour: $recipeData.preparationTimeInHours, selectedMinutes: $recipeData.preparationTimeInMinutes)
                })
                
                VStack(alignment: .leading,spacing: 20.0, content: {
                    
                    Text("Update pictures")
                        .font(.headline)
                    Text("*You can upload maximum 5 pictures")
                        .font(.footnote)
                        .foregroundStyle(.accent)
                    
                    if $recipeData.imageNames.wrappedValue.count > 4 {
                    
                        if showWarningMessage {
                            Text("You have to remove the addded photos in order to update")
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
                        PhotosPicker("Add pictures", selection: $selectedItems, maxSelectionCount: maxImageSelectionLimit, matching: .images)
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
