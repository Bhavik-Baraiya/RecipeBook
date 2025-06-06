//
//  RecipeListItemGridCell.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 27/03/25.
//

import SwiftUI

struct RecipeListItemGridCell: View {
    
    @Bindable var recipeData: RecipeData
    
    var body: some View {
        
        GroupBox {
            
            VStack(alignment:.leading) {
                
                let imageName = $recipeData.imageNames.wrappedValue.count > 0 ? $recipeData.imageNames.wrappedValue[0] : ""
                let uiImage = ImageStorageManager.loadImageFromDocuments(name: imageName)
                let image = uiImage != nil ? Image(uiImage: uiImage!) : Image(systemName: "")
        
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 130, height: 140)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .background(Color(Utilities.getRandomPlaceHolderColor())
                        .cornerRadius(20))
                
                VStack(alignment: .leading) {
                    Text($recipeData.title.wrappedValue)
                        .font(.title3)
                        .fontWeight(.heavy)
                        .foregroundColor(.accent)
                        .frame(minWidth: 50)
                    
                    Spacer().frame(height: 20)
                    
                    HStack(alignment:.center,spacing: 50) {
                        Text($recipeData.category.wrappedValue)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                            .lineLimit(5)
                        
                        Button(action: {
                            $recipeData.isFavourite.wrappedValue.toggle()
                        }) {
                            Image(systemName: $recipeData.isFavourite.wrappedValue ? "heart.fill": "heart")
                                .resizable()
                                .scaledToFill()
                        }.frame(width: 25,height: 25)
                    }.frame(width: 130)
                }
            }.frame(width: 150,height: 220)
        }
    }
}

#Preview {
    RecipeListItemGridCell(recipeData: RecipeData(title: "Apple Juice", ingredients: "", instructions: "", category: "Salad", preparationTimeInHours: 0, preparationTimeInMinutes: 1, imageNames: [""], isFavourite: true))
}
