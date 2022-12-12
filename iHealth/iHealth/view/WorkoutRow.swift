//
//  WorkoutRow.swift
//  iHealth
//
//  Created by Rohit Nisal on 5/23/21.
//

import SwiftUI
import HealthKit

struct WorkoutRow: View {
    var workout: HKWorkout
    
    var body: some View {
        VStack(alignment: .leading){
            Group {
                Text("🏋️‍♀️ Workout Type: \(workout.workoutActivityType.name)")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.green)
                Spacer()
                Text("🗓 Start Date: \(workout.getStartDate())")
                    .foregroundColor(.yellow)
                Spacer()
                Text("🗓 End Date: \(workout.getEndDate())")
                    .foregroundColor(.yellow)
                Spacer()
                Text("🔥 Calories Burned: \(workout.caloriesBurned())")
                    .foregroundColor(.red)
                Spacer()
                Text("⏱ Duration: \(workout.getWorkoutDuration())")
                    .foregroundColor(.blue)
                Spacer()
            }
            Group {
                Spacer()
                Text("ℹ️ Source Name: \(workout.getWorkoutSourceName())")
                    .foregroundColor(.orange)
                Spacer()
                Text("🆔 UDID: \(workout.getWorkoutUIID())")
                    .foregroundColor(.purple)
                Divider()
                    .background(Color.gray)
                    .frame(height: 5)
                    
            }
            
        }
    }
}

/*struct WorkoutRow_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutRow()
    }
}*/
