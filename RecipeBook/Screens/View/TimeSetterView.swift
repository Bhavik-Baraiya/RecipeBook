//
//  TimeSetterView.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 12/04/25.
//

import SwiftUI

struct TimeSetterView: View {
    
    @Binding var selectedHour:Int
    @Binding var selectedMinutes:Int
    
    let hours =  Array(0...24)
    let minutes =  Array(0...59)
    
    var body: some View {
    
        VStack(alignment: .leading, spacing: 10) {
            Text("Preparation time")
                .font(.headline)
            
            HStack(spacing: 10) {
                Picker(selection: $selectedHour, label: Text("Hour")) {
                    ForEach(hours, id: \.self) { hour in
                        Text("\(hour) H").tag(hour)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 100, height: 150)
                .clipped()
                Picker(selection: $selectedMinutes, label: Text("Minutes")) {
                    ForEach(minutes, id: \.self) { minute in
                        Text("\(minute) m").tag(minute)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 100, height: 150)
                .clipped()
            }
            
            Text("Selected Time: \(selectedHour)h \(selectedMinutes)m")
                .font(.subheadline)
                .foregroundColor(.gray)
        }.padding()
        
    }
}

#Preview {
    //TimeSetterView()
}
