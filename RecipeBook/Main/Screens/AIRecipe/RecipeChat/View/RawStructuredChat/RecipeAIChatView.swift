//
//  RecipeAIChatView 2.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 20/01/26.
//


import SwiftUI

struct RecipeAIChatView: View {
    @State private var viewModel = RecipeChatViewModel()
    @State private var showHistory: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
//                if viewModel.chatmessages.isEmpty {
                if viewModel.chatmessages.isEmpty {
                    RecipeSuggestionsView(viewModel: viewModel)
                        .frame(maxHeight: .infinity)
                } else {
                    RecipeChatView(
                        messages: viewModel.messages,
                        chatMessages: viewModel.chatmessages,
                        isLoading: viewModel.isLoading,
                        partial: viewModel.partial,
                        partialId: viewModel.partialId,
                        partialRecipe: viewModel.partialRecipe,
                        partialRecipeId: viewModel.partialRecipeId
                    )
                }
                
                HStack {
                    
                    Spacer()
                    
                    TextField("Ask recipes here", text: $viewModel.userInput)
                        .onSubmit {
//                            viewModel.sendMessage()
                            viewModel.sendQuery()
                        }
                    
                    Button {
//                        viewModel.sendMessage()
                        viewModel.sendQuery()
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .foregroundStyle(viewModel.isLoading ? .gray :.orange)
                            .font(.title)
                    }
                    .disabled(viewModel.isLoading)
 
                    Spacer()
                }
                .padding()
            }
            .toolbar {
                Button("Convert into RecipeForm") {
                    Task {
                        await viewModel.generateRecipe()
                    }
                }
            }
            .task {
                viewModel.loadModel()
            }
        }
    }
}

#Preview {
    RecipeAIChatView()
}
