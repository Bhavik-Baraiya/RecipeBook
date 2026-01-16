//
//  ChatViewModel.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 16/01/26.
//


import SwiftUI

@Observable
class ChatViewModel {
    
    var messages: [ChatMessage] = []
    var userInput: String = ""
    var isResponding = false
    
   
    init() {
        
    }

    func sendMessage() {
       
    }
    
    func reset() {
        messages = []
        userInput = ""
        isResponding = false
    }
}
