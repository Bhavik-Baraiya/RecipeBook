//
//  AboutView.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 11/06/25.
//

import SwiftUI

struct AboutView: View {
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                VStack(alignment:.leading, spacing: 35.0) {
                    
                    VStack(alignment:.leading,spacing: 10){
                        Image("app-icon")
                            .resizable()
                            .frame(width: 100,height: 100)
                            .offset(x:-14)
                        Text("RecipeBook")
                            .font(.title)
                            .fontWeight(.bold)
                        Text("Discover, Cook, Share – Your Personal Recipe Companion")
                            .font(.headline)
                    }//Header
                    
                    aboutBodyView(headingText: "About app", descriptionText: "RecipeBook is your ultimate kitchen companion – whether you’re a beginner or a seasoned chef. Save your favorite recipes, explore new dishes, and create your own personalized cookbook, all in one place.")
                    
                    aboutBodyView(headingText: "Key Features", descriptionText: "🧑‍🍳 Save and organize your own recipes\n\n🔍 Search by ingredients or dish name\n\n❤️ Mark and share your favorite recipes\n\n🌐 Offline access anytime, anywhere\n\n📸 Add photos and notes to your recipes")
                    
                    aboutBodyView(headingText: "Version", descriptionText: "RecipeBook v1.0.0")
                    
                    VStack(alignment:.leading,spacing: 20){
                        Text("Contact & Support")
                            .font(.title)
                            .fontWeight(.bold)
                        Text("Have feedback or need help?")
                            .font(.headline)
                        
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
        VStack(alignment:.leading,spacing: 10){
            Text(headingText)
                .font(.title2)
                .fontWeight(.bold)
            Text(descriptionText)
                .font(.callout)
        }
    }
    
}

#Preview {
    AboutView()
}
