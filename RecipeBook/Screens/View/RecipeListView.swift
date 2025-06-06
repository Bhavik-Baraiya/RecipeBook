//
//  RecipeListView.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 22/03/25.
//

import SwiftData
import SwiftUI

let definedColumns = [
    GridItem(.flexible(), spacing: 5),
    GridItem(.flexible(), spacing: 5)
]

struct RecipeListView: View {
    
    // MARK: - AppStorage
    @AppStorage("grid-mode") var gridMode: Bool = false
    
    // MARK: - Environment
    @Environment(\.modelContext) var recipeModelContext
    
    // MARK: - State
    @State private var recipes: [RecipeData] = []
    @State private var shouldRefresh = false
    
    var body: some View {
        
        NavigationStack {
            Group {
                if recipes.isEmpty {
                    let contentUnavailabelData = CustomContentUnavailableModel(title: "No recipes available!", message: "Tap on + icon at top right corner to add your recipe",systemImage: "square.stack.3d.up")
                    CustomContentUnavailableView(contentUnavailableData: contentUnavailabelData)
                    .foregroundStyle(.accent)
                    .padding(20)
                } else {
                    if gridMode {
                        ScrollView {
                            LazyVGrid(columns: definedColumns) {
                                ForEach(recipes) { recipeItem in
                                    NavigationLink(destination: RecipeView(recipe: recipeItem)) {
                                        RecipeListItemGridCell(recipeData: recipeItem)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    } else {
                        List(recipes) { recipeItem in
                            NavigationLink(destination: RecipeView(recipe: recipeItem)) {
                                RecipeListItemCell(recipeData: recipeItem)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Recipes")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing, content: {
                    
                    NavigationLink {
                        AddRecipeView(dataReloadRequest: $shouldRefresh)
                    } label:{
                        Image(systemName: "plus.circle")
                            .imageScale(.large)
                            .fontWeight(.semibold)
                    }
                })
            }
            .onAppear {
                loadData()
            }
            .onChange(of: shouldRefresh, {
                loadData()
            })
        }
    }
    
    private func loadData() {
        let manager = DataManager.init(modelContext: recipeModelContext)
        recipes = manager.fetch()
    }
}

#Preview {
    RecipeListView()
}
