//
//  RecipeView.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 22/03/25.
//

import SwiftUI

// MARK: - View
struct RecipeView: View {
    @State private var viewModel: RecipeViewModel
    @Environment(\.dismiss) var dismiss
    
    init(recipe: RecipeData) {
        _viewModel = State(initialValue: RecipeViewModel(recipe: recipe))
    }
    
    var body: some View {
        ZStack {
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    BannerView(recipeData: viewModel.recipe)
                        .frame(height: 300)
                        .padding(.horizontal)
                        .padding(.vertical)
                    
                    recipeHeaderView()
                    
                    DetailsView(recipeData: viewModel.recipe)
                }
            }
            
            if viewModel.displayPopup {
                DeletePopupView(
                    isPopupDisplayed: $viewModel.displayPopup,
                    recipeData: viewModel.recipe,
                    refreshPage: $viewModel.performBack
                )
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button(action: {
                        viewModel.toggleDeletePopup()
                    }) {
                        Image(systemName: "trash")
                            .imageScale(.medium)
                    }
                    
                    NavigationLink {
                        EditRecipeView(recipeData: viewModel.recipe)
                    } label: {
                        Image(systemName: "pencil.circle")
                            .imageScale(.large)
                            .foregroundColor(.accentColor)
                    }
                }
            }
        }
        .onChange(of: viewModel.performBack) {
            dismiss()
        }
        .onChange(of: viewModel.displayPopup) {
            viewModel.displayPopup.toggle()
        }
        .navigationTitle(viewModel.recipe.title)
        .navigationBarTitleDisplayMode(.inline)
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
            
            Button(action: {
                viewModel.toggleFavorite()
            }, label: {
                Image(systemName: viewModel.recipe.isFavourite ? "heart.fill" : "heart")
            })
            
            Spacer().frame(width: 0)
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
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        RecipeView(recipe: RecipeData(
            title: "Spaghetti Carbonara",
            ingredients: """
                - 200g spaghetti
                - 100g pancetta
                - 2 large eggs
                - 50g Parmesan cheese
                - Salt and pepper
                """,
            instructions: """
                1. Cook spaghetti in salted water.
                2. Fry pancetta until crispy.
                3. Beat eggs and mix with Parmesan.
                4. Mix spaghetti with pancetta and egg mixture.
                5. Serve immediately.
                """,
            category: "Italian",
            level: 1,
            preparationTimeInHours: 10,
            preparationTimeInMinutes: 15,
            imageNames: [""],
            videos: [],
            isFavourite: true
        ))
    }
}
