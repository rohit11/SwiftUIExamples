//
//  ContentView.swift
//  StyleTextView
//
//  Created by Rohit Nisal on 5/9/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
        Text("Headline Text")
               .padding()
               .font(.headline)
        Text("By default a Text view has a “Body” Dynamic Type style, but you can select from other sizes and weights by calling .font() on it like this:")
            .padding()
            .font(.largeTitle)
            .foregroundColor(.white)
            .background(Color.black)
            .lineSpacing(15)
            .multilineTextAlignment(.center)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
