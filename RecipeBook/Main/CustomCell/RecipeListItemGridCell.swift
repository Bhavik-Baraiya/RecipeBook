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
                    .frame(width: 150,height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .background(Color(Utilities.getRandomPlaceHolderColor())
                        .cornerRadius(20))
                
                VStack(alignment: .leading) {
                    Text($recipeData.title.wrappedValue)
                        .font(.title3)
                        .fontWeight(.heavy)
                        .foregroundColor(.accent)
                        .frame(minWidth: 90)
                    
                    Spacer().frame(height: 20)
                    
                    HStack(alignment:.center) {
                        Text($recipeData.category.wrappedValue)
                            .font(.headline)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                            .lineLimit(5)
                        
                        Spacer()
                        
                        Button(action: {
                            $recipeData.isFavourite.wrappedValue.toggle()
                        }) {
                            Image(systemName: $recipeData.isFavourite.wrappedValue ? "heart.fill": "heart")
                                .resizable()
                                .scaledToFill()
                        }.frame(width: 25,height: 25)
                    }
                }
            }.frame(width: 150,height: 220)
        }
    }
}

#Preview {
    RecipeListItemGridCell(recipeData: RecipeData(title: "Sample Recipe", ingredients: "", instructions: "", category: "Salad", preparationTimeInHours: 0, preparationTimeInMinutes: 1, imageNames: [""], isFavourite: true))
}
