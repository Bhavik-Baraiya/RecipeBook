//
//  CustomNavigationView.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 14/05/25.
//

import SwiftUI

struct CustomNavigationView: View {
    
    var title: String
    var trainlingButtonImageName: String
    var leadingButtonImageName: String = ""
    var leadingButtonHidden: Bool = false
    @State var isSheetPresented: Bool = false

    
    @Environment(\.dismiss) var dismiss
    var body: some View {
        
        HStack {
            
            Spacer().frame(width: 20)
            
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: leadingButtonImageName)
                    .font(.title)
            })
            .opacity(leadingButtonHidden ? 0 : 1)
            
            Spacer()
            
            //Center label
            Text(title)
                .font(.title)
                .fontWeight(.semibold)
            
            Spacer()
            
            //Trailing button
            Button(action: {
                isSheetPresented.toggle()
                debugPrint("trailing button tapped")
            }, label: {
                Image(systemName: trainlingButtonImageName)
                    .font(.title)
            })
            .fullScreenCover(isPresented: $isSheetPresented, content: {
                NavigationStack {
                    AddRecipeView()
                }
            })
            Spacer().frame(width: 20,height: 60)
        }
        .background(
            Color.clear
        )
        .frame(height: 80)
    }
}

#Preview {
    CustomNavigationView(title: "Recipes", trainlingButtonImageName: "", leadingButtonImageName: ""	)
}
