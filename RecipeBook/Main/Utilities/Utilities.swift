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
    
    static func generateThumbnailImages(from videoURL: URL, completion: @escaping (Image?) -> Void) {
        print("Video URL: \(videoURL)")
        print("Exists: \(FileManager.default.fileExists(atPath: videoURL.path))")
        let asset = AVURLAsset(url: videoURL)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true

        let time = CMTime(seconds: 10, preferredTimescale: 60)

        generator.generateCGImageAsynchronously(for: time) { cgImage, actualTime, error in
            if let error = error {
                print("Error generating image: \(error.localizedDescription)")
                DispatchQueue.main.async { completion(nil) }
                return
            }

            if let cgImage = cgImage {
                let uiImage = UIImage(cgImage: cgImage)
                let swiftUIImage = Image(uiImage: uiImage)
                DispatchQueue.main.async { completion(swiftUIImage) }
            } else {
                DispatchQueue.main.async { completion(nil) }
            }
        }
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
