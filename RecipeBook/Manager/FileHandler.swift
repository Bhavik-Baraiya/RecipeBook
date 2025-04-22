//
//  FileHandler.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 22/04/25.
//

import Foundation

class FileHandler {
    
    static func appDocumentDirectory() -> URL {
        let DocumentDirectory = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        let appPath = DocumentDirectory.appendingPathComponent("RecipeBook")
        let recipeData = appPath?.appendingPathComponent("Recipes")
        guard let recipeImagesPath = recipeData?.appendingPathComponent("RecipeImages") else { return URL(fileURLWithPath: "")}
        return recipeImagesPath
    }
    
    static func createAppDocumentDirectory() {
        let recipeImagesPath = appDocumentDirectory()
        let defaultFileManger = FileManager.default
        if(!defaultFileManger.fileExists(atPath: recipeImagesPath.path())) {
            do
            {
                try FileManager.default.createDirectory(atPath: recipeImagesPath.path, withIntermediateDirectories: true, attributes: nil)
                print("Local Directory: ",recipeImagesPath as Any)
            }
            catch let error as NSError
            {
                print("Unable to create directory \(error.debugDescription)")
            }
        }
    }
}
