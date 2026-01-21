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
                if viewModel.messages.isEmpty {
                    RecipeSuggestionsView(viewModel: viewModel)
                        .frame(maxHeight: .infinity)
                } else {
                    RecipeChatView(
                        messages: viewModel.messages,
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
                            viewModel.sendMessage()
                        }
                    
                    Button {
                        viewModel.sendMessage()
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
            .task {
                viewModel.loadModel()
            }
        }
    }
}

#Preview {
    RecipeAIChatView()
}
