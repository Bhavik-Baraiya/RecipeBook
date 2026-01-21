//
//  RecipeSuggestionsView 2.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 20/01/26.
//


import SwiftUI

struct RecipeSuggestionsView: View {
    
    var viewModel: RecipeChatViewModel
    
    let suggestions = [
        "Tell me about Italian pasta dishes.",
        "What is a classic Indian curry?",
        "Suggest some popular Mexican street foods.",
        "What are traditional Mediterranean recipes?",
        "Tell me about Korean comfort food.",
        "What are some quick 15-minute dinner recipes?",
        "Is risotto hard to make for beginners?",
        "What recipes are good for first-time cooks?",
        "What meals can I cook in under 30 minutes?",
        "Which dishes are easy but impressive?",
        "What are some vegan dinner recipes?"
    ]
    
    @State var showMessage: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                Image("RecipeChatSuggesstionIcon")
                    .resizable()
                    .frame(width: 200, height: 200)
                
                ForEach(suggestions, id: \.self) { suggestion in
                    Button {
                        viewModel.userInput = suggestion
                        showMessage.toggle()
                        //viewModel.sendMessage()
                    } label: {
                        Text(suggestion)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.peachTint.opacity(0.6))
                            .cornerRadius(12)
                            .foregroundStyle(.black.opacity(0.7))
                    }
                }
            }
            .padding()
        }
        .alert("This feature is under development", isPresented: $showMessage, actions: {
            
        })
    }
}

#Preview {
    RecipeSuggestionsView(viewModel: RecipeChatViewModel())
}
