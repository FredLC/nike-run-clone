//
//  Extensions.swift
//  NikeRunClone
//
//  Created by Fred Lefevre on 2019-05-25.
//  Copyright © 2019 Fred Lefevre. All rights reserved.
//

import Foundation

extension Double {
    func convertMetersToMiles(places: Int) -> Double {
        let divider = pow(10.0, Double(places))
        return ((self / 1609.34) * divider).rounded() / divider
    }
}

extension Int {
    func formatTimeDurationToString() -> String {
        let durationHours = self / 3600
        let durationMinutes = (self % 3600) / 60
        let durationSeconds = (self % 3600) % 60
        
        if durationHours < 0 {
            return "00:00:00"
        } else if durationHours == 0 {
            return String(format: "%02d:%02d", durationMinutes, durationSeconds)
        } else {
            return String(format: "%02d:%02d:%02d", durationHours, durationMinutes, durationSeconds)
        }
    }
}
