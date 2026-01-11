//
//  AIChatScreen.swift
//  onDeviceAI
//
//  Created by Bhavik Baraiya on 29/12/25.
//

import SwiftUI
import FoundationModels

@available(iOS 26.0, *)
struct AIChatScreen: View {
    
    @State var generativeVM = Generative()
    
    var body: some View {
        
        ScrollView {
                    
            VStack {
                
                Text("Ask RecipeAI")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.orange)
                
                Spacer()

                if let recipeData = generativeVM.recipeData {
                    
                    AIRecipeView(recipe: recipeData)
                        .id(UUID())
                        .animation(.smooth, value: recipeData)
                }
            }
            .task {
                generativeVM.loadModel()
            }
            .padding()
        }
        .safeAreaInset(edge: .bottom, content: {
            
            ZStack(content: {
                Color(.systemBackground.withAlphaComponent(0.1))
                    .background(
                        .thinMaterial
                    )
                    .glassEffectTransition(.materialize)
                    .frame(height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                HStack {
                    
                    Spacer()
                    
                    TextField("Ask recipes here", text: $generativeVM.prompt)
                    
                    if(generativeVM.isLoading) {
                        ProgressView()
                    }
                    
                    Button {
                        Task {
                          await generativeVM.generateResponse(prompt: generativeVM.prompt)
                        }
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .foregroundStyle(generativeVM.isLoading ? .gray :.orange)
                            .font(.title)
                    }
                    .disabled(generativeVM.isLoading)
                    .onSubmit(of: .search, {
                        Task {
                          await generativeVM.generateResponse(prompt: generativeVM.prompt)
                        }
                    })
                    Spacer()
                }
                
            })
            .padding()
        })
        .alert(generativeVM.error, isPresented: $generativeVM.errorOccurred, actions: {
            
        })
    }
}

#Preview {
    if #available(iOS 26.0, *) {
        AIChatScreen()
    } else {
        // Fallback on earlier versions
    }
}
