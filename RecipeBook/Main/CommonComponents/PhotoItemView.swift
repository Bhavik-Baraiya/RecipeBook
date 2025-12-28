//
//  PhotoItemView.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 28/12/25.
//

import SwiftUI

struct PhotoItemView: View {
    let photo: UIImage
    let index: Int
    let onRemove: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image(uiImage: photo)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 90, height: 90)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Button {
                onRemove()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.white)
                    .background(Circle().fill(Color.black.opacity(0.6)))
                    .padding(6)
            }
        }
        .id("\(photo.hashValue)-\(index)")
    }
}
