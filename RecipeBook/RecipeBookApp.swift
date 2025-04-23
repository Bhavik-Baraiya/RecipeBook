//
//  RecipeBookApp.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 22/03/25.
//

import SwiftData
import SwiftUI

@main
struct RecipeBookApp: App {
    @AppStorage(darkModeSupport) var isDarkModeEnabled:Bool = false
    var body: some Scene {
        WindowGroup {
            MainView()
                .preferredColorScheme(isDarkModeEnabled ? .dark : .light)
        }
        .modelContainer(for: RecipeData.self)
    }
}
