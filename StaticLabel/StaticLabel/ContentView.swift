//
//  ContentView.swift
//  StaticLabel
//
//  Created by Rohit Nisal on 5/8/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
        Text("Inside the preview window for your content view you’re likely to see “Automatic preview updating paused” – go ahead and press Resume to have Swift start building your code and show you a live preview of how it looks.")
            .padding()
            .lineLimit(1)
            .truncationMode(.tail)
        Text("Inside the preview window for your content view you’re likely to see “Automatic preview updating paused” – go ahead and press Resume to have Swift start building your code and show you a live preview of how it looks.")
            .padding()
            .lineLimit(nil)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
