//
//  ContentView.swift
//  TextViewMoreModifier
//
//  Created by Rohit Nisal on 5/9/21.
//

import SwiftUI

struct ContentView: View {
    @State private var amount: CGFloat = 50

    var body: some View {
        VStack {
            Text("The two modifiers are tracking() and kerning(): both add spacing between letters, but tracking will pull apart ligatures whereas kerning will not, and kerning will leave some trailing whitespace whereas tracking will not.")
                .font(.custom("AmericanTypewriter", size: 15))
                .kerning(amount)
                .textCase(/*@START_MENU_TOKEN@*/.uppercase/*@END_MENU_TOKEN@*/)
            Spacer()
            Text("The two modifiers are tracking() and kerning(): both add spacing between letters, but tracking will pull apart ligatures whereas kerning will not, and kerning will leave some trailing whitespace whereas tracking will not.")
                .font(.custom("AmericanTypewriter", size: 15))
                .tracking(amount)
            Label {
                Text("Rohit Nisal")
                    .foregroundColor(.primary)
                    .font(.largeTitle)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .clipShape(Capsule())
            } icon: {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blue)
                    .frame(width: 64, height: 64)
            }


            Slider(value: $amount, in: 0...100) {
                Text("Adjust the amount of spacing")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
