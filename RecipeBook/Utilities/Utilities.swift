//
//  Utilities.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 16/04/25.
//

import Foundation

class Utilities {
    static func getDocumentDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
