/*--------------------------------------------------------------------------------------------------------------------------
    File: Location.swift
  Author: Kevin Messina
 Created: July 19, 2024
Modified:
 
©2024-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:

2024_08_24  - Added Stop Services and more detailed simPrint logging.
--------------------------------------------------------------------------------------------------------------------------*/

import SwiftUI
import CoreLocation

/// Usage:
///
/// COMPASS DIRECTIONS:
///
///     @ObservedObject var locationManager: LocationManager
///     ...
///     VStack {
///         Text("\(String(format: "%.0f", locationManager.degrees))º".uppercased())
///             .font(.largeTitle)
///     }
///
/// Location Button
///
/// import CoreLocationUI
///
///     if let myLocation = locationManager.location {
///         Text("Latitude: \(myLocation.latitude.formatted(.number.precision(.fractionLength(0)))), Longitude: \(myLocation.longitude.formatted(.number.precision(.fractionLength(0))))".uppercased())
///     } else {
///         LocationButton {
///             locationManager.requestLocation()
///         }
///         .labelStyle(.iconOnly)
///         .cornerRadius(20)
///     }
///
/// Lat & Long
///
///        if let myLocation = locationManager.location {
///            let lat = myLocation.latitude.formatted(.number.precision(.fractionLength(0)))
///            let lon = myLocation.longitude.formatted(.number.precision(.fractionLength(0)))
///
///            Text("Latitude: \(lat), Longitude: \(lon)".uppercased())
///        }
///
///

// Isolate the CLLocationManagerDelegate conformance to the main actor to satisfy Swift 6 actor-isolation rules.
@MainActor
class LocationManager: NSObject, @MainActor CLLocationManagerDelegate {
    var location: CLLocation? = nil
    var lat: Double = 0.0
    var lon: Double = 0.0
    var alt: Double = 0.0

    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
    }
        
    func requestUserAuthorization() async throws {
        manager.requestWhenInUseAuthorization()
        simPrint("Location Manager: Request Authorization From User...", action: .info, subType: .API_Location , log: "")
    }
    
    func startCurrentLocationUpdates() {
        manager.startUpdatingLocation()
        simPrint("Location Manager: Start Updating Location Services...", action: .info, subType: .API_Location , log: "")
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard 
            let location = locations.first
        else {
            simPrint("Location Manager: No records found. Exiting didUpdateLocations delegate.", action: .error, log: "")
            return
        }
        
        self.location = location
        
        lat = location.coordinate.latitude
        lon = location.coordinate.longitude
        alt = location.altitude
        let altTxt = alt.formatted(.number.precision(.fractionLength(2)))
        let txt = "Location Manager: Found Location (Latitude: \(lat), Longitude: \(lon), Altitude: \(altTxt))"
        simPrint(txt, action: .success, subType: .API_Location , log: LFFL())

        manager.stopUpdatingLocation()
        simPrint("Location Manager: Stopped Updating Location Services...", action: .info, subType: .API_Location , log: "")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        simPrint("Location Manager Error: \( error )", action: .error, log: LFFL())
    }
}
       


