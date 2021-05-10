//
//  ContentView.swift
//  FormatTextView
//
//  Created by Rohit Nisal on 5/9/21.
//

import SwiftUI

struct ContentView: View {
    
    let dueDate = Date()
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    var body: some View {
        Text("Task due date: \(dueDate, formatter: Self.taskDateFormat)")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
