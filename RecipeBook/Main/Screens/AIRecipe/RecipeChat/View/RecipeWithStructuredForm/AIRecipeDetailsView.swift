//
//  AIRecipeDetailsView.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 24/03/25.
//

import SwiftUI

@available(iOS 26.0, *)
struct AIRecipeDetailsView: View {
    
    var recipeData: RecipeGenerative.PartiallyGenerated
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 15, content: {
            if let recipeTitle = self.recipeData.title,
               let recipeCategory = self.recipeData.category,
               let ingredients = self.recipeData.ingredients,
               let instructions = self.recipeData.instructions,
               let suggestions = self.recipeData.suggestions {
                recipeBody(iconImage: "fork.knife.circle.fill",headline: "Dish:", content: recipeTitle)
                recipeBody(iconImage: "tag.fill",headline: "Category:", content: recipeCategory)
                recipeBody(iconImage: "checklist.checked",headline: "Ingredients:", content: ingredients)
                recipeBody(iconImage: "list.triangle",headline: "Instructions:", content: instructions)
                recipeBody(iconImage: "lightbulb.min.fill",headline: "Suggestions:", content: suggestions)
            }
        })
        .padding()
    }
    
    @ViewBuilder
    private func recipeBody(iconImage:String, headline: LocalizedStringKey, content: String) -> some View {
        
        VStack(alignment:.leading,spacing: 10) {
            
            HStack {
                Image(systemName: iconImage)
                Text(headline)
                    .animation(.easeInOut, value: headline)
                Spacer()
            }
            .bodyTitleStyle()
            Text(LocalizedStringKey(content.isEmpty ? "No data available" : content))
                .bodyTextStyle()
                .animation(.easeInOut, value: content)
        }
        .padding()
        .background(
            .thinMaterial
        )
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
//    DetailsView(recipeData: Recipe.mockData)
}
