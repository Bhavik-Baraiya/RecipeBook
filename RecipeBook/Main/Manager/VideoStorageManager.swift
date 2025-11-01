//
//  VideoStorageManager.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 14/07/25.
//

import SwiftUI

class VideoStorageManager: ObservableObject {
    
    @Published var savedVideoURLs: [URL] = []

    init() {
        //loadSavedVideos()
    }

    func saveVideoLocally(from url: URL, to localPath: URL) {
        let fileManager = FileManager.default
        let destinationURL = localPath.appendingPathComponent(url.lastPathComponent)

        do {
            if fileManager.fileExists(atPath: destinationURL.path) {
                print("File already exists at \(destinationURL.lastPathComponent) Replacing it with the latest one.")
                try fileManager.removeItem(atPath: destinationURL.path)
            }
            
            try fileManager.copyItem(at: url, to: destinationURL)
            DispatchQueue.main.async {
                self.savedVideoURLs.append(destinationURL)
            }
        } catch {
            print("Error saving video locally: \(error)")
        }
    }

    func loadSavedVideos() {
        let docs = getDocumentsDirectory()
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: docs, includingPropertiesForKeys: nil)
            self.savedVideoURLs = fileURLs.filter { $0.pathExtension == "mp4" }
        } catch {
            print("Error loading saved videos: \(error)")
        }
    }

    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func getVideoLocalDirectory(recipeID: UUID) -> URL {
       
        
        let completeVideoLocalPath = "RecipeBook/Recipes/\(recipeID)/Videos"
        let fileManager = FileManager.default
        
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let videoFolderURL = documentsURL.appendingPathComponent(completeVideoLocalPath)
        
        if(fileManager.fileExists(atPath: videoFolderURL.absoluteString)) {
            return videoFolderURL
        }
        
        do {
            try fileManager.createDirectory(at: videoFolderURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Failed to create directories: \(error.localizedDescription)")
            return URL(fileURLWithPath: "")
        }
        return videoFolderURL
    }
}
