//
//  SettingsItemCell.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 23/03/25.
//

import SwiftUI

struct SettingsItems {
    var iconName: String
    var itemName: String
}

let settingsItem: [SettingsItems] = [
    SettingsItems(iconName: "", itemName: <#T##String#>)
]


struct SettingsItemCell: View {
    
    private let itemsList: [SettingsItems]
    
    var body: some View {
        HStack {
            Image("")
                .resizable()
            Text("")
        }
    }
}

#Preview {
    SettingsItemCell(itemsList: <#[SettingsItems]#>)
}
