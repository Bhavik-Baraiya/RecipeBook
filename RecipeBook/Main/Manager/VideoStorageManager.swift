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
        loadSavedVideos()
    }

    func saveVideoLocally(from url: URL) {
        let fileManager = FileManager.default
        let destinationURL = getDocumentsDirectory().appendingPathComponent(url.lastPathComponent)

        do {
            if !fileManager.fileExists(atPath: destinationURL.path) {
                try fileManager.copyItem(at: url, to: destinationURL)
                DispatchQueue.main.async {
                    self.savedVideoURLs.append(destinationURL)
                }
            } else {
                print("File already exists at \(destinationURL.lastPathComponent)")
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
}
