//
//  DetailsView.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 24/03/25.
//

import SwiftUI

struct RecipeHeaderViewContent {
    var id: UUID = UUID()
    var systemImage: String
    var title: String
}

struct RecipeBodyViewContent {
    var heading: String
    var content: String
}

struct DetailsView: View {
    
    var recipeData: RecipeData
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 15, content: {
            
            recipeBody(iconImage: "tag.fill",headline: "Category:", content: recipeData.category)
            recipeBody(iconImage: "checklist.checked",headline: "Ingredients:", content: recipeData.ingredients)
            recipeBody(iconImage: "list.triangle",headline: "Instructions:", content: recipeData.instructions)
        })
        .padding()
    }
    
    @ViewBuilder
    private func recipeBody(iconImage:String, headline: String, content: String) -> some View {
        
        VStack(alignment:.leading,spacing: 10) {
            
            HStack {
                Image(systemName: iconImage)
                Text(headline)
                Spacer()
            }
            .bodyTitleStyle()
            
            Text(content.isEmpty ? "No data available" : content)
                .bodyTextStyle()
        }
        .padding()
        .background(
            .thinMaterial
        )
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    DetailsView(recipeData: RecipeData(title: "", ingredients: "", instructions: "", category: "", level: 1, preparationTimeInHours: 0, preparationTimeInMinutes: 1, imageNames: [""], videos: [], isFavourite: true))
}
