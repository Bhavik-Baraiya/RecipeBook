//
//  RecipeView.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 22/03/25.
//

import SwiftUI

// MARK: - View
@available(iOS 26.0, *)
struct AIRecipeView: View {
    @State private var viewModel: AIRecipeViewModel
    @Environment(\.dismiss) var dismiss
    
    init(recipe: RecipeGenerative.PartiallyGenerated) {
        _viewModel = State(initialValue: AIRecipeViewModel(recipe: recipe))
    }
    
    var body: some View {
        ZStack {
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    Spacer()
                    recipeHeaderView()
                    AIRecipeDetailsView(recipeData: viewModel.recipe)
                    Spacer()
                    HStack(alignment: .center, spacing: 20) {
                        Spacer().frame(width: 0)
                        
                        if let shortMessage = viewModel.recipe.shortMessage {
                            getHeaderImageText(imageName: "spoon.serving", title: LocalizedStringKey(shortMessage))
                        }
                        
                        Spacer()
                        
                        Spacer().frame(width: 0)
                    }
                    .frame(height: 60.0)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.thinMaterial)
                    )
                    .padding(.horizontal)
                }
                .padding()
            }
        }
    }
    
    // MARK: - Subviews
    @ViewBuilder
    private func recipeHeaderView() -> some View {
        HStack(alignment: .center, spacing: 20) {
            Spacer().frame(width: 0)
            
            ForEach(viewModel.headerData, id: \.id) { item in
                getHeaderImageText(imageName: item.systemImage, title: item.title)
            }
            
            Spacer()
        }
        .frame(height: 60.0)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.thinMaterial)
        )
        .padding(.horizontal)
    }
    
    private func getHeaderImageText(imageName: String, title: LocalizedStringKey) -> some View {
        HStack(spacing: 5) {
            Image(systemName: imageName)
            Text(title)
        }
        .animation(.easeInOut, value: title)
    }
}
