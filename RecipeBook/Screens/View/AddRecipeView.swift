//
//  AddRecipeView.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 28/03/25.
//

import SwiftUI
import PhotosUI

struct AddRecipeView: View {
    
    @State private var recipeTitle: String = ""
    @State private var recipeIngredients : String = ""
    @State private var recipeInstructions : String = ""
    @State private var selectedCategory: String = "Indian"
    @State private var selectedHour: Int = 0
    @State private var selectedMinute: Int = 0
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImages: [Image] = []
    @State private var showTimePicker = false
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
                    TimeSetterView(selectedHour: $selectedHour, selectedMinutes: $selectedMinute)
                })
                
                VStack(alignment: .leading,spacing: 20.0, content: {
                    Text("Upload pictures")
                        .font(.headline)
                    
                    PhotosPicker("Select Photos", selection: $selectedItems, maxSelectionCount: 10, matching: .images)
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
                HStack(alignment:.center, spacing: 120, content: {
                    
                    Button(action: {
                        debugPrint("Added")
                    }) {
                        Text("Add")
                            .foregroundStyle(Color.primary)
                            .padding(10)
                    }.buttonStyle(.bordered)
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Discard")
                            .foregroundStyle(.accent)
                            .padding(10)
                    }.buttonStyle(.bordered)
                })
                .padding()
                .frame(width: 350, height: 90, alignment: .center)
                .onChange(of: selectedItems) {
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
                }
            }
         }
        .navigationTitle("Add Recipe")
        .navigationBarTitleDisplayMode(.inline)
        
        
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
}

#Preview {
    AddRecipeView()
}
