//
//  UpdateRecipeView.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 31/03/25.
//

import SwiftUI
import PhotosUI

struct UpdateRecipeView: View {
    
    @State var recipeTitle: String
    @State var recipeIngredients : String
    @State var recipeInstructions : String
    @State var selectedCategory: String
    @State var preparationTimeInHour: Int
    @State var preparationTimeInMinutes: Int
    @State var recipeImages: [String]
    @State var selectedItems:[PhotosPickerItem] = []
    @State var selectedImages: [Image] = []
    @Environment(\.dismiss) var dismiss
    
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
                    TextField("Enter recipe title", text: $recipeTitle)
                        .tint(.accentColor)
                })
                
                VStack(alignment: .leading,spacing: 20.0, content: {
                    Text("Recipe ingredients ")
                        .font(.headline)
                    
                    ZStack(alignment: .leading) {
                        if recipeIngredients.isEmpty {
                            Text("Enter recipe ingredients")
                                .font(.custom("Helvetica", size: 16))
                                .padding(.all)
                                .foregroundStyle(Color.secondary.opacity(0.5))
                                .offset(x:0, y: -4)
                        }
                            
                        TextEditor(text: $recipeIngredients)
                            .font(.callout)
                            .padding(10)
                        
                    }
                })
                
                VStack(alignment: .leading,spacing: 20.0, content: {
                    Text("Recipe instructions ")
                        .font(.headline)
                    
                    ZStack(alignment: .leading) {
                        if recipeInstructions.isEmpty {
                            Text("Enter recipe instructions")
                                .font(.custom("Helvetica", size: 16))
                                .padding(.all)
                                .foregroundStyle(Color.secondary.opacity(0.5))
                                .offset(x:0, y: -4)
                        }
                            
                        TextEditor(text: $recipeInstructions)
                            .font(.callout)
                            .padding(10)
                    }
                })
                
                VStack(alignment: .leading,spacing: 20.0, content: {
                    Text("You Selected: \(selectedCategory)")
                        .font(.headline)
                    Picker("Select category", selection: $selectedCategory, content: {
                        ForEach(categories, id: \.self) { category in
                            Text(category)
                        }
                    })
                })
                
                VStack(alignment: .leading,spacing: 20.0, content: {
                    TimeSetterView(selectedHour: $preparationTimeInHour, selectedMinutes: $preparationTimeInMinutes)
                })
                
                VStack(alignment: .leading,spacing: 20.0, content: {
                    Text("Update pictures")
                        .font(.headline)
                    
                    PhotosPicker("Select Photos", selection: $selectedItems, maxSelectionCount: 5, matching: .images)
                        .buttonStyle(.bordered)
                    ScrollView(.horizontal) {
                        HStack(spacing: 10) {
                            ForEach(selectedImages.indices, id: \.self) { index in
                                
                                ZStack(alignment: .topTrailing) {
                                    selectedImages[index]
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
                })
                
                HStack(spacing: 120, content: {
                    
                    Button(action: {
                        debugPrint("Updated")
                    }) {
                        Text("Update")
                            .foregroundStyle(Color.primary)
                            .padding(10)
                    }.buttonStyle(.bordered)
                    
                    Button(action: {
                        debugPrint("Discarded")
                        dismiss()
                    }) {
                        Text("Cancel")
                            .foregroundStyle(.accent)
                            .padding(10)
                    }.buttonStyle(.bordered)
                })
                .onChange(of: selectedItems, {
                    Task {
                        selectedImages.removeAll()
                        for item in selectedItems {
                            do {
                                if let data = try await item.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                    selectedImages.append(Image(uiImage: uiImage))
                                }
                            } catch {
                                print("Failed to load item: \(error.localizedDescription)")
                            }
                        }
                    }
                })

            }
        }
        .navigationTitle("Update Recipe")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            for index in 0..<recipeImages.count {
                if let uiImage = ImageStorageManager.loadImageFromDocuments(name: recipeImages[index]) {
                    self.selectedImages.append(Image(uiImage: uiImage))
                }
            }
        })
    }
}

#Preview {
    
    UpdateRecipeView(recipeTitle: recipeData[0].title, recipeIngredients: recipeData[0].ingredients, recipeInstructions: recipeData[0].instructions, selectedCategory: recipeData[0].category, preparationTimeInHour: recipeData[0].preparationTimeInHours, preparationTimeInMinutes: recipeData[0].preparationTimeInMinutes, recipeImages: recipeData[0].images)
}
