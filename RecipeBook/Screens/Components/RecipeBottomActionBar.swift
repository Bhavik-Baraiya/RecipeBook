//
//  RecipeBottomActionBar.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 04/06/25.
//

import SwiftUI

struct BottomActionButton: Identifiable {
    var id: UUID = UUID()
    var imageName: String? = nil
    var systemImageName: String? = nil
    var title: String? = nil
    var action: (() -> Void)?
}


struct RecipeBottomActionBar: View {
    
    var buttons: [BottomActionButton]?
    
    var body: some View {
        HStack(alignment:.center) {
            
            if let buttons = buttons {
                ForEach(buttons, id: \.id) { button in
                    Spacer()
                    Button(action: {
                        button.action?()
                    })
                    {
                        if let imageName = button.imageName {
                            Image(imageName)
                                .font(.footnote)
                        }
                        
                        if let systemImageName = button.systemImageName {
                            Image(systemName: systemImageName)
                                .font(.footnote)
                        }
                        
                        Text(button.title ?? "")
                            .foregroundStyle(Color.primary)
                            .padding(10)
                    }
                    .frame(width: 120.0)
                    .buttonStyle(.bordered)
                    .padding(.vertical)
                    Spacer()
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.clear)
        )
        .padding(.horizontal)
       
    }
}

#Preview {
    
    let primaryButton = BottomActionButton(title: "Add",action: { print("Add tapped") })
    let secondaryButton = BottomActionButton(title: "Cancel")
    
    let bottomBtns = [primaryButton, secondaryButton]
    
    RecipeBottomActionBar(buttons: bottomBtns)
}
