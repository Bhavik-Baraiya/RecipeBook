//
//  ChatView.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 16/01/26.
//


import SwiftUI

struct ChatView: View {
    
    let messages: [ChatMessage]
    let isLoading: Bool
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {
                ForEach(messages) { message in
                    MarkdownText(markdown: message.content)
                        .modifier(StreamingViewModifier(sender: message.sender))
                }
                
                if isLoading {
                    ProgressView()
                }
                
            }
            .padding()
            .padding(.bottom, 100)
        }
    }
}

struct StreamingViewModifier: ViewModifier {
    
    let sender: ChatMessage.Sender
    
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

#Preview {
    ChatView(messages: ChatMessage.examples,
             isLoading: false)
}
