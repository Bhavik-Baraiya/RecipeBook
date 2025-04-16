//
//  ImageStorageManager.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 16/04/25.
//

import SwiftUI

class ImageStorageManager {
    
    static func saveImageToDocuments(image: UIImage, name: String) {
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            print("Failed to convert image to data")
            return
        }
        
        let fileName = Utilities.getDocumentDirectory().appendingPathComponent("\(name).jpeg")
        
        do {
            try data.write(to: fileName)
            print("Image saved to: \(fileName)")
        } catch {
            print("Error in saving image")
        }
    }
    
    static func loadImageFromDocuments(name: String) -> UIImage? {
        
        let path = Utilities.getDocumentDirectory().appendingPathComponent("\(name).jpeg")
        print("Looking for image at path: \(path.path)")
        return UIImage(contentsOfFile: path.path)
    }
}
 
