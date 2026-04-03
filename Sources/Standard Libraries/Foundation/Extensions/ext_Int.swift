/*--------------------------------------------------------------------------------------------------------------------------
    File: ext_Int.swift
  Author: Kevin Messina
 Created: 6/2/24
Modified:
 
©2024-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import Foundation

extension Int {
    var boolValue: Bool { (self == 1) ?true :false }
    var isZero: Bool { (self == 0) ?true :false }
    var dbValue: Int64 { Int64(self) }
    var dashesIfZero: String { (self == 0) ?dashesTxt :"\(self)" }
    
    func asNum(negPrefix:String?="-",negSuffix:String?="") -> String {
        let formatter:NumberFormatter! = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = Locale.current.groupingSeparator ?? ","
        formatter.maximumFractionDigits = 0
        formatter.negativePrefix = negPrefix!
        formatter.negativeSuffix = negSuffix!
        
        return formatter.string(from: NSNumber(value: self)) ?? "n/a"
    }
    
    func roundUpToNearest(multipleOf m: Int) -> Int {
        let doubleValue = Double(self)
        let multiple: Double = Double(m)
        let roundedUpValue = ceil(doubleValue / multiple) * multiple
        return Int(roundedUpValue)
    }
    func roundedToNearest(multipleOf m: Int) -> Int {
        let doubleValue = Double(self)
        let doubleMultiple = Double(m)
        let roundedValue = (doubleValue / doubleMultiple).rounded() * doubleMultiple
        return Int(roundedValue)
    }
}

