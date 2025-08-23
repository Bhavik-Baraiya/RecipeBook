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
                    
                    bottomBarSpacerView()
                     
                    Button(action: {
                        //button.action?()
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
                            .font(.callout).fontDesign(.rounded)
                            .foregroundStyle(Color.primary)
                    }
                    .frame(width: 120.0,height: 55.0)
                    .padding(.vertical)
                    .background(content: {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.2))
                            .padding(.vertical)
                    })
                    .onTapGesture(perform: {
                        button.action?()
                        debugPrint("\(String(describing: button.title)) perfromed")
                    })
                    
                    bottomBarSpacerView()
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.clear)
        )
    }
    
    func bottomBarSpacerView() -> some View {
        return Spacer().frame(width: UIDevice.isIPad ? 120 : 40)
    }
}

#Preview {
    
    let primaryButton = BottomActionButton(title: "Add",action: { print("Add tapped") })
    let secondaryButton = BottomActionButton(title: "Cancel")
    
    let bottomBtns = [primaryButton, secondaryButton]
    
    RecipeBottomActionBar(buttons: bottomBtns)
}
