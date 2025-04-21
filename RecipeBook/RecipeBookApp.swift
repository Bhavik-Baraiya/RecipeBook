//
//  RecipeBookApp.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 22/03/25.
//

import SwiftUI

@main
struct RecipeBookApp: App {
    @AppStorage("dark-mode") var isDarkModeEnabled:Bool = false
    var body: some Scene {
        WindowGroup {
            MainView()
                .preferredColorScheme(isDarkModeEnabled ? .dark : .light)
        }
    }
}
