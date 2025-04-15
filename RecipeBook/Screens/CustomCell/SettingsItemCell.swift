//
//  SettingsItemCell.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 23/03/25.
//

import SwiftUI

struct SettingsItem {
    var iconName: String
    var name: String
    var isToggelRequired: Bool
}

let item = SettingsItem(iconName: "dark-mode", name: "Enable Dark Mode", isToggelRequired: true)

struct SettingsItemCell: View {
    
    let settingItem: SettingsItem
    
    //AppStorages
    
    @AppStorage("dark-mode") var darkModeEnabled: Bool = false
    @AppStorage("cloud-sync") var cloudSyncEnabled: Bool = false
    @AppStorage("grid-mode") var gridMode: Bool = false
    
    var body: some View {
        HStack {
            
            Image(settingItem.iconName)
                .resizable()
                .frame(width: 30,height: 30)
                .foregroundColor(.primary)

            if settingItem.isToggelRequired {
                Toggle(isOn: getBinding(for: settingItem)) {
                    Text(settingItem.name)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .fontWeight(.medium)
                }
                .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                
            } else {
                Text(settingItem.name)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .fontWeight(.medium)
            }

        }
    }
    private func getBinding(for item: SettingsItem) -> Binding<Bool> {
        switch item.name {
            case "Enable Dark Mode":
                return $darkModeEnabled
            case "Sync on cloud":
                return $cloudSyncEnabled
            case "List/Grid":
                return $gridMode
            default:
                return .constant(false) // Fallback if no matching ID is found
        }
    }
}

#Preview {
    SettingsItemCell(settingItem: item)
}
