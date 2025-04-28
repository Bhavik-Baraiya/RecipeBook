//
//  DetailsView.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 24/03/25.
//

import SwiftUI

struct DetailsView: View {
    
    var recipeData: RecipeData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 50, content: {
            
            VStack(alignment:.leading,spacing: 10) {
                Text("Prepared In:")
                    .font(.title3)
                Text("\(recipeData.preparationTimeInHours):\(recipeData.preparationTimeInMinutes)")
                    .font(.callout)
            }
            
            VStack(alignment:.leading,spacing: 10) {
                Text("Ingredients:")
                    .font(.title3)
                Text(recipeData.ingredients)
                    .font(.callout)
            }
            
            VStack(alignment:.leading,spacing: 10) {
                Text("Instructions:")
                    .font(.title3)
                Text(recipeData.instructions)
                    .font(.callout)
            }
        })
    }
}

#Preview {
    DetailsView(recipeData: RecipeData(title: "", ingredients: "", instructions: "", category: "", preparationTimeInHours: 0, preparationTimeInMinutes: 1, imageNames: [""], isFavourite: true))
}
