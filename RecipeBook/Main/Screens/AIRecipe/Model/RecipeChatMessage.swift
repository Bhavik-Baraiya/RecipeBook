//
//  RecipeChatMessage 2.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 21/01/26.
//


import SwiftUI

struct RecipeChatMessage: Identifiable, Codable {
    
    enum Sender: String, Codable {
        case user, assistant
    }
    
    let id: UUID
    let sender: Sender
    let content: String
    let timestamp: Date
    
    init(sender: Sender,
         content: String,
         timestamp: Date = Date(),
         id: UUID = UUID()) {
        self.sender = sender
        self.content = content
        self.timestamp = timestamp
        self.id = id
    }
}

//MARK: - Previews

extension RecipeChatMessage {
    static var examples: [RecipeChatMessage] {
        [
            RecipeChatMessage(sender: .user,
                        content: "What is a good recipe for Fried Rice?"),
            RecipeChatMessage(sender: .assistant,
                        content: "Here is the good recipe for Fried Rice with some spicy tadka")
        ]
    }
}

extension RecipeChatMessage {
    
    // For PartiallyGenerated recipes
    static func from(partialRecipe: RecipeGenerative.PartiallyGenerated) -> RecipeChatMessage {
        RecipeChatMessage(
            sender: .assistant,
            content: partialRecipe.asMarkdown,
            timestamp: Date()
        )
    }
}
