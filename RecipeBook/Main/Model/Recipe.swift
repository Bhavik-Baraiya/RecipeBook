//
//  Recipe.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 22/03/25.
//

import Foundation

struct Recipe: Identifiable {
    var id: Int
    var title: String
    var ingredients: String
    var instructions: String
    var category: String
    var preparationTimeInHours: Int
    var preparationTimeInMinutes: Int
    var images: [String]
    var isFavourite: Bool
}
