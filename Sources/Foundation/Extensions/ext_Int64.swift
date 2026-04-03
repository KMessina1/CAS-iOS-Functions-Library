//--------------------------------------------------------------------------------------------------------------------------
//     File: ext_Int64.swift
//   Author: Kevin Messina
//  Created: 12/3/25
// Modified:
// 
// ©2025 Creative App Solutions, LLC. - All Rights Reserved.
//--------------------------------------------------------------------------------------------------------------------------
// NOTES:
//--------------------------------------------------------------------------------------------------------------------------

import Foundation

extension Int64 {
    var isInvalidDbId: Bool { (self == -1) ?true :false }
    
    var isValidDbId: Bool { (self != -1) ?true :false }
    
    var orInvalidDbId: Int64 { (self > 0) ? self : -1 }
    
    var asString: String { "\(self)" }
    
    var dashesIfInvalidDbId: String { (self == 0) ?dashesTxt :"\(self)" }
}

