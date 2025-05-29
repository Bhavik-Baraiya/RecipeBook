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
    @Query var recipes: [RecipeData]
    @State var displayAddRecipeView: Bool = false
    
    var body: some View {
        
        NavigationStack {
            
            VStack(spacing:0) {
                
                let titleDetails =  NavigationTitle(title: "Recipes")
                let trailingButton = NavigationButton(systemImageName: "plus.circle", action: {
                    displayAddRecipeView.toggle()
                })
                CustomNavigationView(title: titleDetails, trailingButtons: [trailingButton])
                
                Group {
                    
                    if(recipes.count > 0) {
                        
                        if(gridMode) {
                            ScrollView {
                                LazyVGrid(columns: definedColumns, content: {
                                    ForEach(recipes) { recipeItem in
                                        
                                        NavigationLink(destination: RecipeView(recipe: recipeItem)){
                                            
                                            RecipeListItemGridCell(recipeData: recipeItem)
                                            
                                        }.buttonStyle(PlainButtonStyle())
                                    }
                                }).padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                            }
                            
                        } else {
                            List {
                                ForEach(recipes) { item in
                                    NavigationLink(destination: RecipeView(recipe: item)) {
                                        RecipeListItemCell(recipeData: item)
                                    }
                                }
                            }
                        }
                    } else {
                        
                        Spacer()
                        
                        let contentUnavailabelData = CustomContentUnavailableModel(title: "No recipes available!", message: "Tap on + icon at top right corner to add your recipe",systemImage: "square.stack.3d.up")
                        CustomContentUnavailableView(contentUnavailableData: contentUnavailabelData)
                        
                        Spacer()
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $displayAddRecipeView, content: {
            AddRecipeView()
        })
        .toolbar(.hidden)
        .onAppear(perform: {
            FileHandler.createAppDocumentDirectory()
        })
    }
}

#Preview("English Language") {
    RecipeListView()
}

#Preview("German Language") {
    RecipeListView()
        .environment(\.locale, Locale(identifier: "DE"))
}
