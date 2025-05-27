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
    @State var showEditRecipeView: Bool = false
    @Environment(\.dismiss) var perfromBack
    
    var body: some View {
            
            ZStack {
                ScrollView(.vertical) {
                    
                    VStack(spacing: 0) {
                        
                        CustomNavigationView(leadingButtonImageName: "chevron.left", title:$recipe.title.wrappedValue,trailingButtonImageName: "pencil.circle",trailingButtonTitle: "", onLeadingTap: {
                            perfromBack()
                        }, onTrailingTap: {
                            showEditRecipeView.toggle()
                        })
                        
                        BannerView(images: $recipe.imageNames.wrappedValue)
                            .frame(height: 300)
                            .padding(20)
                        
                        Button(action: {
                            $recipe.isFavourite.wrappedValue.toggle()
                        })
                        {
                            Image(systemName: $recipe.isFavourite.wrappedValue ? "heart.fill": "heart")
                                .resizable()
                                .scaledToFill()
                        }
                            .frame(width: 25,height: 25)
                            .background(
                                Circle()
                                    .fill(Color.gray)
                                    .opacity(0.3)
                                    .frame(width: 50, height: 50, alignment: .center)
                            )
                            .offset(x:155, y: -40)
                            
                        
                        Text(recipe.category)
                            .font(.title)
                            .foregroundColor(.primary)
                            .background(
                                Color.accentColor
                                    .frame(height: 5)
                                    .offset(y:20)
                            )
                            .padding(.horizontal)
                        
                        DetailsView(recipeData: recipe)
                        
                        Spacer()
                    }
                }
                
                if(displayPopup) {
                    DeletePopupView(isPopupDisplayed: $displayPopup, recipeData: recipe)
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
        .fullScreenCover(isPresented: $showEditRecipeView, content: {
            EditRecipeView(recipeData: recipe)
        })
        .navigationTitle(recipe.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden)
    }
}

#Preview {
    RecipeView(recipe: RecipeData(title: "", ingredients: "", instructions: "", category: "", preparationTimeInHours: 0, preparationTimeInMinutes: 1, imageNames: [""], isFavourite: true))
}
