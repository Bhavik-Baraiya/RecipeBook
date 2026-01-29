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
    @Environment(\.modelContext) var recipeModelContext
    
    var body: some View {
        NavigationStack {
            VStack {
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
                        partialRecipeId: viewModel.partialRecipeId,
                        saveAction: {
                            print("Save action tapped")
                            Task {
                                await viewModel.generateRecipe()
                            }
                        },
                        shareAction: {
                            print("Share action tapped")
                            if let content = viewModel.chatmessages.last?.content {
                                viewModel.responseFileURL = createTextFile(text: content, fileName: "MyText")
                                viewModel.showShareSheet = viewModel.responseFileURL != nil
                            }
                        },
                        viewModel: viewModel
                    )
                }
                
                HStack {
                    
                    Spacer()
                    
                    TextField("Ask recipes here", text: $viewModel.userInput)
                        .onSubmit {
                            viewModel.sendQuery()
                        }
                    
                    Button {
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
            .task {
                viewModel.loadModel()
                viewModel.context = recipeModelContext
            }
        }
        .sheet(isPresented: $viewModel.showShareSheet) {
            if let file = viewModel.responseFileURL {
                ActivityView(activityItems: [file])
            }
        }
    }
}

#Preview {
    RecipeAIChatView()
}
