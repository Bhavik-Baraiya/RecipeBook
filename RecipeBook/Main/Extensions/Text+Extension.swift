//
//  Button+Extension.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 12/06/25.
//

import SwiftUI

extension View {
    func bodyTitleStyle() -> some View {
        modifier(bodyTitleModifier())
    }
    func bodyTextStyle() -> some View {
        modifier(bodyTextModifier())
    }
}

