import SwiftUI
import DeclaredAgeRange

public func requestAgeRangeHelper() async -> Bool {
    @Environment(\.requestAgeRange) var requestAgeRange

    do {
        let ageRangeResponse = try await requestAgeRange(ageGates: 16)

        switch ageRangeResponse {
            case let .sharing(range):
                if let lowerBound = range.lowerBound, lowerBound >= 16 {
                    return true
                } else {
                    print("User's age range is not sufficient for advanced features.")
                    return false
                }
            case .declinedSharing:
                print("Age range sharing declined.")
                return false
            @unknown default:
                return false
        }
    } catch DeclaredAgeRange.AgeRangeService.Error.invalidRequest {
        print("Invalid age range request.")
        return false
    } catch DeclaredAgeRange.AgeRangeService.Error.notAvailable {
        print("Declared Age Range API not available.")
        return false
    } catch {
        print("An unexpected error occurred: \(error.localizedDescription)")
        return false
    }
}
