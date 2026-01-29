//
//  FileHelper.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 01/04/76.
//

import Foundation

public func createTextFile(text: String, fileName: String = "SharedText") -> URL? {
    let fileURL = FileManager.default.temporaryDirectory
        .appendingPathComponent("\(fileName).txt")

    do {
        try text.write(to: fileURL, atomically: true, encoding: .utf8)
        return fileURL
    } catch {
        print("Error writing file:", error)
        return nil
    }
}
