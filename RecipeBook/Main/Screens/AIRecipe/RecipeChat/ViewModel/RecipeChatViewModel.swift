//
//  RecipeChatViewModel 2.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 20/01/26.
//


import SwiftUI
import FoundationModels

@Observable
class RecipeChatViewModel {
    
    var messages: [RecipeChatMessage] = []
    var userInput: String = ""
    var isLoading = false
    
    var partial: String.PartiallyGenerated?
    var partialId: UUID?
    
    var partialRecipe: RecipeGenerative.PartiallyGenerated?
    var partialRecipeId: UUID?
    
    private var session: LanguageModelSession?
    
    private let instructions = """
        You are an AI recipe maker.
        Generate delicious, well-structured recipes tailored to the user's needs.
        Use the given generating and provide the output in same manner.
        Optimize recipes for taste, simplicity, and nutrition.
    """
    
    private var streamingTask: Task<Void, Never>?
    
    func loadModel() {
        self.checkAvailability(completion: { isAvailable, msg in
            if !isAvailable {
                print("Model not available.")
            }
        })
        self.session = LanguageModelSession(instructions: instructions)
    }

    func sendMessage() {
        guard !isLoading else { return }
        guard !userInput.isEmpty else { return }
        
        isLoading = true
        
        messages.append(RecipeChatMessage(sender: .user, content: userInput))
        let userInput = self.userInput
        self.userInput = ""
        
        guard let session = session else { return }
        
        let supportedLanguages = SystemLanguageModel.default.supportedLanguages
        
        guard supportedLanguages.contains(Locale.current.language) else {
            print("This feature is not compatible with your current system language")
            isLoading = false
            return
        }
        
        streamingTask = Task {
            do {
                let stream = session.streamResponse(
                    to: userInput,
                    generating: RecipeGenerative.self,
                    options: GenerationOptions(sampling: .greedy)
                )
                
                self.partialRecipeId = UUID()
                
                var lastPartial: RecipeGenerative.PartiallyGenerated?
                
                for try await partial in stream {
                    self.partialRecipe = partial.content
                    lastPartial = partial.content
                }
                
                guard !Task.isCancelled else {
                    self.cleanup()
                    return
                }
                
                if let finalRecipe = lastPartial {
                    messages.append(RecipeChatMessage.from(partialRecipe: finalRecipe))
                }
                
                self.cleanup()
                
            } catch LanguageModelSession.GenerationError.unsupportedLanguageOrLocale {
                print("Model is not compatible with this device")
                self.cleanup()
                
            } catch {
                print("error: \(error)")
                if let error = error as? FoundationModels.LanguageModelSession.GenerationError {
                    print("error: \(error.localizedDescription)")
                }
                self.cleanup()
            }
       }
    }
    
    private func cleanup() {
        isLoading = false
        partialRecipe = nil
        partialRecipeId = nil
        streamingTask = nil
    }
    
    func reset() {
        messages = []
        userInput = ""
        isLoading = false
        
        streamingTask?.cancel()
        streamingTask = nil
        
        partialRecipe = nil
        partialRecipeId = nil
        
        session = LanguageModelSession(instructions: instructions)
    }
    
    func checkAvailability(completion: (Bool, String) -> Void) {
        let model = SystemLanguageModel.default

        switch model.availability {
            
        case .available:
            completion(true, "Model is available and ready to go!")
            
        case .unavailable(.deviceNotEligible):
            completion(false, GenerativeUserError.unsupported.description)

        case .unavailable(.appleIntelligenceNotEnabled):
            completion(false, GenerativeUserError.modelDisabled.description)

        case .unavailable(.modelNotReady):
            completion(false, GenerativeUserError.modelNotReady.description)
        
        case .unavailable(_):
            completion(false, GenerativeUserError.unknown.description)
        }
    }
}
