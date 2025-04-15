//
//  DeletePopupView.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 24/03/25.
//

import SwiftUI

struct DeletePopupView: View {
    
    @State private var offset:CGFloat = 1000
    @Binding var isPopupDisplayed:Bool
    
    var body: some View {
        
        ZStack {
            Color(.black)
            .opacity(0.4)
            .onTapGesture {
                closePopup()
            }
            VStack(spacing: 40, content: {
                
                Image(systemName: "trash")
                    .resizable()
                    .frame(width: 60.0, height: 60.0)
                    .foregroundStyle(.accent)
                
                Text("Are you sure?")
                    .foregroundStyle(.secondaryPrimaryApp)
                    .font(.title)
                    .fontWeight(.bold)
                
                HStack(spacing: 40, content: {
                    Button(action: {
                        closePopup()
                    }) {
                        Text("Cancel")
                            .foregroundStyle(.gray)
                            .padding(10)
                    }.buttonStyle(.bordered)
                    
                    Button(action: {
                        debugPrint("cancel button tapped")
                    }) {
                        Text("Delete")
                            .foregroundStyle(.accent)
                            .padding(10)
                    }.buttonStyle(.bordered)
                })
            })
            .padding(50)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 5)
            .offset(x:0, y: offset)
            .onAppear {
                withAnimation(.spring) {
                    offset = 0
                }
            }
        }
        .ignoresSafeArea()
    }
    
    private func closePopup() {
        withAnimation(.spring, {
            offset = 1000
            isPopupDisplayed = false
        })
    }
}

#Preview {
    DeletePopupView(isPopupDisplayed: .constant(true))
}
