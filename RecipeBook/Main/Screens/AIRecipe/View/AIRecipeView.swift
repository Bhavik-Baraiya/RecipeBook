//
//  AIRecipeView.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 31/12/25.
//

import SwiftUI

struct AIRecipeView: View {
    
    @State private var aiRecipeVM = RecipeGenerator()
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Text("AI Recipe")
                    .font(.largeTitle)
                    .fontDesign(.rounded)
                    .fontWeight(.bold)
                    .foregroundStyle(.accent)
                
                Spacer()
                
                Text("Welcome to AI Recipe world")
                    .font(.headline)
                
                Spacer()
                
            }//Main VStack
        }
        .safeAreaInset(edge: .bottom, content: {
            HStack(content: {
                TextField("Ask recipe to AI", text: $aiRecipeVM.AIRecipeInput)
                Button {
                    
                } label: {
                    Text("Ask")
                        .background(in:
                            RoundedRectangle(cornerRadius: 20)
                        )
                }
            }) //UserInput HStack
            .padding()
        })
    }
}

#Preview {
    AIRecipeView()
}
