//
//  BannerView.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 24/03/25.
//

import SwiftUI

struct BannerView: View {
    
    let images: [String]
    
    var body: some View {
        HStack {
            TabView {
                ForEach(images, id: \.self) { image in
                    if let storedImage = ImageStorageManager.loadImageFromDocuments(name: image)
                    {
                        Image(uiImage: storedImage)
                        .resizable()
                        .scaledToFill()
                    } else {
                        Image(systemName: "questionmark.app.fill")
                            .resizable()
                            .scaledToFill()
                            .tint(.accent)
                    }
                } // LOOP
            } //TABVIEW
            .tabViewStyle(.page)
        }
    }
}

#Preview {
    BannerView(images: ["spaghetti_carbonara","chicken_biryani","pancakes"])
}
