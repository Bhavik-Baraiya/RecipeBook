//
//  Utilities.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 16/04/25.
//

import Foundation
import UIKit

class Utilities {
    static func getDocumentDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    static func getRandomPlaceHolderColor() -> String {
        let placeHolderColors = ["Creamy Apricot",
                                 "Dusty Tangerine",
                                 "Light Coral",
                                 "Muted Orange",
                                 "Orange Mist",
                                 "Pastel Orange",
                                 "Peach Tint",
                                 "Warm Beige"]
        
        guard let placeHolderColor = placeHolderColors.randomElement() else {
            return ""
        }
        
        return placeHolderColor
    }
}
