//
//  AboutView.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 11/06/25.
//

import SwiftUI

struct AboutView: View {
    
    @AppStorage(darkModeSupport) var isDarkModeEnabled:Bool = false
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                VStack(alignment:.leading, spacing: 35.0) {
                    
                    VStack(alignment:.leading,spacing: 10){
                        Image("app-icon")
                            .resizable()
                            .frame(width: 100,height: 100)
                            .offset(x:-14)
                            .shadow(
                                color: isDarkModeEnabled ? Color("BackgroundTransparentDark") : Color("BackgroundTransparentLight"),
                                    radius: 3,
                                    x: 1,
                                    y: 1)
                        Text("RecipeBook")
                            .font(.title)
                            .fontWeight(.bold)
                        Text("Discover, Cook, Share – Your Personal Recipe Companion")
                            .font(.headline)
                    }//Header
                    
                    aboutBodyView(headingText: "About app", descriptionText: "RecipeBook is your ultimate kitchen companion – whether you’re a beginner or a seasoned chef. Save your favorite recipes, explore new dishes, and create your own personalized cookbook, all in one place.")
                    
                    aboutBodyView(headingText: "Key Features", descriptionText: "🧑‍🍳 Save and organize your own recipes\n❤️ Mark and share your favorite recipes\n🌐 Offline access anytime, anywhere\n📸 Add photos and notes to your recipes")
                        .lineSpacing(20)
                    
                    aboutBodyView(headingText: "Version", descriptionText: "RecipeBook v1.0.0")
                    
                    VStack(alignment:.leading,spacing: 20){
                        Text("Contact & Support")
                            .bodyTitleStyle()
                        Text("Have feedback or need help?")
                            .font(.subheadline)
                        
                        VStack(alignment:.leading) {
                            HStack {
                                Text("📧 Email us at:")
                                Link("support@recipebook.app", destination: URL(string: "support@recipebook.app")!)
                            }
                            HStack {
                                Text("🔗 Visit:")
                                Link("www.recipebook.app", destination: URL(string: "www.recipebook.app")!)
                            }
                        }
                        .font(.footnote)
                    }//Footer
                }
                .padding()
            }
        }
        .background(
            Color(.systemGray6)
        )
        .navigationTitle("About")
        .toolbarTitleDisplayMode(.inline)
    }
    
   
    func aboutBodyView(headingText:String, descriptionText:String) -> some View{
        VStack(alignment:.leading,spacing: 20){
            Text(headingText)
                .bodyTitleStyle()
            Text(descriptionText)
                .bodyTextStyle()
        }
    }
    
}

#Preview {
    AboutView()
}
