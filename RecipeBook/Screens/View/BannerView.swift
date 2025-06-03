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
        TabView {
            if images.isEmpty {
                placeholderView()
            } else {
                ForEach(images, id: \.self) { image in
                    if let storedImage = ImageStorageManager.loadImageFromDocuments(name: image) {
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
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .frame(height: 300)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 20)
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
    BannerView(images: ["spaghetti_carbonara","chicken_biryani","pancakes"])
}
