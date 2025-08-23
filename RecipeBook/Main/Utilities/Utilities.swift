//
//  Utilities.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 16/04/25.
//

import Foundation
import UIKit
import SwiftUI
import AVFoundation

class Utilities {
    
    static func getRandomPlaceHolderColor() -> String {
        let placeHolderColors = ["Creamy Apricot",
                                 "Dusty Tangerine",
                                 "Light Coral",
                                 "Muted Orange",
                                 "Orange Mist",
                                 "Pastel Orange",
                                 "Peach Tint",
                                 "Warm Beige"]
        
        guard let placeHolderColor = placeHolderColors.randomElement() else {
            return ""
        }
        
        return placeHolderColor
    }
    
    static func generateThumbnailImage(from videoURL: URL) -> Image? {
        let asset = AVURLAsset(url: videoURL)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImageGenerator.appliesPreferredTrackTransform = true
        
        do {
            let cgImage = try assetImageGenerator.copyCGImage(at: CMTime(seconds: 1, preferredTimescale: 60), actualTime: nil)
            let uiImage = UIImage(cgImage: cgImage)
            return Image(uiImage: uiImage) // SwiftUI Image
        } catch {
            print("Error generating thumbnail: \(error)")
            return nil
        }
    }
}
