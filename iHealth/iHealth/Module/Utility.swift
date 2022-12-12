//
//  Utility.swift
//  iHealth
//
//  Created by Rohit Nisal on 5/22/21.
//

import Foundation

extension TimeInterval{

        func stringFromTimeInterval() -> String {

            let time = NSInteger(self)

            //let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
            let seconds = time % 60
            let minutes = (time / 60) % 60
            let hours = (time / 3600)

            return String(format: "%0.2dh : %0.2dm : %0.2ds",hours,minutes,seconds)

        }
    }
