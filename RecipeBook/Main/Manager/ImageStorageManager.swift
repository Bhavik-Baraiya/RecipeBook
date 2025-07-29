//
//  ImageStorageManager.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 16/04/25.
//

import SwiftUI

class ImageStorageManager {
    
    private var recipeId: UUID?
    private var fileHandler: FileHandler?
    
    init(recipeId: UUID) {
        self.recipeId = recipeId
        self.initFileHandler()
    }

    private func initFileHandler() {
        
        guard let recipeId = self.recipeId else { return }
        self.fileHandler = FileHandler(recipeId: recipeId)
    }
    
    func saveImageToDocuments(image: UIImage, name: String) {
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            print("Failed to convert image to data")
            return
        }
        
        guard let recipeId = self.recipeId else {return}
        
        let fileHandler = FileHandler(recipeId: recipeId)
        let fileName = fileHandler.getPhotoLocalDirectory().appendingPathComponent("\(name)\(imageFileExtension)")
        
        do {
            try data.write(to: fileName)
            print("Image saved to: \(fileName)")
        } catch {
            print("Error in saving image")
        }
    }
    
    func loadImageFromDocuments(name: String) -> UIImage? {
        
        guard let photosLocalURL = self.fileHandler?.getPhotoLocalDirectory() else { return nil }
        
        let path = photosLocalURL.appendingPathComponent("\(name)\(imageFileExtension)")
        print("Looking for image at path: \(path.path)")
        return UIImage(contentsOfFile: path.path)
    }
}
 
