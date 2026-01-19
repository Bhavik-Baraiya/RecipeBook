//
//  ContentView.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 22/03/25.
//

import SwiftUI

struct MainView: View {
    
    @State private var selectedTab = 0
    private var isAppleInteligenceAvailable: Bool = true
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            configureTabView()
        } //: TABVIEW
    }
    
    @ViewBuilder
    func configureTabView() -> some View {
        RecipeListView()
            .tabItem {
                Image(selectedTab == 0 ? "recipes-highlighted" : "recipes-plain")
                Text("My Recipe")
                    .foregroundStyle(.primaryApp)
                
            }.tag(0)
        
        if(isAppleInteligenceAvailable) {
            if #available(iOS 26.0, *) {
                
                AIChatView()
                    .tabItem {
                        Image(selectedTab == 1 ? "recipe-ai-highlighted" : "recipe-ai-plain")
                        Text("AI Recipe")
                            .foregroundStyle(.primaryApp)
                        
                    }.tag(1)
            }
        }
        
        FavouriteRecipeListView()
            .tabItem {
                Image(selectedTab == 2 ? "favourite-highlighted" : "favourite-plain")
                Text("Favourites")
                    .foregroundStyle(.primaryApp)
            }.tag(2)

        SettingsView()
            .tabItem {
                Image(selectedTab == 3 ? "settings-highlighted" : "settings-plain")
                Text("Settings")
                    .foregroundStyle(.primaryApp)
            }.tag(3)
    }
}

#Preview {
    MainView()
}
