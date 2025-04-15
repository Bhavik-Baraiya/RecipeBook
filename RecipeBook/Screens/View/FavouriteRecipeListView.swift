//
//  FavouriteRecipeListView.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 22/03/25.
//

import SwiftUI

struct FavouriteRecipeListView: View {
    
    var favouriteRecipes: [Recipe]
    
    var body: some View {
        NavigationView(content: {
            
            if(favouriteRecipes.count > 1) {
                List {
                    ForEach(favouriteRecipes) { item in
                        
                        NavigationLink(destination: RecipeView(recipe: item)){
                            
                            RecipeListItemCell(recipeData: item)
                            
                        }.buttonStyle(PlainButtonStyle())
                    }
                    .navigationTitle("Favourites")
                    .navigationBarTitleDisplayMode(.large)
                }
            } else {
                
                VStack(alignment: .center, spacing: 50, content: {
                    
                    Text("No favourite recipe available!")
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.accentColor)
                    
                    
                    
                    Text("Tap on heart icon at recipe list screen or recipe screen to see your favourite recipes seprate here")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.accentColor)
                        .multilineTextAlignment(.center)
                    
                }).frame(width: 300)
                    
                    
                
                
            }
            
            
        })
    }
}

#Preview {
    FavouriteRecipeListView(favouriteRecipes: recipeData)
}
