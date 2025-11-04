//
//  Untitled.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 04/11/25.
//

import SwiftUI
import AVFoundation
import UIKit

struct VideoThumbnailView: View {
    let videoURL: URL
    let size: CGFloat

    @State private var thumbnail: Image? = nil

    var body: some View {
        Group {
            if let thumbnail = thumbnail {
                thumbnail
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipped()
                    .cornerRadius(6)
            } else {
                ProgressView()
                    .frame(width: 80, height: 80)
                    .onAppear {
                        loadThumbnail()
                    }
            }
        }
    }

    private func loadThumbnail() {
        Utilities.generateThumbnailImages(from: videoURL) { image in
            DispatchQueue.main.async {
                print("thumbnail generated: \(String(describing: image))")
                self.thumbnail = image
            }
        }
    }
}
