//
//  CustomContentUnavailableView.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 01/05/25.
//

import SwiftUI

struct CustomContentUnavailableModel {
    var title: LocalizedStringResource
    var message: LocalizedStringResource
    var image: String = ""
    var systemImage: String = ""
}

struct CustomContentUnavailableView: View {
    
    var contentUnavailableData: CustomContentUnavailableModel
    var image: String {
        contentUnavailableData.image
    }
    var systemImage: String {
        contentUnavailableData.systemImage
    }
    var body: some View {
        VStack(alignment: .center, spacing: 15, content: {
            
            if(isImageDataAvailable()) {
                if let uiImage = image != "" ? UIImage(named: image) : UIImage(systemName: systemImage) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 60.0, height: 60.0)
                        .foregroundStyle(Color.accent)
                }
            }
            
            Text(contentUnavailableData.title)
                .font(.title)
                .multilineTextAlignment(.center)
                .fontWeight(.semibold)
                .foregroundStyle(Color.accentColor)
            
            Text(contentUnavailableData.message)
                .font(.subheadline)
                .foregroundStyle(Color.accentColor)
                .multilineTextAlignment(.center)
            
        }).frame(width: 300)
    }
    
    private func isImageDataAvailable() -> Bool{
        if(contentUnavailableData.image != ""  ||
           contentUnavailableData.systemImage != "") {
            return true
        }
        return false
    }
}

#Preview {
    CustomContentUnavailableView(contentUnavailableData: CustomContentUnavailableModel(title: "No recipes available!", message: "Tap on + icon at top right corner to add your recipe"))
}
