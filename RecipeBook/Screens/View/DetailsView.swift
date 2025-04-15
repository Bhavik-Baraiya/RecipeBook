//
//  DetailsView.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 24/03/25.
//

import SwiftUI

struct DetailsView: View {
    
    var recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 50, content: {
            
            VStack(alignment:.leading,spacing: 10) {
                Text("Prepared In:")
                    .font(.title3)
                Text("\(recipe.preparationTimeInHours):\(recipe.preparationTimeInMinutes)")
                    .font(.callout)
            }
            
            VStack(alignment:.leading,spacing: 10) {
                Text("Ingredients:")
                    .font(.title3)
                Text(recipe.ingredients)
                    .font(.callout)
            }
            
            VStack(alignment:.leading,spacing: 10) {
                Text("Instructions:")
                    .font(.title3)
                Text(recipe.instructions)
                    .font(.callout)
            }
        })
    }
}

#Preview {
    DetailsView(recipe: recipeData.first!)
}
