/*--------------------------------------------------------------------------------------------------------------------------
    File: AgeVerification.swift
  Author: Kevin Messina
 Created: 11/25/2025
Modified:
 
©2024-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import SwiftUI
import DeclaredAgeRange

public func requestAgeRangeHelper() async -> Bool {
    if deviceIs.CanvasPreview || deviceIs.Sim {
        print("AGE VERIFICATION: Bypassed while running on CanvasPreview or Sim.")
        return true
    }
    
    // Check if the age range has already been stored
    if let storedLowerBound = userAgeRangeLowerBound {
        let isSufficient = (storedLowerBound >= 16)

        print("AGE VERIFICATION: Accessing stored value: \(isSufficient ?"Age IS Sufficient" :"Age IS NOT Sufficient")")
        return isSufficient // No need to make a new request
    }
    
    do {
        let ageRangeResponse = try await requestAgeRange(ageGates: 16)

        switch ageRangeResponse {
            case let .sharing(range):
                if let lowerBound = range.lowerBound {
                    // Store the lower bound for future use
                    userAgeRangeLowerBound = lowerBound

                    let isSufficient = (lowerBound >= 16)
                    
                    if isSufficient {
                        print("AGE VERIFICATION: User's age range IS sufficient for advanced features.")
                        activeAlert = .ageValidationPassed
                    } else {
                        print("AGE VERIFICATION: User's age range is NOT sufficient for advanced features.")
                        activeAlert = .ageValidationFailed
                    }
                    
                    return isSufficient
                }else{
                    activeAlert = .ageValidationError
                    print("AGE VERIFICATION: An unexpected error occurred trying to obtain lower bound of age range.")
                    return false
                }
            case .declinedSharing:
                print("AGE VERIFICATION: Age range sharing declined.")
                activeAlert = .ageValidationDeclined
                return false
            @unknown default:
                return false
        }
    } catch DeclaredAgeRange.AgeRangeService.Error.invalidRequest {
        print("AGE VERIFICATION: Invalid age range request.")
        activeAlert = .ageValidationInvalid
        return false
    } catch DeclaredAgeRange.AgeRangeService.Error.notAvailable {
        print("AGE VERIFICATION: Declared Age Range API not available.")
        activeAlert = .ageValidationNotAvailable
        return false
    } catch {
        activeAlert = .ageValidationError
        print("AGE VERIFICATION: An unexpected error occurred: \(error.localizedDescription)")
        return false
    }
}
