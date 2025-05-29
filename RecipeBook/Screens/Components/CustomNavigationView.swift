//
//  CustomNavigationView.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 14/05/25.
//

import SwiftUI

struct NavigationButton: Identifiable {
    let id = UUID()
    var systemImageName: String? = nil
    var imageName: String? = nil
    var title: String? = nil
    let action: () -> Void
}

struct NavigationTitle: Identifiable {
    let id = UUID()
    let title: String
    var subTitle: String? = nil
}

struct CustomNavigationView: View {
    
    var title: NavigationTitle? = nil
    var leadingButtons: [NavigationButton]? = nil
    var trailingButtons: [NavigationButton]? = nil
    var navBarHeight: CGFloat = 80.0
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        HStack {
            
            Spacer().frame(width: 30)
            
            if let leadingBtns = leadingButtons {
                HStack(spacing: 16) {
                    ForEach(leadingBtns) { button in
                        HStack {
                            Button(action: button.action) {
                                HStack {
                                    
                                    if let buttonImage = button.systemImageName {
                                        Image(systemName: buttonImage)
                                    } else {
                                        Image(button.imageName ?? "")
                                    }
                                    if let buttonTitle = button.title {
                                        Text(buttonTitle)
                                    }
                                }
                            }
                            .font(.title2)
                            .foregroundColor(.accent)
                        }
                    }
                }
            } else {
                Spacer().frame(width: 60)
            }
            
            Spacer()
            
            //Trailing button
            
            if let trailingBtns = trailingButtons {
                HStack(spacing: 16) {
                    ForEach(trailingBtns) { button in
                        Button(action: button.action) {
                            HStack {
                                if let buttonTitle = button.title {
                                    Text(buttonTitle)
                                }
                                if let buttonImage = button.systemImageName {
                                    Image(systemName: buttonImage)
                                } else {
                                    Image(button.imageName ?? "")
                                }
                            }
                        }
                        .font(.title2)
                        .foregroundColor(.accent)
                    }
                }
            } else {
                Spacer().frame(width: 60)
            }
            
            Spacer().frame(width: 30)
        }
        .overlay(content: {
            VStack(spacing: 4, content: {
                if let navigationTitle = title {
                    Text(navigationTitle.title)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.secondaryApp)
                    
                    if let subTitle = navigationTitle.subTitle {
                        Text(subTitle)
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                }
            })
        })
        .frame(height: navBarHeight)
        .background(
            //Color.secondary
        )
    }
}

#Preview {
    let titleDetails =  NavigationTitle(title: "Main title",subTitle: "Sub title")
    let leadingButton = NavigationButton(systemImageName: "chevron.left",title: "Back", action: {
        debugPrint("left button tap")
    })
    let trailingButton = NavigationButton(systemImageName: "chevron.right",title: "Right", action: {
        debugPrint("right button tap")
    })
    CustomNavigationView(title: titleDetails, leadingButtons: [leadingButton], trailingButtons: [trailingButton])
}
