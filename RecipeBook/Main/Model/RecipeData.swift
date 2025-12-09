//
//  RecipeData.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 23/04/25.
//

import SwiftData
import Foundation
import SwiftUI

@Model
class RecipeData {
    var id: UUID
    var title: String
    var ingredients: String
    var instructions: String
    var category: String
    var level: Int
    var preparationTimeInHours: Int
    var preparationTimeInMinutes: Int
    var imageNames: [String]
    var videos: [String]
    var isFavourite: Bool
    
    init(
        id: UUID = UUID(),
        title: String,
        ingredients: String,
        instructions: String,
        category: String,
        level: Int,
        preparationTimeInHours: Int,
        preparationTimeInMinutes: Int,
        imageNames: [String] = [],
        videos: [String] = [],
        isFavourite: Bool = false
    ) {
        self.id = id
        self.title = title
        self.ingredients = ingredients
        self.instructions = instructions
        self.category = category
        self.level = level
        self.preparationTimeInHours = preparationTimeInHours
        self.preparationTimeInMinutes = preparationTimeInMinutes
        self.imageNames = imageNames
        self.videos = videos
        self.isFavourite = isFavourite
    }
}
