//
//  RecipeView.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 22/03/25.
//

import SwiftUI

struct RecipeView: View {
    
    let recipe: Recipe
    @State var displayPopup: Bool = false
    
    var body: some View {
            
            ZStack {
                ScrollView(.vertical) {
                    
                    VStack(spacing: 40) {
                        
                        BannerView(images: ["ABC1","rasgulla1"])
                            .frame(height: 300)
                            .padding(20)
                        
                        
                        Text(recipe.category)
                            .font(.title)
                            .foregroundColor(.primary)
                            .background(
                                Color.accentColor
                                    .frame(height: 5)
                                    .offset(y:20)
                            )
                            .padding(.horizontal)
                        
                        DetailsView(recipe: recipe)
                        
                        Spacer()
                    }
                }
                
                if(displayPopup) {
                    DeletePopupView(isPopupDisplayed: $displayPopup)
                }
            }
            .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    HStack {
                        
                        Button(action: {
                            displayPopup = true
                        }) {
                            Image(systemName: "trash")
                                .imageScale(.medium)
                        }
                        
                        NavigationLink {
                            
                            UpdateRecipeView(recipeTitle: recipe.title, recipeIngredients: recipe.ingredients, recipeInstructions: recipe.instructions, selectedCategory: recipe.category, preparationTimeInHour: recipe.preparationTimeInHours, preparationTimeInMinutes: recipe.preparationTimeInMinutes)
                            
                        } label: {
                            
                            HStack {
                                Image(systemName: "pencil.circle")
                                    .imageScale(.large)
                                    .foregroundColor(.accentColor)
                                
                            }
                            .padding(0)
                        }
                    }
                }
                
        }
        .navigationTitle(recipe.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    RecipeView(recipe: recipeData.first!)
}
