//
//  VideoStorageManager.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 14/07/25.
//

import SwiftUI

class VideoStorageManager: ObservableObject {
    
    @Published var savedVideoURLs: [URL] = []

    func saveVideoLocally(from url: URL, for recipeID: UUID) {
        let relativePath = "RecipeBook/Recipes/\(recipeID)/Videos"
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let folderURL = documentsURL.appendingPathComponent(relativePath)
        let destinationURL = folderURL.appendingPathComponent(url.lastPathComponent)
        
        let fileManager = FileManager.default
        
        try? fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true)
        
        do {
            if fileManager.fileExists(atPath: destinationURL.path) {
                print("Replacing existing video: \(destinationURL.lastPathComponent)")
                try fileManager.removeItem(at: destinationURL)
            }
            
            try fileManager.copyItem(at: url, to: destinationURL)
            print("Video saved successfully: \(destinationURL.lastPathComponent)")
            
            DispatchQueue.main.async {
                self.loadSavedVideos(for: recipeID)
            }
            
        } catch {
            print("Error saving video locally: \(error)")
        }
    }

    func loadSavedVideos(for recipeID: UUID) {
        let relativePath = "RecipeBook/Recipes/\(recipeID)/Videos"
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            savedVideoURLs = []
            return
        }
        
        let videoFolderURL = documentsURL.appendingPathComponent(relativePath)
        
        guard FileManager.default.fileExists(atPath: videoFolderURL.path) else {
            savedVideoURLs = []
            return
        }
        
        do {
            let urls = try FileManager.default.contentsOfDirectory(at: videoFolderURL,
                                                                   includingPropertiesForKeys: nil)
            let videoURLs = urls.filter { url in
                ["mp4", "mov", "m4v"].contains(url.pathExtension.lowercased())
            }.sorted { $0.lastPathComponent < $1.lastPathComponent } // optional: sort by name
            
            self.savedVideoURLs = videoURLs
            print("Loaded \(videoURLs.count) videos for recipe \(recipeID)")
            
        } catch {
            print("Error loading videos: \(error)")
            self.savedVideoURLs = []
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
