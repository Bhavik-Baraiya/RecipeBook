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
    
    var prepTime: String {
        "\(recipeData.preparationTimeInHours):\(recipeData.preparationTimeInMinutes)"
    }
    var body: some View {
        
        VStack(alignment: .leading, spacing: 5, content: {
            
            recipeHeaderView()
            recipeBody(headline: "Category:", content: recipeData.category)
            recipeBody(headline: "Description:", content: recipeData.instructions)
            recipeBody(headline: "Ingredients:", content: recipeData.ingredients)
            recipeBody(headline: "Instructions:", content: recipeData.instructions)
        })
        .padding()
    }
    
    @ViewBuilder
    private func recipeHeaderView() -> some View {
        
        let headerData = [
            RecipeHeaderViewContent(systemImage: "clock", title: prepTime),
            RecipeHeaderViewContent(systemImage: "person", title: "1-2"),
            RecipeHeaderViewContent(systemImage: "fork.knife", title: "Desert"),
        ]
        
        HStack(alignment:.center, spacing: 20) {
            
            ForEach(headerData, id: \.id) { item in
                self.getHeaderImageText(imageName: item.systemImage, title: item.title)
            }
            
            Spacer()
            
            Button(action: {
                
            }, label: {
                Image(systemName: "heart")
            })
        }
        .padding()
    }
    
    
    func getHeaderImageText(imageName:String,title: String) -> some View{
       HStack(spacing: 5) {
        Image(systemName: imageName)
        Text(title)
       }
    }
    
    @ViewBuilder
    private func recipeBody(headline: String, content: String) -> some View {
        VStack(alignment:.leading,spacing: 10) {
            Text(headline)
                .font(.title3)
                .fontWeight(.bold)
            Text(content)
                .font(.subheadline)
                .multilineTextAlignment(.leading)
        }.padding()
    }
}

#Preview {
    DetailsView(recipeData: RecipeData(title: "", ingredients: "", instructions: "", category: "", preparationTimeInHours: 0, preparationTimeInMinutes: 1, imageNames: [""], isFavourite: true))
}
