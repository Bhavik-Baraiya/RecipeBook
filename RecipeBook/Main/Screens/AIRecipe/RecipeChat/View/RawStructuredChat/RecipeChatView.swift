//
//  RecipeChatView 2.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 20/01/26.
//

import SwiftUI

struct RecipeChatView: View {
    
    let messages: [RecipeChatMessage]
    let isLoading: Bool
    
    let partial: String.PartiallyGenerated?
    let partialId: UUID?
    
    // Add partial recipe for streaming
    let partialRecipe: RecipeGenerative.PartiallyGenerated?
    let partialRecipeId: UUID?
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {
                ForEach(messages) { message in
                    MarkdownText(markdown: message.content)
                        .modifier(RecipeStreamingViewModifier(sender: message.sender))
                }
                
                // Display streaming recipe
                if let partialRecipe = partialRecipe, let id = partialRecipeId {
                    MarkdownText(markdown: partialRecipe.asMarkdown)
                        .modifier(StreamingViewModifier(sender: .assistant))
                        .contentTransition(.opacity)
                        .animation(.easeInOut(duration: 0.3), value: partialRecipe)
                        .id(id)
                }
                
                // Display string partial if any
                if let partial, let id = partialId {
                    StreamingResponseView(partial: partial)
                        .id(id)
                } else if isLoading {
                    ProgressView()
                }
                    
            }
            .padding()
            .padding(.bottom, 100)
        }
    }
}

struct RecipeStreamingViewModifier: ViewModifier {
    
    let sender: RecipeChatMessage.Sender
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(sender == .user ? Color.primaryApp.opacity(0.6) : Color.primaryApp.opacity(0.3))
            .cornerRadius(12)
            .padding(sender == .user ? .leading : .trailing, 20)
            .frame(maxWidth: .infinity,
                   alignment: sender == .user ? .trailing : .leading)
    }
}

