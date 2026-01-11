//
//  Generative.swift
//  onDeviceAI
//
//  Created by Bhavik Baraiya on 03/01/26.
//
import Observation
import FoundationModels
import Foundation

@available(iOS 26.0, *)
@Observable
class Generative {
    
    var prompt: String = ""
    var respond: String = ""
    var isLoading: Bool = false
    var session: LanguageModelSession?
    var errorOccurred: Bool = false
    var error: String = ""
    private(set) var recipeData: RecipeGenerative.PartiallyGenerated?
    
    // Safety filter instructions
    let safetyInstructions = """
    Only process requests related to food dishes, recipes, or food items.
    Politely decline non-food requests.
    """
    
    // Format requirements
    let formatInstructions = """
    Required format - Follow this structure exactly:

    **Recipe Title**
    [Name of the dish]

    **Ingredients:**
    - [First ingredient]
    - [Second ingredient]
    - [Third ingredient]
    (Each ingredient MUST start on a new line with a hyphen and space even if there are so many items)

    **Instructions:**
    1. [First step]
    2. [Second step]
    3. [Third step]
    (Each step MUST start on a new line with a number, period, and space even if there are so many items)

    **About this dish:**
    [Write 4-5 sentences describing the dish, its origins, flavors, or serving suggestions. This section should be a continuous paragraph.]

    **Similar recipes:**
    [Recipe 1], [Recipe 2], [Recipe 3]
    (List 2-3 recipes separated by commas on the same line)

    **Preparation time:**
    [X minutes/hours]

    **Difficulty level:**
    [Easy/Medium/Hard]

    **Calories:**
    [Approximate calories per serving]

    IMPORTANT: 
    - Use exactly these section headers with ** markers
    - Follow the bullet and numbering format precisely
    - Do not skip any sections
    
    """
    
    // Combined instructions for the model
    var fullModelInstructions: String {
        return """
        \(safetyInstructions)
        
        \(formatInstructions)
        """
    }

    func loadModel() {
        self.checkAvailability(completion: { isAvailable,msg in
            if(!isAvailable) {
                self.errorOccurred = true
                self.error = msg
            }
        })
        self.session = LanguageModelSession(instructions: fullModelInstructions)
    }
    
    func generateResponse(prompt: String) async {
        
        isLoading = true
        
        do {
            
            let prompt = Prompt {
                """
                    Generate a food recipe for \(prompt).

                    First, determine if '\(prompt)' is a food dish, ingredient, or beverage. If yes, create a complete recipe. If no, politely decline.

                    For valid food requests, provide:
                    - Recipe title
                    - Preparation time 
                    - Difficulty level 
                    - Ingredients list 
                    - Numbered instructions 
                    - A brief note about the dish 
                    - 2-3 similar recipe suggestions 
                """
            }
            guard let session = self.session else { return }
            let stream = session.streamResponse(to: prompt, generating: RecipeGenerative.self)
            
            for try await partialResponse in stream {
              self.recipeData = partialResponse.content
            }
            isLoading = false
            
        } catch {
        
            isLoading = false
            self.errorOccurred = true
            self.error = error.localizedDescription
            print(error)
        }
    }
    
    func checkAvailability(completion: (Bool, String) -> Void) {
        let model = SystemLanguageModel.default

        switch model.availability {
            
            case .available:
                completion(true,"Model is available and ready to go!")
                
            case .unavailable(.deviceNotEligible):
                completion(false,GenerativeUserError.unsupported.description)

            case .unavailable(.appleIntelligenceNotEnabled):
                completion(false,GenerativeUserError.modelDisabled.description)

            case .unavailable(.modelNotReady):
                completion(false,GenerativeUserError.modelNotReady.description)
            
            case .unavailable(_):
                completion(false,GenerativeUserError.unknown.description)
        }
    }
}
