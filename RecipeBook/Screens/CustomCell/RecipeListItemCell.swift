//
//  RecipeListItemCell.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 22/03/25.
//

import SwiftUI

struct RecipeListItemCell: View {
    
    var recipeData: Recipe
    
    var body: some View {
        HStack() {
            Image(recipeData.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 120,height: 120)
                .clipShape(
                    RoundedRectangle(cornerRadius: 12)
                )
            
            VStack(alignment: .leading) {
                Text(recipeData.title)
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundColor(.accent)
                
                Text(recipeData.ingredients)
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
                    .lineLimit(5)
            }
        }
    }
}

#Preview {
    RecipeListItemCell(recipeData: recipeData.first!)
}
