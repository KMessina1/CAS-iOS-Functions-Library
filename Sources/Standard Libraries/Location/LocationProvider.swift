/*--------------------------------------------------------------------------------------------------------------------------
    File: LocationProvider.swift
  Author: Kevin Messina
 Created: 2/3/26
Modified:
 
©2026 Creative App Solutions, LLC. - All Rights Reserved.
--------------------------------------------------------------------------------------------------------------------------
NOTES:

2026_02_01: Added Geolocation to returned location values in addition to the original core location values.
--------------------------------------------------------------------------------------------------------------------------*/

import CoreLocation
import MapKit
import SwiftUI

class LocationProvider: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private var hasCompleted = false
    private var continuation: CheckedContinuation<
        (lat:Double,lon:Double,alt:Double,street:String,city:String,state:String,zip:String)?,
        Error
    >?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest // High accuracy for altitude
    }

    /// Fetches the current location once and returns specific values
    func fetchCurrentLocation() async throws -> (lat:Double,lon:Double,alt:Double,street:String,city:String,state:String,zip:String)? {
        hasCompleted = false

        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            manager.requestWhenInUseAuthorization() // Request permission if needed
            manager.requestLocation() // One-time request
        }
    }

    // Helper to extract specific components if needed
    private func extractZipFromEndOfAddress(_ address: String) -> String {
        // Split by comma and look at the very last segment (where Zip resides)
        // Example: "1 Infinite Loop, Cupertino, CA 95014"
        let segments = address.components(separatedBy: ",")
        guard let lastSegment = segments.last?.trimmingCharacters(in: .whitespaces) else { return "" }
        
        // Regex applied ONLY to the last segment to avoid house numbers
        let pattern = #"\d{5}(?:-\d{4})?"#
        if let range = lastSegment.range(of: pattern, options: .regularExpression) {
            return String(lastSegment[range])
        }
        return ""
    }
    
    // MARK: - Finish helpers
    private func finish(returning value: (lat:Double,lon:Double,alt:Double,street:String,city:String,state:String,zip:String)?) {
        guard
            !hasCompleted
        else {
            return
        }
        
        hasCompleted = true
        if let currentContinuation = self.continuation {
            currentContinuation.resume(returning: value)
            self.continuation = nil // CRITICAL: Prevent misuse
        }
        manager.stopUpdatingLocation()
    }

    private func finish(throwing error: Error) {
        guard
            !hasCompleted
        else {
            return
        }
        
        hasCompleted = true
        if let currentContinuation = self.continuation {
            currentContinuation.resume(throwing: error)
            self.continuation = nil // CRITICAL: Prevent misuse
        }
        manager.stopUpdatingLocation()
    }

    // Delegate: Success callback
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard
            !hasCompleted
        else {
            return
        }
        
        guard let location = locations.first else {
            finish(returning: nil)
            return
        }

        var result: (lat:Double,lon:Double,alt:Double,street:String,city:String,state:String,zip:String) = (
            lat: 0.0,
            lon: 0.0,
            alt: 0.0,
            street: "",
            city: "",
            state: "",
            zip: ""
        )
        
        // New iOS 26+ Way: Use MKReverseGeocodingRequest
        // Use addressRepresentations for structured data
        let request = MKReverseGeocodingRequest(location: location)

        Task { 
            do {
                let mapItems = try await request?.mapItems
                if let mapItem = mapItems?.first,
                   let representations = mapItem.addressRepresentations,
                   let address = mapItem.address
                {
                    var streetAddress: String = ""
                    var city: String = ""
                    var state: String = ""
                    var zip: String = ""
                    
                    // 1. Street Address (House Number + Street Name)
                    // shortAddress is specifically designed for street-level display
                    if let contextString = address.shortAddress {
                       let components = contextString.components(separatedBy: ",")
                       if components.count > 1 {
                           // Trims whitespace to get just the Address
                           streetAddress = components.first?.trimmingCharacters(in: .whitespaces) ?? ""
                       }
                    }

                    // 2. City is direct
                    city = representations.cityName ?? dashesTxt
                    
                    // 3. State: Parse from cityWithContext (usually returns "City, State")
                    if let contextString = representations.cityWithContext(.short) {
                       let components = contextString.components(separatedBy: ",")
                       if components.count > 1 {
                           // Trims whitespace to get just the State (e.g., " CA")
                           state = components.last?.trimmingCharacters(in: .whitespaces) ?? ""
                       }
                    }
                    
                    // 4. Zip: Extract from the fullAddress localized string
                    if let fullAddr = representations.fullAddress(includingRegion: false, singleLine: true) {
                        zip = extractZipFromEndOfAddress(fullAddr)
                    }
                    
                    result = (
                        lat: Double(location.coordinate.latitude),
                        lon: Double(location.coordinate.longitude),
                        alt: Double(location.altitude.convert_m_feet), // Altitude is in meters, convert to feet
                        street: streetAddress,
                        city: city,
                        state: state,
                        zip: zip
                    )

                    finish(returning: result)
                } else {
                    finish(returning: nil)
                }
            } catch {
                print("Geocoding error: \(error.localizedDescription)")
                finish(throwing: error)
            }
        }
    }

    // Delegate: Error callback
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        finish(throwing: error)
    }
}

