//
//  ChatViewModel.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 16/01/26.
//


import SwiftUI
import FoundationModels

@Observable
class ChatViewModel {
    
    var messages: [ChatMessage] = []
    var userInput: String = ""
    var isResponding = false
    
    var partial: String.PartiallyGenerated?
    var partialId: UUID?
    
    private var session: LanguageModelSession?
    
    private let instructions = """
        You are an AI recipe maker.
        Generate delicious, well-structured recipes tailored to the user’s needs.
        Include title, bulleted ingredients, numbered instructions, description paragraph, similar recipes, prep time, difficulty, and calories.
        Optimize recipes for taste, simplicity, and nutrition.
    """
    
    private var streamingTask: Task<Void, Never>?
    
    func loadModel() {
        self.checkAvailability(completion: { isAvailable,msg in
            if(!isAvailable) {
                print("Model not available.")
            }
        })
        self.session = LanguageModelSession(instructions: instructions)
    }

    func sendMessage() {
        
        guard !isResponding else { return }
        guard !userInput.isEmpty else { return }
        isResponding = true
        
        messages.append(ChatMessage(sender: .user, content: userInput))
        let userInput = self.userInput
        self.userInput = ""
        
        guard let session = session else { return }
        
       streamingTask = Task {
            do {
                let stream = session.streamResponse(to: userInput)
                self.partialId = UUID()
                
                for try await partial in stream {
                    //print(partial)
                    self.partial = partial.content
                }
                
                guard !Task.isCancelled else { return }
                
                messages.append(ChatMessage(sender: .assistant,
                                            content: partial ?? "",
                                            id: partialId ?? UUID()))
                
                self.isResponding = false
                self.partial = nil
                self.partialId = nil
                self.streamingTask = nil
                
            } catch {
                print("error: \(error)")
                if let error = error as? FoundationModels.LanguageModelSession.GenerationError {
                    print("error: \(error.localizedDescription)")
                }
                
                isResponding = false
                streamingTask = nil
                
            }
       }
    }
    
    func reset() {
        messages = []
        userInput = ""
        isResponding = false
        
        streamingTask?.cancel()
        streamingTask = nil
        
        session = LanguageModelSession(instructions: instructions)
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
