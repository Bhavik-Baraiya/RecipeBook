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
    var chatmessages: [ChatMessage] = []
    var userInput: String = ""
    var lastUserInput: String = ""
    var isLoading = false
    
    var partial: String.PartiallyGenerated?
    var partialId: UUID?
    
    var partialRecipe: RecipeGenerative.PartiallyGenerated?
    var partialRecipeId: UUID?
    
    private var session: LanguageModelSession?
    
    private let instructions = """
       You are an AI Chef Assistant for a recipe book application.

       Your role is to help users with:
       - Generating complete food recipes
       - Answering questions about food dishes
       - Providing cooking tips, substitutions, and variations
       - Suggesting healthier or alternative options when asked

       Always follow these principles:
       - Be clear, concise, and practical
       - Use simple cooking language suitable for home cooks
       - Prefer commonly available ingredients unless specified otherwise
       - Respect dietary preferences if mentioned (vegetarian, vegan, gluten-free, etc.)
       - Do not include unnecessary storytelling or emojis
       - Focus only on food, cooking, and recipe-related topics
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
    
    func sendQuery() {
        guard !isLoading else { return }
        guard !userInput.isEmpty else { return }
        
        isLoading = true
        
        chatmessages.append(ChatMessage(sender: .user, content: userInput))
        let userInput = self.userInput
        lastUserInput = userInput
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
                let stream = session.streamResponse(to: userInput)
                self.partialId = UUID()
                
                for try await partial in stream {
                    self.partial = partial.content
                }
                
                guard !Task.isCancelled else { return }
                
                chatmessages.append(ChatMessage(sender: .assistant,
                                            content: partial ?? "",
                                            id: partialId ?? UUID()))
                
                self.isLoading = false
                self.partial = nil
                self.partialId = nil
                self.streamingTask = nil
                
            }
            catch LanguageModelSession.GenerationError.unsupportedLanguageOrLocale {
                print("Model is not compatible with this device")
                self.cleanup()
                
            }
            catch {
                print("error: \(error)")
                if let error = error as? FoundationModels.LanguageModelSession.GenerationError {
                    print("error: \(error.localizedDescription)")
                }
                
                isLoading = false
                streamingTask = nil
            }
       }
    }
    
    func generateRecipe() async {

        guard let session = session else { return }
        
        let structuredPrompt = """
                Convert this recipe string content into structured output.
                
                Recipe data:
                \(String(describing: self.chatmessages.last))
                """
        do {
            let recipe = try await session.respond(to: structuredPrompt,generating: RecipeGenerative.self)
            print(recipe.content.instructions)
            
            lastUserInput = ""
            
        } catch {
            print(error)
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
