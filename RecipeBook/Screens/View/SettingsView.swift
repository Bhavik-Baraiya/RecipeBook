//
//  SettingsView.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 22/03/25.
//

import SwiftUI

//Settings Options

let darkModeSettingsOption = "Enable Dark Mode"
let cloudSyncSettingsOption = "Sync on cloud"
let viewModeSettingsOption = "List/Grid"
let aboutSettingsOption = "About"


let settingsItem: [SettingsItem] = [
    SettingsItem(iconName: "dark-mode", name: darkModeSettingsOption, isToggelRequired: true),
    SettingsItem(iconName: "cloud-sync", name: cloudSyncSettingsOption, isToggelRequired: true),
    SettingsItem(iconName: "view-mode", name: viewModeSettingsOption, isToggelRequired: true),
    SettingsItem(iconName: "about-app", name: aboutSettingsOption, isToggelRequired: false)
]

struct SettingsView: View {
    var body: some View {
        
        NavigationStack {
            
            VStack {
                CustomNavigationView(title: "Settings", trainlingButtonImageName: "")
                List {
                    ForEach(settingsItem.indices, id: \.self) { index in
                        SettingsItemCell(settingItem: settingsItem[index])
                            .frame(height: 60)
                    }
                }
            }
            .toolbar(.hidden)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    SettingsView()
}
