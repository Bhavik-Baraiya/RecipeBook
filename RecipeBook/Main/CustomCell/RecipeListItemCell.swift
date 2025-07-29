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
            
            let imageStorage = ImageStorageManager(recipeId: self.$recipeData.id)
            
            let imageName = $recipeData.imageNames.wrappedValue.count > 0 ? $recipeData.imageNames.wrappedValue[0] : ""
            
            let uiImage = imageStorage.loadImageFromDocuments(name: imageName)
            
            let image = uiImage != nil ? Image(uiImage: uiImage!) : Image(systemName: "")
    
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .background(Color(Utilities.getRandomPlaceHolderColor())
                        .cornerRadius(20))
                    
                
            
            VStack(alignment: .leading,spacing:20) {
                Text($recipeData.title.wrappedValue)
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundColor(Color.secondaryApp)
                
                Text($recipeData.category.wrappedValue)
                    .font(.title3)
                    .multilineTextAlignment(.leading)
                    .lineLimit(5)
            }
            .padding()
        }
    }
}

#Preview {
    RecipeListItemCell(recipeData:RecipeData(title: "", ingredients: "", instructions: "", category: "", level: 1, preparationTimeInHours: 01, preparationTimeInMinutes: 1, imageNames: [""], videos: [], isFavourite: true))
}
