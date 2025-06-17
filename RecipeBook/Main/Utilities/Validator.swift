//
//  Validations.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 16/06/25.
//

import UIKit

class Validator {
    
    static func validateRecipe(title: String,
                               ingredients: String,
                               instructions: String,
                               category: String?,
                               prepTimeInHour: Int,
                               prepTimeInMinute: Int,
                               images: [UIImage]) throws {
        
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedTitle.isEmpty {
            throw RecipeValidationError.missingTitle
        }
        if !trimmedTitle.isAlphabetical {
            throw RecipeValidationError.invalidTitle
        }
        
        let trimmedIngredients = ingredients.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedIngredients.isEmpty {
            throw RecipeValidationError.missingIngredients
        }
        if !trimmedIngredients.isAlphabetical {
            throw RecipeValidationError.invalidIngredients
        }

        let trimmedInstructions = instructions.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedInstructions.isEmpty {
            throw RecipeValidationError.missingInstructions
        }
        if !trimmedInstructions.isAlphabetical {
            throw RecipeValidationError.invalidInstructions
        }

        if category == "None" {
            throw RecipeValidationError.missingCategory
        }

        if prepTimeInHour == 0 && prepTimeInMinute == 0  {
            throw RecipeValidationError.missingPreparationTime
        }
        
        if images.isEmpty {
            throw RecipeValidationError.missingImage
        }
    }
}
