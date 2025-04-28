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
            
            VStack(alignment:.center) {
                
                let imageName = $recipeData.imageNames.wrappedValue.count > 0 ? $recipeData.imageNames.wrappedValue[0] : ""
                let uiImage = ImageStorageManager.loadImageFromDocuments(name: imageName)
                let image = uiImage != nil ? Image(uiImage: uiImage!) : Image(systemName: "")
        
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .background(Color(Utilities.getRandomPlaceHolderColor())
                        .cornerRadius(20))
                
                VStack(alignment: .center) {
                    Text($recipeData.title.wrappedValue)
                        .font(.subheadline)
                        .fontWeight(.heavy)
                        .foregroundColor(.accent)
                        .frame(minWidth: 50)
                    
                    Spacer()
                    
                    HStack(alignment:.center) {
                        Text($recipeData.category.wrappedValue)
                            .font(.title)
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
                        
                }.frame(width: 170,height: 100)
                    
            }
        }
    }
}

#Preview {
    RecipeListItemGridCell(recipeData: RecipeData(title: "", ingredients: "", instructions: "", category: "", preparationTimeInHours: 0, preparationTimeInMinutes: 1, imageNames: [""], isFavourite: true))
}
