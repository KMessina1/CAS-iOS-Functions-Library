//--------------------------------------------------------------------------------------------------------------------------
//     File: ext_Bool.swift
//   Author: Kevin Messina
//  Created: 2/9/21
// Modified:
// 
// ©2021-2026 Creative App Solutions, LLC. - All Rights Reserved.
//--------------------------------------------------------------------------------------------------------------------------
// NOTES:
//--------------------------------------------------------------------------------------------------------------------------

import Foundation

extension Bool {
    mutating func negate() { self = false }
    
    var intValue:Int { Int(truncating: self as NSNumber) }
    
    var stringValue:String { self == true  ? "True" : "False" }
    
    var asYesNo:String { self == true  ? "Yes" : "No" }
   
    var asTrueFalse:String { self == true  ? "True" : "False" }

    init(_ number: Int) { self.init(truncating: number as NSNumber) }
}

