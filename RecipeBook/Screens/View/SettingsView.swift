//
//  SettingsView.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 22/03/25.
//

import SwiftUI

let settingsItem: [SettingsItem] = [
    SettingsItem(iconName: "dark-mode", name: "Enable Dark Mode", isToggelRequired: true),
    SettingsItem(iconName: "cloud-sync", name: "Sync on cloud", isToggelRequired: true),
    SettingsItem(iconName: "view-mode", name: "List/Grid", isToggelRequired: true),
    SettingsItem(iconName: "about-app", name: "About", isToggelRequired: false)
]

struct SettingsView: View {
    var body: some View {
        
        NavigationStack {
            List {
                ForEach(settingsItem.indices, id: \.self) { index in
                    SettingsItemCell(settingItem: settingsItem[index])
                        .frame(height: 60)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    SettingsView()
}
