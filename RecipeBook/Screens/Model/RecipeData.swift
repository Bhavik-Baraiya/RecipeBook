//
//  RecipeData.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 23/04/25.
//

import SwiftData

@Model
class RecipeData {
    var title: String
    var ingredients: String
    var instructions: String
    var category: String
    var preparationTimeInHours: Int
    var preparationTimeInMinutes: Int
    var imageNames: [String]
    var isFavourite: Bool
    
    init(title: String, ingredients: String, instructions: String, category: String = "", preparationTimeInHours: Int = 0, preparationTimeInMinutes: Int = 0, imageNames: [String], isFavourite: Bool = false) {
        self.title = title
        self.ingredients = ingredients
        self.instructions = instructions
        self.category = category
        self.preparationTimeInHours = preparationTimeInHours
        self.preparationTimeInMinutes = preparationTimeInMinutes
        self.imageNames = imageNames
        self.isFavourite = isFavourite
    }
}
