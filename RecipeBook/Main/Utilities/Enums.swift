//
//  Enums.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 16/06/25.
//

import Foundation
import UIKit

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
        let trimmed = self.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return false }
        let allowedPunctuation = CharacterSet(charactersIn: ",()-")
        let allowedCharacters = CharacterSet.letters
            .union(.decimalDigits)
            .union(.whitespaces)
            .union(allowedPunctuation)
        guard self.rangeOfCharacter(from: allowedCharacters.inverted) == nil else { return false }
        guard self.contains(where: { $0.isLetter }) else { return false }
        let digitOnlySet = CharacterSet.decimalDigits
        let nonDigitOrWhitespace = self.contains(where: { !($0.isWhitespace || digitOnlySet.contains($0.unicodeScalars.first!)) })
        
        return nonDigitOrWhitespace
    }
}
