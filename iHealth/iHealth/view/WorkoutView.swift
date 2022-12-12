//
//  WorkoutView.swift
//  iHealth
//
//  Created by Rohit Nisal on 5/22/21.
//

import SwiftUI

struct WorkoutView: View {
    @ObservedObject var statsManager = StatsManager()
    var duration: Int
    var body: some View {
        NavigationView {
            List {
                ForEach(statsManager.workouts, id: \.self) { workout in
                    WorkoutRow(workout: workout)
                }
            }
        }
        .onAppear(perform: authorizeData)
        .navigationTitle("Workout Stats")
    }
    
    
    
    func authorizeData() {
        statsManager.authorizeHealthKitWorkout { (authorized, error) in
            guard authorized else {
              let baseMessage = "HealthKit Authorization Failed"
              if let error = error {
                print("\(baseMessage). Reason: \(error.localizedDescription)")
              } else {
                print(baseMessage)
              }
              return
            }
            getWorkoutData()
        }
    }
    
    func getWorkoutData() {
        statsManager.loadWorkoutsStats(duration: duration)
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView(duration: 30)
    }
}
