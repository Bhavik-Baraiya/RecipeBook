//
//  RecipeViewModel.swift
//  onDeviceAI
//
//  Created by Bhavik Baraiya on 04/01/26.
//

import SwiftUI

@available(iOS 26.0, *)
@Observable
class AIRecipeViewModel {
    var recipe: RecipeGenerative.PartiallyGenerated
    var displayPopup: Bool = false
    var performBack: Bool = false
    
    init(recipe: RecipeGenerative.PartiallyGenerated) {
        self.recipe = recipe
    }
    
    // MARK: - Actions
    func toggleDeletePopup() {
        displayPopup.toggle()
    }
    
    func toggleFavorite() {
        recipe.isFavourite?.toggle()
    }
    
    // MARK: - Computed Properties
    var prepTime: LocalizedStringKey {
        
        if let recipePrepTimeInHr = recipe.preparationTimeInHours,
           let recipePrepTimeInMin = recipe.preparationTimeInMinutes {
        
            let completeTime = "\(recipePrepTimeInHr) : \(recipePrepTimeInMin)"
            return LocalizedStringKey(completeTime)
            
        } else {
            return LocalizedStringKey("")
        }
    }
    
    var recipeLevel: String {
        getDifficultyLevel(for: recipe.level ?? -1)
    }
    
    var calories: String {
        "\(String(describing: recipe.calories ?? 0.0)) gm calories"
    }
    
    var headerData: [RecipeHeaderViewContent] {
        [
            RecipeHeaderViewContent(systemImage: "clock", title: prepTime),
            RecipeHeaderViewContent(systemImage: "decrease.quotelevel", title: LocalizedStringKey(recipeLevel)),
            RecipeHeaderViewContent(systemImage: "flame.fill", title: LocalizedStringKey(calories))
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
