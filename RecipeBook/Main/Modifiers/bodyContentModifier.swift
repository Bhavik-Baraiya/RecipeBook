//
//  bodyTextModifier.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 12/06/25.
//

import SwiftUI

struct bodyTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title2)
            .fontWeight(.bold)
    }
}

struct bodyTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.callout)
    }
}
