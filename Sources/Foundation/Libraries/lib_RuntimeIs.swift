/*--------------------------------------------------------------------------------------------------------------------------
    File: lib_RuntimeIs.swift
  Author: Kevin Messina
 Created: 7/1/23
Modified:
 
©2023-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import Foundation

// MARK: - *** DEVICE RUNTIME_IS CONSTANTS ***
struct runtimeIs {
    var Debug:Bool {
#if DEBUG
        return true
#else
        return false
#endif
    }
    
    var Release:Bool {
#if DEBUG
        return false
#else
        return true
#endif
    }
    
    enum runtimeTypeEnum:String {
        case Debug = "Test/Develop"
        case Release = "App Store"
        case Unspecified = "Unspecified"
    }
    
    /// Evaluates the current runtime mode of the app.
    /// - Returns: enum value for runtimeTypeEnum. Use .rawValue to get string description.
    func runtimeType() -> runtimeTypeEnum {
        if runtimeIs().Debug { return .Debug }
        else if runtimeIs().Release { return .Release }
        else { return .Unspecified }
    }
}






