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
    
    var leadingButtonHidden: Bool = false
    @State var isSheetPresented: Bool = false

    
    @Environment(\.dismiss) var dismiss
    var body: some View {
        
        HStack {
            
            Spacer().frame(width: 30)
            
            Button(action: {
                dismiss()
            }, label: {
                
                HStack(spacing:5) {
                    Image(systemName: leadingButtonImageName)
                        .font(.title2)
                    Text(leadingButtonTitle)
                        .frame(width: 40)
                }
            })
            .frame(width: 40)
            .opacity(leadingButtonHidden ? 0 : 1)
            
            Spacer()
            
            //Center label
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
            
            Spacer()
            
            //Trailing button
            Button(action: {
                isSheetPresented.toggle()
                debugPrint("trailing button tapped")
            }, label: {
                
                HStack(spacing:5) {
                    Text(trailingButtonTitle)
                        .frame(width: 40)
                    Image(systemName: trailingButtonImageName)
                        .font(.title2)
                }
            })
            .frame(width: 40)
            .fullScreenCover(isPresented: $isSheetPresented, content: {
                NavigationStack {
                    AddRecipeView()
                }
            })
            Spacer().frame(width: 30,height: 60)
        }
        .background(
            //Color.orangeMist
        )
    }
}

#Preview {
    CustomNavigationView(leadingButtonImageName: "chevron.left",leadingButtonTitle:"", title: "Recipes", trailingButtonImageName: "plus.circle",trailingButtonTitle: "")
}
