//
//  SettingsView.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 22/03/25.
//

import SwiftUI

//Settings Options

let darkModeSettingsOption = "Enable Dark Mode"
let viewModeSettingsOption = "List/Grid"
let aboutSettingsOption = "About"


let settingsItem: [SettingsItem] = [
    SettingsItem(iconName: "dark-mode", name: darkModeSettingsOption, isToggelRequired: true),
    SettingsItem(iconName: "view-mode", name: viewModeSettingsOption, isToggelRequired: true),
    SettingsItem(iconName: "about-app", name: aboutSettingsOption, isToggelRequired: false)
]

struct SettingsView: View {
    var body: some View {
        
        NavigationStack {
            List {
                ForEach(settingsItem.indices, id: \.self) { index in
    
                    Group {
                        if(settingsItem[index].name == aboutSettingsOption) {
                            
                            ZStack {
                                NavigationLink(destination: AboutView()) {
                                    SettingsItemCell(settingItem: settingsItem[index])
                                }.opacity(0)
                                SettingsItemCell(settingItem: settingsItem[index])
                            }
                        } else {
                            SettingsItemCell(settingItem: settingsItem[index])
                        }
                    }
                    .frame(height:60.0)
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
