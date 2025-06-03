//
//  RecipeView.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 22/03/25.
//

import SwiftUI

struct RecipeView: View {
    
    @Bindable var recipe: RecipeData
    @State var displayPopup: Bool = false
    
    var body: some View {
            
            ZStack {
                
                ScrollView(.vertical) {
                    
                    VStack(spacing: 20) {
                        BannerView(images: $recipe.imageNames.wrappedValue)
                            .frame(height: 300)
                            .padding(.horizontal, 5)
                        DetailsView(recipeData: recipe)
                    }
                }
                
                if(displayPopup) {
                    DeletePopupView(isPopupDisplayed: $displayPopup, recipeData: recipe)
                }
            }
            .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    HStack {
                        
                        Button(action: {
                            displayPopup.toggle()
                        }) {
                            Image(systemName: "trash")
                                .imageScale(.medium)
                        }
                        
                        NavigationLink {
                            
                            EditRecipeView(recipeData: recipe)
                            
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
    RecipeView(recipe: RecipeData(title: "Spaghetti Carbonara",
                                  ingredients: """
                                                    - 200g spaghetti
                                                    - 100g pancetta
                                                    - 2 large eggs
                                                    - 50g Parmesan cheese
                                                    - Salt and pepper
                                                    """,
                                  instructions: """
                                                    1. Cook spaghetti in salted water.
                                                    2. Fry pancetta until crispy.
                                                    3. Beat eggs and mix with Parmesan.
                                                    4. Mix spaghetti with pancetta and egg mixture.
                                                    5. Serve immediately.
                                                    """,
                                  category: "Italian",
                                  preparationTimeInHours: 10,
                                  preparationTimeInMinutes: 15,
                                  imageNames: [""],
                                  isFavourite: true)
    )
}
