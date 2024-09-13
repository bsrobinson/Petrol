//
//  DateExtensions.swift
//  Petrol
//
//  Created by Ben Robinson on 10/09/2024.
//

import Foundation

extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from: self)
    }
    
    func trim() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func fuelTypeLabel(withCode: Bool = true) -> String {
        var label = ""
        if (self == "E10") { label = "Petrol" }
        if (self == "E5") { label = "Super Petrol" }
        if (self == "B7") { label = "Diesel" }
        if (self == "SDV") { label = "Super Diesel" }
        if label != "" {
            return "\(label)\(withCode ? " (\(self))" : "")"
        }
        return self
    }
}
