//
//  ChatMessage.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 16/01/26.
//


import SwiftUI

struct ChatMessage: Identifiable, Codable {
    
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

extension ChatMessage {
    static var examples: [ChatMessage] {
        [
            ChatMessage(sender: .user,
                        content: "What is a good recipe for Fried Rice?"),
            ChatMessage(sender: .assistant,
                        content: "Here is the good recipe for Fried Rice with some spicy tadka")
        ]
    }
}
