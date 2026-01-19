//
//  AIChatView.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 20/01/26.
//

import SwiftUI

struct AIChatView: View {
    @State private var viewModel = ChatViewModel()
    @State private var showHistory: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.messages.isEmpty {
                    SuggestionsView(viewModel: viewModel)
                        .frame(maxHeight: .infinity)
                } else {
                    ChatView(messages: viewModel.messages,
                             isLoading: viewModel.isResponding,
                             partial: viewModel.partial,
                             partialId: viewModel.partialId)
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
                            .foregroundStyle(viewModel.isResponding ? .gray :.orange)
                            .font(.title)
                    }
                    .disabled(viewModel.isResponding)
 
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
    AIChatView()
}
