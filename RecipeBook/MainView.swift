//
//  ContentView.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 22/03/25.
//

import SwiftUI

struct MainView: View {
    
    @State private var selectedTab = 0
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            
            RecipeListView()
                .tabItem {
                    Image(selectedTab == 0 ? "recipes-highlighted" : "recipes-plain")
                    Text("My Recipe")
                    
                }.tag(0)

            FavouriteRecipeListView(favouriteRecipes: recipeData)
                .tabItem {
                    Image(selectedTab == 1 ? "favourite-highlighted" : "favourite-plain")
                    Text("Favourites")
                }.tag(1)

            SettingsView()
                .tabItem {
                    Image(selectedTab == 2 ? "settings-highlighted" : "settings-plain")
                    Text("Settings")
                }.tag(2)
            
        } //: TABVIEW
    }
}

#Preview {
    MainView()
}
