//
//  FileHandler.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 22/04/25.
//

import Foundation

class FileHandler {
    
    private var recipeId: UUID?
    
    init(recipeId: UUID) {
        self.recipeId = recipeId
    }
    
    func getPhotoLocalDirectory() -> URL {
       
        if let recipeId = self.recipeId {
       
            let completeVideoLocalPath = "RecipeBook/Recipes/\(recipeId)/Photos"
            let fileManager = FileManager.default
            
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            let videoFolderURL = documentsURL.appendingPathComponent(completeVideoLocalPath)
            
            do {
                try fileManager.createDirectory(at: videoFolderURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Failed to create directories: \(error.localizedDescription)")
                return URL(fileURLWithPath: "")
            }
            return videoFolderURL
        } else {
            return URL(fileURLWithPath: "")
        }
    }
    
    func getVideoLocalDirectory(recipeID: UUID) -> URL {
       
        if let recipeId = self.recipeId {
       
            let completeVideoLocalPath = "RecipeBook/Recipes/\(recipeId)/Videos"
            let fileManager = FileManager.default
            
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            let videoFolderURL = documentsURL.appendingPathComponent(completeVideoLocalPath)
            
            do {
                try fileManager.createDirectory(at: videoFolderURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Failed to create directories: \(error.localizedDescription)")
                return URL(fileURLWithPath: "")
            }
            return videoFolderURL
        } else {
            return URL(fileURLWithPath: "")
        }
    }
}
