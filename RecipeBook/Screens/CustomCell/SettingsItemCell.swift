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
    
    @AppStorage(darkModeSupport) var darkModeEnabled: Bool = false
    @AppStorage(cloudSyncSupport) var cloudSyncEnabled: Bool = false
    @AppStorage(gridModeSupport) var gridMode: Bool = false
    
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
            case darkModeSettingsOption:
                return $darkModeEnabled
            case cloudSyncSettingsOption:
                return $cloudSyncEnabled
            case viewModeSettingsOption:
                return $gridMode
            default:
                return .constant(false) // Fallback if no matching ID is found
        }
    }
}

#Preview {
    SettingsItemCell(settingItem: item)
}
