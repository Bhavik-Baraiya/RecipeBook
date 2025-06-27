//
//  FileHandler.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 22/04/25.
//

import Foundation

class FileHandler {
    
    static func appImagesFolderDirectory() -> URL {
       
        let fileManager = FileManager.default
        
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let imgFolderURL = documentsURL.appendingPathComponent("RecipeBook/Recipes/RecipeImages")
        
        do {
            try fileManager.createDirectory(at: imgFolderURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Failed to create directories: \(error.localizedDescription)")
            return URL(fileURLWithPath: "")
        }
        return imgFolderURL
    }
}
