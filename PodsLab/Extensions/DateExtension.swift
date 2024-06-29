//
//  DateExtension.swift
//  PodsLab
//
//  Created by Miho Shimizu on 5/24/24.
//

import Foundation

extension Date {
 
    private var shortFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    func asShortDateString() -> String {
        return shortFormatter.string(from: self)
    }
}
