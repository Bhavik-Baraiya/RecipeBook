//
//  FavouriteRecipeListView.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 22/03/25.
//

import SwiftData
import SwiftUI

struct FavouriteRecipeListView: View {
    
    @Query var recipeData: [RecipeData]
    
    var body: some View {
        NavigationView(content: {
            
            let favouriteRecipes = recipeData.filter({ $0.isFavourite == true })
            
            if(favouriteRecipes.count > 0) {
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
                        .font(.title)
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
    FavouriteRecipeListView()
}
