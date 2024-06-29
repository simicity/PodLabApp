//
//  DoubleExtension.swift
//  PodsLab
//
//  Created by Miho Shimizu on 6/16/24.
//

import Foundation

extension Double {
    
    func asDurationString() -> String {
        let hours: Int = Int(self / 3600)
        let minutes: Int = Int(self.truncatingRemainder(dividingBy: 3600) / 60)
        let seconds: Int = Int(self.truncatingRemainder(dividingBy: 60))
        return hours > 0 ? String(format: "%d:%02d:%02d", hours, minutes, seconds) : String(format: "%02d:%02d", minutes, seconds)
    }

}
