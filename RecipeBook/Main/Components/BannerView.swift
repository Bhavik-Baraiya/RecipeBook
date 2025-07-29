//
//  BannerView.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 24/03/25.
//

import SwiftUI

struct BannerView: View {
    
    @State var recipeData: RecipeData?
    
    var body: some View {
        TabView {
            
            if (recipeData?.imageNames.count == 0) {
                placeholderView()
            } else {
                
                if let recipeId = recipeData?.id {
                    
                    let imageStorage = ImageStorageManager(recipeId: recipeId)
                    
                    if let images = recipeData?.imageNames {
                        
                        ForEach(images, id: \.self) { image in
                        
                            if let storedImage = imageStorage.loadImageFromDocuments(name: image) {
                                Image(uiImage: storedImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .clipped()
                            } else {
                                placeholderView()
                            }
                        }
                    }
                } else {
                    EmptyView()
                }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .frame(height: 300)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    @ViewBuilder
    private func placeholderView() -> some View {
        ZStack {
            Color(Utilities.getRandomPlaceHolderColor())
            Image(systemName: "photo")
                .font(.system(size: 40))
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
    }
}

#Preview {
    BannerView(recipeData: RecipeData(title: "", ingredients: "", instructions: "", category: "1", level: 1, preparationTimeInHours: 1, preparationTimeInMinutes: 1))
}
