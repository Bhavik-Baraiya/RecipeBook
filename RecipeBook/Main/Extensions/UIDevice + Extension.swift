//
//  UIDevice + Extension.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 27/06/25.
//

import UIKit

extension UIDevice {
    static var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
}

