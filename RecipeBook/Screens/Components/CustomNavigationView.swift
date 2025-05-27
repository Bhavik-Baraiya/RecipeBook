//
//  CustomNavigationView.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 14/05/25.
//

import SwiftUI

struct CustomNavigationView: View {
    
    var leadingButtonImageName: String = ""
    var leadingButtonTitle: String = ""
    var title: String = ""
    var trailingButtonImageName: String = ""
    var trailingButtonTitle: String = ""
    
    // MARK: navbar button action
    
    var onLeadingTap: (() -> Void)? = nil
    var onTrailingTap: (() -> Void)? = nil
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        HStack {
            
            Spacer().frame(width: 30)
            
            if let onLeadingTap = onLeadingTap {
                Button(action: {
                    onLeadingTap()
                }, label: {
                    
                    HStack(spacing:5) {
                        Image(systemName: leadingButtonImageName)
                            .font(.title2)
                        Text(leadingButtonTitle)
                            .frame(width: 60)
                    }
                })
                .frame(width: 60)
                
            } else {
                // Maintain spacing if button is not shown
                Spacer().frame(width: 60)
            }
            
            
            Spacer()
            
            //Center label
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
            
            Spacer()
            
            //Trailing button
            
            if let onTrailingTap = onTrailingTap {
                Button(action: {
                    onTrailingTap()
                }, label: {
                    
                    HStack(spacing:5) {
                        Text(trailingButtonTitle)
                            .frame(width: 60)
                        Image(systemName: trailingButtonImageName)
                            .font(.title2)
                    }
                })
                .frame(width: 60)
                
            } else {
                // Maintain spacing if button is not shown
                Spacer().frame(width: 60)
            }
            Spacer().frame(width: 30,height: 60)
        }
        .background(
            //Color.orangeMist
        )
    }
}

#Preview {
    CustomNavigationView(leadingButtonImageName: "chevron.left", title: "title",trailingButtonImageName:"",trailingButtonTitle: "Update",onLeadingTap: {
        
    }, onTrailingTap: {
        
    })
}
