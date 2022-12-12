//
//  ContentView.swift
//  iHealth
//
//  Created by Rohit Nisal on 5/13/21.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var statsManager = StatsManager()
    @State var showingSheet: Bool = false
    @State var duration: Int = 0
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Workout")) {
                    NavigationLink(destination: WorkoutView(duration: duration)) {
                        Text("Workout Stats")
                    }
                }
                ForEach(self.statsManager.statsArrayTitles, id: \.id) { statSection in
                    Section(header: Text(statSection.title)) {
                        ForEach(statSection.statsObject, id: \.id) { statObj in
                            HealthDataRow(stat: statObj)
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Health Stats"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.showingSheet = true
                    }, label: {
                        Image(systemName: "calendar")
                    })
                }
            }
        }
        
        .onAppear(perform: fetch)
        .actionSheet(isPresented: $showingSheet) {
            ActionSheet(
                title: Text("Change Selected Time"),
                message: Text("Change the selected time period for the stats..."),
                buttons: [
                    .default(Text("1 Day Stats"), action: {
                        self.fetch(duration: 1)
                        self.duration = 1
                    }),
                    .default(Text("1 Week Stats"), action: {
                        self.fetch(duration: 7)
                        self.duration = 7
                    }),
                    .default(Text("1 Month Stats"), action: {
                        self.fetch(duration: 30)
                        self.duration = 30
                    }),
                    .default(Text("1 Year Selected"), action: {
                        self.fetch(duration: 365)
                        self.duration = 365
                    }),
                    .default(Text("All Time Stats"), action: {
                        self.fetch(duration: 0)
                        self.duration = 0
                    }),
                    .destructive(Text("Cancel"), action: {
                    })
                ]
            )
        }
    }
    private func fetch() {
        statsManager.checkAuth(duration: 1)
    }
    private func fetch(duration: Int) {
        statsManager.checkAuth(duration: duration)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
