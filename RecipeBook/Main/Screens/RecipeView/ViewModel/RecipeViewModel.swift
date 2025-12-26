//
//  RecipeViewModel.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 26/12/25.
//

import SwiftUI

@Observable
class RecipeViewModel {
    var recipe: RecipeData
    var displayPopup: Bool = false
    var performBack: Bool = false
    
    init(recipe: RecipeData) {
        self.recipe = recipe
    }
    
    // MARK: - Actions
    func toggleDeletePopup() {
        displayPopup.toggle()
    }
    
    func toggleFavorite() {
        recipe.isFavourite.toggle()
    }
    
    // MARK: - Computed Properties
    var prepTime: LocalizedStringKey {
        LocalizedStringKey("\(recipe.preparationTimeInHours) : \(recipe.preparationTimeInMinutes)")
    }
    
    var recipeLevel: String {
        getDifficultyLevel(for: recipe.level)
    }
    
    var headerData: [RecipeHeaderViewContent] {
        [
            RecipeHeaderViewContent(systemImage: "clock", title: prepTime),
            RecipeHeaderViewContent(systemImage: "flame.fill", title: LocalizedStringKey(recipeLevel))
        ]
    }
    
    // MARK: - Helper Methods
    private func getDifficultyLevel(for value: Int) -> String {
        if let level = DifficultyLevel(rawValue: value) {
            return level.description
        } else {
            return "Unknown"
        }
    }
}
