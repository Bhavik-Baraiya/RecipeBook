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
    
    //AppStorages
    @AppStorage("grid-mode") var gridMode: Bool = false
    
    //private let recipes = recipeData
    @Query var recipes: [RecipeData]
    
    var body: some View {
        
        NavigationView {

            if(recipes.count > 0) {
                
                if(gridMode) {
                    ScrollView {
                        LazyVGrid(columns: definedColumns, content: {
                            ForEach(recipes) { recipeItem in
                                
                                NavigationLink(destination: RecipeView(recipe: recipeItem)){
                                    
                                    RecipeListItemGridCell(recipeData: recipeItem)
                                    
                                }.buttonStyle(PlainButtonStyle())
                            }
                        })
                    }
                    .navigationTitle("Recipes")
                    .navigationBarTitleDisplayMode(.large)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing, content: {

                            NavigationLink {
                                AddRecipeView()
                            } label:{
                                Image(systemName: "plus.circle")
                                    .imageScale(.large)
                                    .fontWeight(.semibold)
                            }
                        })
                    }
                    
                } else {
                    List {
                        ForEach(recipes) { item in
                            NavigationLink(destination: RecipeView(recipe: item)) {
                                RecipeListItemCell(recipeData: item)
                            }
                        }
                    }
                    .navigationBarTitle("Recipes",displayMode: .large)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing, content: {
                            NavigationLink {
                                AddRecipeView()
                            } label: {
                                Image(systemName: "plus.circle")
                                    .imageScale(.large)
                                    .fontWeight(.semibold)
                            }
                        })
                    }
                }
            } else {
                VStack(alignment: .center, spacing: 20, content: {
                    
                    Text("No recipes available!")
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.accentColor)
                    
                    Text("Tap on + icon at top right corner to add your recipe")
                        .font(.subheadline)
                        .foregroundStyle(Color.accentColor)
                        .multilineTextAlignment(.center)
                    
                }).frame(width: 300)
                    .navigationBarTitle("Recipes",displayMode: .large)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing, content: {
                            NavigationLink {
                                AddRecipeView()
                            } label: {
                                Image(systemName: "plus.circle")
                                    .imageScale(.large)
                                    .fontWeight(.semibold)
                            }
                        })
                    }
            }
        }.onAppear(perform: {
            FileHandler.createAppDocumentDirectory()
        })
    }
}

#Preview {
    RecipeListView()
}
