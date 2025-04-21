//
//  RecipeListItemGridCell.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 27/03/25.
//

import SwiftUI

struct RecipeListItemGridCell: View {
    
    var recipeData: Recipe
    
    @State var isFavourite: Bool = false
    
    var body: some View {
        
        GroupBox {
            
            VStack(alignment:.center) {
                
                let uiImage = ImageStorageManager.loadImageFromDocuments(name: recipeData.images[0])
                let image = uiImage != nil ? Image(uiImage: uiImage!) : Image(systemName: "")
        
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .background(Color(Utilities.getRandomPlaceHolderColor())
                        .cornerRadius(20))
                
                VStack(alignment: .center) {
                    Text(recipeData.title)
                        .font(.subheadline)
                        .fontWeight(.heavy)
                        .foregroundColor(.accent)
                        .frame(minWidth: 50)
                    
                    Spacer()
                    
                    HStack(alignment:.center) {
                        Text(recipeData.category)
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                            .lineLimit(5)
                        
                        Spacer()
                        
                        Button(action: {
                            isFavourite.toggle()
                        }) {
                            Image(systemName: isFavourite ? "heart.fill": "heart")
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
    RecipeListItemGridCell(recipeData: recipeData.first!)
}
