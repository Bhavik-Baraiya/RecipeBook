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
    @State var selectedCategory = "Indian"
    @State var selectedItems:[PhotosPickerItem] = []
    @State var selectedImages: [UIImage] = []
    @State var showWarningMessage: Bool = false
    @Environment(\.dismiss) var dismiss
    
    //Defined categories
    private let categories = [
        "Indian",
        "Italian",
        "Breakfast",
        "Salad",
        "Dessert"
    ]
    
    var body: some View {
        
        VStack {
            Form {
                VStack(alignment: .leading,spacing: 20.0, content: {
                    Text("Recipe title")
                        .font(.headline)
                    TextField("Enter recipe title", text: $recipeData.title)
                        .tint(.accentColor)
                })
                
                VStack(alignment: .leading,spacing: 20.0, content: {
                    Text("Recipe ingredients ")
                        .font(.headline)
                    
                    ZStack(alignment: .leading) {
                        if $recipeData.ingredients.wrappedValue.isEmpty {
                            Text("Enter recipe ingredients")
                                .font(.custom("Helvetica", size: 16))
                                .padding(.all)
                                .foregroundStyle(Color.secondary.opacity(0.5))
                                .offset(x:0, y: -4)
                        }
                            
                        TextEditor(text: $recipeData.ingredients)
                            .font(.callout)
                            .padding(10)
                        
                    }
                })
                
                VStack(alignment: .leading,spacing: 20.0, content: {
                    Text("Recipe instructions ")
                        .font(.headline)
                    
                    ZStack(alignment: .leading) {
                        if $recipeData.instructions.wrappedValue.isEmpty {
                            Text("Enter recipe instructions")
                                .font(.custom("Helvetica", size: 16))
                                .padding(.all)
                                .foregroundStyle(Color.secondary.opacity(0.5))
                                .offset(x:0, y: -4)
                        }
                            
                        TextEditor(text: $recipeData.instructions)
                            .font(.callout)
                            .padding(10)
                    }
                })
                
                VStack(alignment: .leading,spacing: 20.0, content: {
                    Text("You Selected: \(selectedCategory)")
                        .font(.headline)
                    Picker("Select category", selection: $recipeData.category, content: {
                        ForEach(categories, id: \.self) { category in
                            Text(category)
                        }
                    })
                })
                
                VStack(alignment: .leading,spacing: 20.0, content: {
                    TimeSetterView(selectedHour: $recipeData.preparationTimeInHours, selectedMinutes: $recipeData.preparationTimeInMinutes)
                })
                
                VStack(alignment: .leading,spacing: 20.0, content: {
                    
                    Text("Update pictures")
                        .font(.headline)
                    Text("*You can upload maximum 5 pictures")
                        .font(.footnote)
                        .foregroundStyle(.accent)
                    
                    
                    Group {
                        if selectedImages.count > 4 {
                        
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
                            PhotosPicker("Update pictures", selection: $selectedItems, maxSelectionCount: maxImageSelectionLimit, matching: .images)
                                .buttonStyle(.bordered)
                            
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

            }
            
            Spacer()
            
            HStack {
                Spacer()
                Button(action: {
                    debugPrint("Discarded")
                    updateImagesLocally()
                    dismiss()
                })
                {
                    Text("Update")
                        .foregroundStyle(Color.primary)
                        .padding(10)
                }
                .buttonStyle(.bordered)
                
                Spacer()
                
                Button(action: {
                    dismiss()
                    debugPrint("Discarded")
                })
                {
                    Text("Cancel")
                        .foregroundStyle(.accent)
                        .padding(10)
                }
                .buttonStyle(.bordered)
                Spacer()
            }
            
            Spacer()
        }
        .background(
            .thinMaterial
        )
        .navigationTitle("Update Recipe")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            loadRecipeImages()
            checkWarningMessageStatus()
        })
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
