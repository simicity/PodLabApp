//
//  IntExtension.swift
//  PodsLab
//
//  Created by Miho Shimizu on 5/24/24.
//

import Foundation

extension Int {
    
    func asDurationString() -> String {
        let hours: Int = self / 3600
        let minutes: Int = (self % 3600) / 60
        let seconds: Int = (self % 60)
        return hours > 0 ? String(format: "%d:%02d:%02d", hours, minutes, seconds) : String(format: "%02d:%02d", minutes, seconds)
    }
    
    func asDate() -> Date {
        return Date(timeIntervalSince1970: Double(self))
    }
    
    func asPublishedDateString() -> String {
        let date = self.asDate()
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "Today"
        }
        return date.asShortDateString()
    }
}
