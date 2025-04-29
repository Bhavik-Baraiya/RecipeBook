//
//  FavouriteRecipeListView.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 22/03/25.
//

import SwiftData
import SwiftUI

struct FavouriteRecipeListView: View {
    
    @Query var recipes: [RecipeData]
    
    //Computed properties for favourites
    var favoriteRecipes: [RecipeData] {
        recipes.filter { $0.isFavourite }
    }
    
    var body: some View {
        NavigationView(content: {
            
            if(favoriteRecipes.isEmpty) {
                
                ContentUnavailableView(
                            "No favourite recipe available",
                            systemImage: "heart.slash",
                            description: Text("Tap on heart button on recipe item to add entry here")
                ).foregroundStyle(.accent)
                
            } else {
                
                List {
                    ForEach(favoriteRecipes) { recipeItem in
                        
                        NavigationLink(destination: RecipeView(recipe: recipeItem)){
                            
                            RecipeListItemCell(recipeData: recipeItem)
                            
                        }.buttonStyle(PlainButtonStyle())
                    }
                    .navigationTitle("Favourites")
                    .navigationBarTitleDisplayMode(.large)
                }
            }
        })
    }
}

#Preview {
    FavouriteRecipeListView()
}
