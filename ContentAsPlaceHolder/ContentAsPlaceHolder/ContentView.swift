//
//  ContentView.swift
//  ContentAsPlaceHolder
//
//  Created by Rohit Nisal on 5/9/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("This is placeholder text")
            Text("And so is this")
        }
        .font(.title)
        .redacted(reason: .placeholder)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
