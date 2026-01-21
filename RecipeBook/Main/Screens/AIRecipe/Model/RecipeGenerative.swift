//
//
//  RecipeGenerative.swift
//  onDeviceAI
//
//  Created by Bhavik Baraiya on 04/01/26.
//

import Foundation
import FoundationModels

@available(iOS 26.0, *)
@Generable
struct RecipeGenerative: Identifiable,Equatable {
    var id: Int
    
    @Guide(description:"Recipe title as main dish name for the recipe.")
    var title: String
    
    @Guide(description:"Recipe ingredients as bullet points.")
    var ingredients: String
    
    @Guide(description:"Recipe instructions as numberic points (Set each instruction in new line with incremental number)  ")
    var instructions: String
    
    @Guide(description: "Recipe categoty from these only [Bevarage, Meal, Dessert, Snacks, Soup]")
    var category: String
    
    @Guide(description: "Recipe difficulty level [i.e. High -> 0, Low -> 1, Medium -> 2]")
    var level: Int
    
    @Guide(description: "Recipe preparation time in Hours [i.e. 01, 02, 04]. This must be unique and difference for each recipe")
    var preparationTimeInHours: Int

    @Guide(description: "Recipe preparation time in Hours [i.e. 15, 30, 45]. This must be unique and difference for each recipe")
    var preparationTimeInMinutes: Int
    
    @Guide(description: "Recipe making process image along with the final dish image")
    @Guide(.count(5))
    var images: [String]
    
    var isFavourite: Bool
    
    var shortMessage: String
    
    var suggestions: String
    
    @Guide(description:"Calories calculations for the recipe dish in gram")
    var calories: Double
    
    static var mockData = RecipeGenerative(
        id: 1,
        title: "Spaghetti Carbonara",
        ingredients: """
        - 200g spaghetti
        - 100g pancetta
        - 2 large eggs
        - 50g Parmesan cheese
        - Salt and pepper
        """,
        instructions: """
        1. Cook spaghetti in salted water.
        2. Fry pancetta until crispy.
        3. Beat eggs and mix with Parmesan.
        4. Mix spaghetti with pancetta and egg mixture.
        5. Serve immediately.
        """,
        category: "Meal",
        level: 2,
        preparationTimeInHours: 02,
        preparationTimeInMinutes: 30,
        images: [],
        isFavourite: false,
        shortMessage: "Enjoy your Spaghetti Carbonara! I hope you will have fun to eat this",
        suggestions: "Spaghetti Pasta, Cheese Pasta or other dishses like this",
        calories: 500.0
    )
}

extension RecipeGenerative.PartiallyGenerated {
    var asMarkdown: String {
        var markdown = ""
                
        markdown += "**Recipe title:** "
        
        if let title = title {
            markdown += "\(title)\n\n"
        }
        
        if let ingredients = ingredients {
            markdown += "**Ingredients:**\n\(ingredients)\n\n"
        }
        
        if let instructions = instructions {
            markdown += "**Instructions:**\n\(instructions)\n\n"
        }
        
        if let category = category {
            markdown += "**Category:** \(category)\n\n"
        }
        if let level = level {
            markdown += "**Level:** \(level)\n\n"
        }
        if let hours = preparationTimeInHours, let minutes = preparationTimeInMinutes {
            markdown += "**Preparation Time:** \(hours):\(minutes)\n\n"
        }
        if let suggestions = suggestions {
            markdown += "**Suggestions:**\n\(suggestions)\n\n"
        }
        if let calories = calories {
            markdown += "**Calories:** \(calories)\n\n"
        }
        if let shortMessage = shortMessage {
            markdown += "**\(shortMessage)**\n\n"
        }
        return markdown.isEmpty ? "Generating recipe..." : markdown
    }
}
