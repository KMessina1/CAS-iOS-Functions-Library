/*-------------------------------------------------------------------------------------------------------------------------
    File: Location_OpenElevation.swift
  Author: Kevin Messina
 Created: 3/1/26
Modified:
 
©2026 Creative App Solutions, LLC. - All Rights Reserved.
--------------------------------------------------------------------------------------------------------------------------
NOTES: Uses the free resources from Open Elevation (1,000 free monthly calls) :
       Website: https://www.opentopodata.org
       Example: https://api.opentopodata.org/v1/ned10m?locations=37.785834,-122.406417
--------------------------------------------------------------------------------------------------------------------------*/

import Foundation
import SwiftUI

class LocationOpenElevation: NSObject {
    struct ElevationResponse: Codable {
        let status: String
        let results: [ElevationResult]
        
        struct ElevationResult: Codable {
            let elevation: Double
            let dataset: String
        }
    }
    
    /// Fetches the elevation for a specific coordinate using the OpenTopoData.org API
    func fetchElevation(lat:Double,lon:Double) async -> (status:String,elevation_m:Double,elevation_ft:Double,dataset:String) {
        let urlString = "https://api.opentopodata.org/v1/ned10m?locations=\(lat),\(lon)"

        guard
            let url = URL(string: urlString)
        else {
            return ("Invalid URL", 0.0, 0.0, "")
        }

        do {
            // Perform the network request
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // Decode the JSON directly into our structs
            let decodedResponse = try JSONDecoder().decode(ElevationResponse.self, from: data)
            
            if let firstResult = decodedResponse.results.first {
                return (decodedResponse.status, firstResult.elevation, firstResult.elevation.convert_m_feet, firstResult.dataset)
            } else {
                return (decodedResponse.status, 0.0, 0.0, "No Results")
            }
        } catch {
            return ("Error: \(error.localizedDescription)", 0.0, 0.0, "")
        }
    }
}
