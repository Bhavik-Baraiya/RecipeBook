//
//  CustomNavigationView.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 14/05/25.
//

import SwiftUI

struct CustomNavigationView: View {
    
    var title: String
    
    var body: some View {
        
        HStack {
            
            Spacer().frame(width: 20)
            
            //Leading button
            Button(action: {
                debugPrint("leading button tapped")
            }, label: {
                
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.clear)
                    .frame(width: 50,height: 50)
            })
            
            Spacer()
            
            //Center label
            Text("Recipes")
                .font(.title)
                .fontWeight(.bold)
            
            Spacer()
            
            //Trailing button
            Button(action: {
                debugPrint("trailing button tapped")
            }, label: {
                Image(systemName: "plus.circle")
                    .font(.largeTitle)
            })
            
            Spacer().frame(width: 20,height: 80)
        }
        .background(
            .fill.quinary
        )
        .frame(height: 80)
    }
}

#Preview {
    CustomNavigationView(title: "Recipes")
}
