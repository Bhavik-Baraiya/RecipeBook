//
//  RecipeListItemCell.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 22/03/25.
//

import SwiftUI

struct RecipeListItemCell: View {
    
    @Bindable var recipeData: RecipeData
    
    var body: some View {
        HStack() {
            
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
                    
                
            
            VStack(alignment: .leading) {
                Text($recipeData.title.wrappedValue)
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundColor(Color.secondaryApp)
                
                Text($recipeData.ingredients.wrappedValue)
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
                    .lineLimit(5)
            }
        }
    }
}

#Preview {
    RecipeListItemCell(recipeData:RecipeData(title: "", ingredients: "", instructions: "", category: "", preparationTimeInHours: 0, preparationTimeInMinutes: 1, imageNames: [""], isFavourite: true))
}
