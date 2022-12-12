//
//  HealthKitManager.swift
//  iHealth
//
//  Created by Rohit Nisal on 5/13/21.
//

import Foundation
import HealthKit

struct statsObject: Identifiable {
    let id = UUID()
    var name: String = "" // Description
    var rawValue: Double = 0.0 // For calculating with raw value
    var units: String = "" // For determining comparisons
    var position: Int = 0

    var strValue: String {
        let numFormatter = NumberFormatter()
        numFormatter.numberStyle = .decimal
        let tempRawValue = numFormatter.string(from: NSNumber(value: floor(rawValue)))
//        (String(format: "%.0f", rawValue)
        return "\(tempRawValue ?? "") \(units.capitalized)" // For displaying raw value
    }
}

struct StatsTitle: Identifiable {
    let id = UUID()
    var title: String
    var statsObject: [statsObject] = []
}

protocol StatsManagerProtocol {
    func updateTableView()
}

class StatsManager: ObservableObject {
    
    
    var delegate: StatsManagerProtocol?
    
    private enum HealthkitSetupError: Error {
      case notAvailableOnDevice
      case dataTypeNotAvailable
    }
    // 2D array for each of the unique sections
    @Published var statsArrayTitles = [StatsTitle(title:"Activity"), StatsTitle(title:"Walking / Running"), StatsTitle(title:"Swimming"), StatsTitle(title:"Wheelchair Use"), StatsTitle(title:"Cycling"), StatsTitle(title:"Downhill Sports"), StatsTitle(title:"Heart"), StatsTitle(title:"Body Measurements")]

    @Published var workouts: [HKWorkout] = []

    // Define valid units for comparison segue to be performed
    // Only have in one place to change if a value for a unit will be shown the comparison page & cell decoration
    let validUnits = ["miles", "flights", "hours"]
    
    func checkAuth(duration: Int) {
        tempStepData()
    }
    func checkAuth1(duration: Int){
        for i in 0..<statsArrayTitles.count {
            statsArrayTitles[i].statsObject = []
        }
        // Set required properties to be read from HealthKit https://developer.apple.com/documentation/healthkit/hkquantitytypeidentifier
        let healthKitTypes: Set = [ HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!,
                                    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.flightsClimbed)!,
                                    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.appleStandTime)!,
                                    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.basalEnergyBurned)!,
                                    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!,
                                    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!,
                                    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.appleExerciseTime)!,
                                    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceSwimming)!,
                                    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.swimmingStrokeCount)!,
                                    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.pushCount)!,
                                    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWheelchair)!,
                                    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceCycling)!,
                                    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceDownhillSnowSports)!,
                                    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!,
                                    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.restingHeartRate)!,
                                    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.walkingHeartRateAverage)!,
                                    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!,
                                    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!,
                                    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMassIndex)!,
                                    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.leanBodyMass)!,
                                    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyFatPercentage)!,
                                    HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.waistCircumference)!,
                                    
        ]
        
        // Request read only access to users healthkit data
        HKHealthStore().requestAuthorization(toShare: nil, read: healthKitTypes) { [weak self] (bool, error) in
            
            guard let strongSelf = self else { return }
            
            if let safeError = error {
                // This runs if an error occurs with auth
                print("ERROR: \(safeError)")
                
            } else {
                
                //TODO: Make nicer area for data modelling - new file or something
                // Activity totals
                strongSelf.fetchData(identifier: HKSampleType.quantityType(forIdentifier: .stepCount)!, unit: "count", duration: duration, completion: {(value) -> Void in
                    print("Steps \(value)")
                    strongSelf.addStatsObject(
                        category: 0,
                        position: 0,
                        name: "👟 Steps:",
                        strValue: "\(Int(value)) Steps",
                        rawValue: value,
                        units: "steps")
                })
                
                strongSelf.fetchData(identifier: HKSampleType.quantityType(forIdentifier: .flightsClimbed)!, unit: "count", duration: duration, completion: {(value) -> Void in
                    print("Flights \(value)")
                    strongSelf.addStatsObject(
                        category: 0,
                        position: 1,
                        name: "🏢 Flights of Stairs:",
                        strValue: "\(Int(value)) Flights",
                        rawValue: value,
                        units: "flights")
                })
                
                strongSelf.fetchData(identifier: HKSampleType.quantityType(forIdentifier: .appleStandTime)!, unit: "hour", duration: duration, completion: {(value) -> Void in
                    print("Time Standing \(value)")
                    strongSelf.addStatsObject(
                        category: 0,
                        position: 2,
                        name: "🧍‍♂️ Time Standing:",
                        strValue: "\(Int(value)) Hours",
                        rawValue: value,
                        units: "hours")
                })
                
                strongSelf.fetchData(identifier: HKSampleType.quantityType(forIdentifier: .basalEnergyBurned)!, unit: "energy", duration: duration, completion: {(value) -> Void in
                    print("Rest Energy Burned \(value)")
                    strongSelf.addStatsObject(
                        category: 0,
                        position: 5,
                        name: "⚡️ Rest Energy Burned:",
                        strValue: "\(Int(value)) Calories",
                        rawValue: value,
                        units: "Calories")
                })
                
                strongSelf.fetchData(identifier: HKSampleType.quantityType(forIdentifier: .activeEnergyBurned)!, unit: "energy", duration: duration, completion: {(value) -> Void in
                    print("Active Energy Burned \(value)")
                    strongSelf.addStatsObject(
                        category: 0,
                        position: 6,
                        name: "⚡️ Active Energy Burned:",
                        strValue: "\(Int(value)) Calories",
                        rawValue: value,
                        units: "Calories")
                })
                
                strongSelf.fetchData(identifier: HKSampleType.quantityType(forIdentifier: .appleExerciseTime)!, unit: "hour", duration: duration, completion: {(value) -> Void in
                    print("Hour \(value)")
                    strongSelf.addStatsObject(
                        category: 0,
                        position: 3,
                        name: "⏱ Time Exercising:",
                        strValue: "\(Int(value)) Hours",
                        rawValue: value,
                        units: "hours")
                })
                
                // Walking
                strongSelf.fetchData(identifier: HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning)!, unit: "mile", duration: duration, completion: {(value) -> Void in
                    print("Meters \(value)")
                    strongSelf.addStatsObject(
                        category: 1,
                        position: 0,
                        name: "🏃‍♀️ Distance Walk/Running:",
                        strValue: "\(Int(value)) Miles",
                        rawValue: value,
                        units: "miles")
                })
                
                //Swimming
                strongSelf.fetchData(identifier: HKSampleType.quantityType(forIdentifier: .distanceSwimming)!, unit: "miles", duration: duration, completion: {(value) -> Void in
                    print("Miles \(value)")
                    strongSelf.addStatsObject(
                        category: 2,
                        position: 0,
                        name: "🌊 Distance Swimming:",
                        strValue: "\(Int(value)) Miles",
                        rawValue: value,
                        units: "miles")
                })
                
                strongSelf.fetchData(identifier: HKSampleType.quantityType(forIdentifier: .swimmingStrokeCount)!, unit: "count", duration: duration, completion: {(value) -> Void in
                    print("Count \(value)")
                    strongSelf.addStatsObject(
                        category: 2,
                        position: 1,
                        name: "🏊‍♂️ Swimming Strokes:",
                        strValue: "\(Int(value)) Strokes",
                        rawValue: value,
                        units: "strokes")
                })
                
                // Wheel chair use
                strongSelf.fetchData(identifier: HKSampleType.quantityType(forIdentifier: .distanceWheelchair)!, unit: "miles", duration: duration, completion: {(value) -> Void in
                    print("Count \(value)")
                    strongSelf.addStatsObject(
                        category: 3,
                        position: 0,
                        name: "👨‍🦼 Distance of Wheel Chair:",
                        strValue: "\(Int(value)) Miles",
                        rawValue: value,
                        units: "miles")
                })
                
                strongSelf.fetchData(identifier: HKSampleType.quantityType(forIdentifier: .pushCount)!, unit: "count", duration: duration, completion: {(value) -> Void in
                    print("Count \(value)")
                    strongSelf.addStatsObject(
                        category: 3,
                        position: 1,
                        name: "👩‍🦽 Wheel Chair Pushes:",
                        strValue: "\(Int(value)) Pushes",
                        rawValue: value,
                        units: "pushes")
                })
                
                strongSelf.fetchData(identifier: HKSampleType.quantityType(forIdentifier: .distanceCycling)!, unit: "miles", duration: duration, completion: {(value) -> Void in
                    print("Count \(value)")
                    strongSelf.addStatsObject(
                        category: 4,
                        position: 0,
                        name: "🚴‍♀️ Distance Cycling:",
                        strValue: "\(Int(value)) Miles",
                        rawValue: value,
                        units: "miles")
                })
                
                strongSelf.fetchData(identifier: HKSampleType.quantityType(forIdentifier: .distanceDownhillSnowSports)!, unit: "miles", duration: duration, completion: {(value) -> Void in
                    print("Count \(value)")
                    strongSelf.addStatsObject(
                        category: 5,
                        position: 0,
                        name: "⛷ Distance doing Snow Sports:",
                        strValue: "\(Int(value)) Miles",
                        rawValue: value,
                        units: "miles")
                })
                strongSelf.fetchData(identifier: HKSampleType.quantityType(forIdentifier: .heartRate)!, unit: "BPM", duration: duration, completion: {(value) -> Void in
                    print("BPM \(value)")
                    strongSelf.addStatsObject(
                        category: 6,
                        position: 0,
                        name: "❤️ Heart Rate:",
                        strValue: "\(Int(value)) BPM",
                        rawValue: value,
                        units: "BPM")
                })
                strongSelf.fetchData(identifier: HKSampleType.quantityType(forIdentifier: .restingHeartRate)!, unit: "BPM", duration: duration, completion: {(value) -> Void in
                    print("BPM \(value)")
                    strongSelf.addStatsObject(
                        category: 6,
                        position: 1,
                        name: "❤️ Resting Heart Rate:",
                        strValue: "\(Int(value)) BPM",
                        rawValue: value,
                        units: "BPM")
                })
                strongSelf.fetchData(identifier: HKSampleType.quantityType(forIdentifier: .walkingHeartRateAverage)!, unit: "BPM", duration: duration, completion: {(value) -> Void in
                    print("BPM \(value)")
                    strongSelf.addStatsObject(
                        category: 6,
                        position: 2,
                        name: "❤️ Walking Heart Rate Average:",
                        strValue: "\(Int(value)) BPM",
                        rawValue: value,
                        units: "BPM")
                })
                
            
                strongSelf.getMostRecentSample(for: HKSampleType.quantityType(forIdentifier: .height)!, unit: "height", completion: {(value) -> Void in
                    print("body \(value)")
                    strongSelf.addStatsObject(
                        category: 7,
                        position: 0,
                        name: "🤾‍♂️ Height:",
                        strValue: "\(Int(value))",
                        rawValue: value,
                        units: "height")
                })
                
                /*strongSelf.getMostRecentSample(for: HKSampleType.quantityType(forIdentifier: .bodyMass)!, unit: "bodyMass", completion: {(value) -> Void in
                    print("bodyMass \(value)")
                    strongSelf.addStatsObject(
                        category: 7,
                        position: 1,
                        name: "🤾‍♂️ Body Mass:",
                        strValue: "\(Int(value))",
                        rawValue: value,
                        units: "bodyMass")
                })
                
                strongSelf.getMostRecentSample(for: HKSampleType.quantityType(forIdentifier: .bodyMassIndex)!, unit: "bodyMassIndex", completion: {(value) -> Void in
                    print("bodyMassIndex \(value)")
                    strongSelf.addStatsObject(
                        category: 7,
                        position: 2,
                        name: "🤾‍♂️ Body Mass Index:",
                        strValue: "\(Int(value))",
                        rawValue: value,
                        units: "bodyMassIndex")
                })
                
                strongSelf.getMostRecentSample(for: HKSampleType.quantityType(forIdentifier: .leanBodyMass)!, unit: "leanBodyMass", completion: {(value) -> Void in
                    print("body \(value)")
                    strongSelf.addStatsObject(
                        category: 7,
                        position: 3,
                        name: "🤾‍♂️ Lean Body Mass:",
                        strValue: "\(Int(value))",
                        rawValue: value,
                        units: "leanBodyMass")
                })
                
                
                strongSelf.getMostRecentSample(for: HKSampleType.quantityType(forIdentifier: .bodyFatPercentage)!, unit: "bodyFatPercentage", completion: {(value) -> Void in
                    print("bodyFatPercentage \(value)")
                    strongSelf.addStatsObject(
                        category: 7,
                        position: 4,
                        name: "🤾‍♂️ Body Fat Percentage:",
                        strValue: "\(Int(value))",
                        rawValue: value,
                        units: "bodyFatPercentage")
                })
                
                strongSelf.fetchData(identifier: HKSampleType.quantityType(forIdentifier: .waistCircumference)!, unit: "body", duration: duration, completion: {(value) -> Void in
                    print("body \(value)")
                    strongSelf.addStatsObject(
                        category: 7,
                        position: 5,
                        name: "❤️ Waist Circumference:",
                        strValue: "\(Int(value)) body",
                        rawValue: value,
                        units: "body")
                })*/
            }
        }
    }
    
    func authorizeHealthKitWorkout(completion: @escaping (Bool, Error?) -> Swift.Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, HealthkitSetupError.notAvailableOnDevice)
            return
        }
        let healthKitTypesToRead: Set<HKObjectType> = [HKObjectType.workoutType()]
        
        HKHealthStore().requestAuthorization(toShare: nil,
                                             read: healthKitTypesToRead) { (success, error) in
            completion(success, error)
        }
    }
    /*
     Add statsobject to array and sort the array based on position variable
     */
    func addStatsObject(category: Int, position: Int, name: String, strValue: String, rawValue: Double, units: String) {
        //TODO: Add error handling and text formatting here
        var newStatsObject = statsObject()
        newStatsObject.name = name
        //newStatsObject.strValue = strValue
        newStatsObject.rawValue = rawValue
        newStatsObject.units = units
        newStatsObject.position = position
        
        var newStatsArray = statsArrayTitles[category].statsObject
        newStatsArray.append(newStatsObject)
        
        DispatchQueue.main.async { [weak self] in
            self?.statsArrayTitles[category].statsObject = newStatsArray.sorted(by: {$0.position < $1.position})
        }

        delegate?.updateTableView()
    }
    
    func tempStepData() {
        
        guard HKHealthStore.isHealthDataAvailable() else {
            return
        }
        let healthKitTypesToRead: Set<HKObjectType> = [HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.appleExerciseTime)!]
        
        HKHealthStore().requestAuthorization(toShare: nil,
                                             read: healthKitTypesToRead) { (success, error) in
            
            
            if success {
                
                print("Start time: \(Date())")
                guard let stepCountType = HKObjectType.quantityType(forIdentifier: .appleExerciseTime) else {
                    fatalError("*** Unable to get the step count type ***")
                }
                
                var interval = DateComponents()
                interval.hour = 1
                
                //let date = NSDate()
                //let cal = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
                //let newDate = cal.startOfDay(for: date as Date)
                //let predicate = HKQuery.predicateForSamples(withStart: newDate, end: NSDate() as Date, options: []) //
                
                var calendar = Calendar.current
                calendar.timeZone = .current
                //let anchorDate = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: Date())
                
                var anchorComponents = calendar.dateComponents([.day, .month, .year], from: NSDate() as Date)
                anchorComponents.hour = 0
                let anchorDate = calendar.date(from: anchorComponents)
                
                let localDateFormatter = DateFormatter()
                localDateFormatter.dateStyle = .medium
                localDateFormatter.timeStyle = .medium
                localDateFormatter.timeZone = .current
                
                let query = HKStatisticsCollectionQuery.init(quantityType: stepCountType,
                                                             quantitySamplePredicate: nil,
                                                             options: .cumulativeSum,
                                                             anchorDate: anchorDate!,
                                                             intervalComponents: interval)
                
                query.initialResultsHandler = {
                    query, results, error in
                    
                    print("End time: \(Date())")
                    let startDate = calendar.startOfDay(for: Date())
                    var endOfDay: Date {
                        var components = DateComponents()
                        components.day = 1
                        components.second = -1
                        return calendar.date(byAdding: components, to: startDate)!
                    }
                    
                    results?.enumerateStatistics(from: startDate,
                                                 to: endOfDay, with: { (result, stop) in
                                                    let dateString = localDateFormatter.string(from: result.startDate)
                                                    print("Time: \(localDateFormatter.date(from: dateString)), \(result.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0)")
                                                 })
                }
                HKHealthStore().execute(query)
            }
        }
        
        /*let type = HKSampleType.quantityType(forIdentifier: .stepCount) // The type of data we are requesting

        let date = NSDate()
        let cal = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let newDate = cal.startOfDay(for: date as Date)
        let predicate = HKQuery.predicateForSamples(withStart: newDate, end: NSDate() as Date, options: []) // Our search predicate which will fetch all steps taken today

                // The actual HealthKit Query which will fetch all of the steps and add them up for us.
                let query = HKSampleQuery(sampleType: type!, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { query, results, error in
                    var steps: Double = 0

                    if results?.count ?? 0 > 0
                    {
                        for result in results as! [HKQuantitySample]
                        {
                            steps += result.quantity.doubleValue(for: HKUnit.count())
                        }
                    }
                }

        HKHealthStore().execute(query)*/
    }
    /*
     fetchData - fetch data from healthkit
     =====================================
     identifier: property to fetch
     unit: measuring unit to return result in
     duration: over what time period (0 is all time, rest is number of days to include)
     completion: run completed code when done
     */
    func fetchData(identifier: HKQuantityType, unit: String, duration: Int, completion: @escaping (_ value:Double) -> ()){
        let calendar = NSCalendar.current
        let interval = NSDateComponents()
        interval.day = 1
        
        var anchorComponents = calendar.dateComponents([.day, .month, .year], from: NSDate() as Date)
        anchorComponents.hour = 0
        let anchorDate = calendar.date(from: anchorComponents)
        
        // Define 1-day intervals starting from 0:00
        
        var options: HKStatisticsOptions = .cumulativeSum
        switch unit {
        case "BPM", "body":
            options = [.discreteAverage]
        default:
            options = [.cumulativeSum]
        }
        
        let stepsQuery = HKStatisticsCollectionQuery(quantityType: identifier, quantitySamplePredicate: nil, options: options, anchorDate: anchorDate!, intervalComponents: interval as DateComponents)
        
        // Set the results handler
        stepsQuery.initialResultsHandler = {query, results, error in
            let endDate = NSDate()
            
            var startDate  = Date()
            
            if(duration == 0) {
                startDate = Date(timeIntervalSince1970: 0)
            } else {
                startDate = Date().addingTimeInterval(TimeInterval(-3600 * 24 * duration))
            }
            
            var total = 0.0
            
            if let myResults = results{
                myResults.enumerateStatistics(from: startDate, to: endDate as Date) { statistics, stop in
                    if let quantity = unit == "BPM" || unit == "body" ? statistics.averageQuantity() : statistics.sumQuantity() {
                        //print(statistics)
                        var value: Double = 0
                        
                        switch(unit) {
                        case "count":
                            value = quantity.doubleValue(for: HKUnit.count())
                            break
                        case "hour":
                            value = quantity.doubleValue(for: HKUnit.hour())
                            break
                        case "meter":
                            value = quantity.doubleValue(for: HKUnit.meter())
                            break
                        case "mile":
                            value = quantity.doubleValue(for: HKUnit.mile())
                            break
                        case "energy":
                            value = quantity.doubleValue(for: HKUnit.largeCalorie())
                            break
                        case "BPM":
                            value = quantity.doubleValue(for: HKUnit(from: "count/min"))
                            break
                        default:
                            print("Error unit not specified")
                            fatalError("Unit not specified")
                        }
                        
                        total += value
                        // Get date for each day if required
                       // let date = statistics.endDate
                        //print("\(date): value = \(value)")
                    }
                } //end block
                DispatchQueue.main.async {
                    completion(total)
                }// return after loop has ran
            } //end if let
        }
        HKHealthStore().execute(stepsQuery)
    }
    
    func getMostRecentSample(for sampleType: HKSampleType, unit: String,
                             completion: @escaping (_ value:Double) -> ()) {
      
      //1. Use HKQuery to load the most recent samples.
      let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast,
                                                            end: Date(),
                                                            options: .strictEndDate)
      
      let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate,
                                            ascending: false)
      
      let limit = 1
      
      let sampleQuery = HKSampleQuery(sampleType: sampleType,
                                      predicate: mostRecentPredicate,
                                      limit: limit,
                                      sortDescriptors: [sortDescriptor]) { (query, samples, error) in
      
        //2. Always dispatch to the main thread when complete.
        DispatchQueue.main.async {
          
          guard let samples = samples,
                let mostRecentSample = samples.first as? HKQuantitySample else {
                return
          }
            switch unit {
            case "height":
                let heightInMeters = mostRecentSample.quantity.doubleValue(for: HKUnit.meter())
                completion(heightInMeters)
            case "weight":
                let weightInKilograms = mostRecentSample.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
                completion(weightInKilograms)
            case "bodyMass", "bodyMassIndex", "leanBodyMass", "bodyFatPercentage":
                let bodyMassQuantity = mostRecentSample.quantity.doubleValue(for: HKUnit.count())
                completion(bodyMassQuantity)
            default:
                print("default")
            }
        }
      }
      
        HKHealthStore().execute(sampleQuery)
    }
    
    func loadWorkoutsStats(duration: Int){
      
      let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate,
                                            ascending: false)
      
        
        var startDate  = Date()
        
        if(duration == 0) {
            startDate = Date(timeIntervalSince1970: 0)
        } else {
            startDate = Date().addingTimeInterval(TimeInterval(-3600 * 24 * duration))
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: HKQueryOptions.strictEndDate)
        
      let query = HKSampleQuery(sampleType: HKObjectType.workoutType(),
                                predicate: predicate,
                                limit: 0,
                                sortDescriptors: [sortDescriptor]) { [weak self] (query, samples, error) in
         
        DispatchQueue.main.async {
          
          //4. Cast the samples as HKWorkout
          guard let samples = samples as? [HKWorkout],
            error == nil else {
              //completion(nil, error)
              return
          }
            self?.workouts = samples
        }
      }
        HKHealthStore().execute(query)
    }
}
