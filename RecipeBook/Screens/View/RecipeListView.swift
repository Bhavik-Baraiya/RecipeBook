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
    var body: some View {
        
        VStack {
            
            CustomNavigationView(title: "Recipes")
                .background(Color.white)
                .shadow(color:.gray.opacity(0.2),radius: 1,x:0,y:5)
            
            Spacer()
            
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
                            }).padding(.leading, 20)
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
                    let contentUnavailabelData = CustomContentUnavailableModel(title: "No recipes available!", message: "Tap on + icon at top right corner to add your recipe",systemImage: "square.stack.3d.up")
                    CustomContentUnavailableView(contentUnavailableData: contentUnavailabelData)
                }
            }
            Spacer()
        }
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
