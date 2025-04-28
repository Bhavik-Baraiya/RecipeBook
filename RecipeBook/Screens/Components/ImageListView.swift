//
//  ImageListView.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 26/04/25.
//

import SwiftUI

struct ImageListView: View {
    
    @State var images: [Image]
    
    var body: some View {
        
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                ForEach(images.indices, id: \.self) { index in
                    
                    ZStack(alignment: .topTrailing) {
                        images[index]
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 90, height: 90)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 10)
                            )
                        
                        Button {
//                            $recipeData.imageNames.wrappedValue.remove(at: index)
//                            selectedImages.remove(at: index)
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.white)
                                .background(Circle().fill(Color.black.opacity(0.6)))
                                .padding(6)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ImageListView(images: [Image("")])
}
