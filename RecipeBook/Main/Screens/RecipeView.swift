//
//  RecipeView.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 22/03/25.
//

import SwiftUI

struct RecipeView: View {
    
    @Bindable var recipe: RecipeData
    @State var displayPopup: Bool = false
    @State var perfromBack: Bool = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
            
            ZStack {
                
                ScrollView(.vertical) {
                    
                    VStack(spacing: 0) {
                        BannerView(recipeData: recipe)
                            .frame(height: 300)
                            .padding(.horizontal)
                            .padding(.vertical)
                        
                        recipeHeaderView()
                        
                        DetailsView(recipeData: recipe)
                    }
                }
                
                if(displayPopup) {
                    DeletePopupView(isPopupDisplayed: $displayPopup, recipeData: recipe, refreshPage: $perfromBack)
                }
            }
            .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    HStack {
                        
                        Button(action: {
                            displayPopup.toggle()
                        }) {
                            Image(systemName: "trash")
                                .imageScale(.medium)
                        }
                        
                        NavigationLink {
                            
                            EditRecipeView(recipeData: recipe)
                            
                        } label: {
                            
                            HStack {
                                Image(systemName: "pencil.circle")
                                    .imageScale(.large)
                                    .foregroundColor(.accentColor)
                                
                            }
                            .padding(0)
                        }
                    }
                }
                
        }
        .onChange(of: perfromBack, {
            dismiss()
        })
        .navigationTitle(recipe.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private func recipeHeaderView() -> some View {
        
        var prepTime: String {
            "\(recipe.preparationTimeInHours):\(recipe.preparationTimeInMinutes)"
        }
        
        var recipeLevel: String {
            getDifficultyLevel(for: recipe.level)
        }
        
        let headerData = [
            RecipeHeaderViewContent(systemImage: "clock", title: prepTime),
            RecipeHeaderViewContent(systemImage: "flame.fill", title: recipeLevel)
            //RecipeHeaderViewContent(systemImage: "fork.knife", title: "Desert"),
        ]
        
        HStack(alignment:.center, spacing: 20) {
            
            Spacer().frame(width: 0)
            
            ForEach(headerData, id: \.id) { item in
                self.getHeaderImageText(imageName: item.systemImage, title: item.title)
            }
            
            Spacer()
            
            Button(action: {
                recipe.isFavourite.toggle()
            }, label: {
                Image(systemName: recipe.isFavourite ? "heart.fill" : "heart")
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
    
    
    func getHeaderImageText(imageName:String,title: String) -> some View{
       HStack(spacing: 5) {
        Image(systemName: imageName)
        Text(title)
       }
    }
    
    func getDifficultyLevel(for value: Int) -> String {
        if let level = DifficultyLevel(rawValue: value) {
            return level.description
        } else {
            return "Unknown"
        }
    }
}

#Preview {
    RecipeView(recipe: RecipeData(title: "Spaghetti Carbonara",
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
                                  level: 1, preparationTimeInHours: 10,
                                  preparationTimeInMinutes: 15,
                                  imageNames: [""],
                                  videos: [], isFavourite: true)
    )
}
