//--------------------------------------------------------------------------------------------------------------------------
//     File: ext_Optional.swift
//   Author: Kevin Messina
//  Created: 12/5/25
// Modified:
// 
// ©2025 Creative App Solutions, LLC. - All Rights Reserved.
//--------------------------------------------------------------------------------------------------------------------------
// NOTES:
//--------------------------------------------------------------------------------------------------------------------------

import Foundation

extension Optional where Wrapped == String {
    /// Returns the wrapped Int64 value if it exists, otherwise 0.
    var orInvalidDbId: Int64 {
        return Int64(self ?? "-1") ?? -1
    }
}

extension Optional where Wrapped == Int64 {
    /// Returns the wrapped Int64 value if it exists, otherwise -1.
    var orInvalidDbId: Int64 {
        return self ?? -1
    }
    
    /// Returns true if wrapped Int64 value exists (not nil) or is not -1 (dn.ID.none).
    var isValidDbId: Bool {
        return (self != nil && self != -1)
    }
    
    /// Returns true if wrapped Int64 value doesn't exist (== nil) or == -1 (dn.ID.none).
    var isInvalidDbId: Bool {
        return !isValidDbId
    }
}

