//
//  Enums.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 16/06/25.
//

import Foundation
import UIKit
import SwiftUI

enum DifficultyLevel: Int {
    case low = 0
    case medium = 1
    case high = 2

    var description: String {
        switch self {
        case .low: return "Low"
        case .medium: return "Medium"
        case .high: return "High"
        }
    }
}

enum RecipeValidationError: Error, LocalizedError {
    
    // Missing Fields
    case missingTitle
    case missingIngredients
    case missingInstructions
    case missingCategory
    case missingPreparationTime
    case missingImage
    
    // Invalid Format
    case invalidTitle
    case invalidIngredients
    case invalidInstructions

    var errorDescription: String? {
        switch self {
        case .missingTitle:
            return "Please enter a title for the recipe."
        case .missingIngredients:
            return "Ingredients are required to add the recipe."
        case .missingInstructions:
            return "Please provide preparation instructions."
        case .missingCategory:
            return "Please select a category for the recipe."
        case .missingImage:
            return "Please add an image for the recipe."
        case .missingPreparationTime:
            return "Please add preparation time."

        case .invalidTitle:
            return "The recipe title should contain alphabetical characters only."
        case .invalidIngredients:
            return "The recipe ingredients should contain alphabetical characters only."
        case .invalidInstructions:
            return "The recipe instructions should contain alphabetical characters only."
        }
    }
}

extension String {
    var isRecipeDetailValid: Bool {
        let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Check if string is empty
        guard !trimmed.isEmpty else { return false }
        
        // Allowable character set
        let allowedPunctuation = CharacterSet(charactersIn: ",.()/-–•:½¼¾")
        let allowedCharacters = CharacterSet.letters
            .union(.decimalDigits)
            .union(.whitespacesAndNewlines)
            .union(allowedPunctuation)
        
        // Ensure all characters are valid
        guard self.rangeOfCharacter(from: allowedCharacters.inverted) == nil else { return false }
        
        // Ensure the string contains at least one letter (to avoid purely numeric input)
        guard self.contains(where: { $0.isLetter }) else { return false }
        
        return true
    }
}

enum Category: Identifiable, CaseIterable {
    case bevarage
    case meal
    case dessert
    case snacks
    case soup
    case none
    
    var id: Self { return  self }
    
    var title: String {
        switch self {
            case .bevarage:
                "Bevarage"
            case .meal:
                "Meal"
            case .dessert:
                "Dessert"
            case .snacks:
                "Snacks"
            case .soup:
                "Soup"
            case .none:
                "None"
        }
    }
}
