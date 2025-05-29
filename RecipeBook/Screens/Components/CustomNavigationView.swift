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

    var body: some View {
        ZStack {
            // Centered Title & Subtitle
            if let navigationTitle = title {
                VStack(spacing: 4) {
                    Text(navigationTitle.title)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.secondaryApp)

                    if let subTitle = navigationTitle.subTitle {
                        Text(subTitle)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .multilineTextAlignment(.center)
            }

            // Leading & Trailing Buttons
            HStack {
                // Leading buttons
                if let leadingBtns = leadingButtons {
                    HStack(spacing: 16) {
                        ForEach(leadingBtns) { button in
                            NavigationBarButtonView(button: button)
                        }
                    }
                } else {
                    Spacer().frame(width: 60) // Ensure alignment
                }

                Spacer()

                // Trailing buttons
                if let trailingBtns = trailingButtons {
                    HStack(spacing: 16) {
                        ForEach(trailingBtns) { button in
                            NavigationBarButtonView(button: button)
                        }
                    }
                } else {
                    Spacer().frame(width: 60) // Ensure alignment
                }
            }
            .padding(.horizontal, 20)
        }
        .frame(height: navBarHeight)
        .background(Color.white) // Add your background color
    }
}

struct NavigationBarButtonView: View {
    var button: NavigationButton

    var body: some View {
        Button(action: button.action) {
            HStack(spacing: 4) {
                if let systemImage = button.systemImageName {
                    Image(systemName: systemImage)
                } else if let imageName = button.imageName {
                    Image(imageName)
                }

                if let title = button.title {
                    Text(title)
                }
            }
            .font(.title3)
            .foregroundColor(.accentColor)
        }
    }
}

#Preview {
    let titleDetails = NavigationTitle(title: "Main title", subTitle: "Sub title")
    let leadingButton = NavigationButton(systemImageName: "chevron.left", title: "Back") {
        debugPrint("left button tap")
    }
    let trailingButton = NavigationButton(systemImageName: "chevron.right", title: "Next") {
        debugPrint("right button tap")
    }

    return CustomNavigationView(
        title: titleDetails,
        leadingButtons: [leadingButton],
        trailingButtons: [trailingButton]
    )
}
