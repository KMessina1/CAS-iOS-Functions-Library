/*--------------------------------------------------------------------------------------------------------------------------
    File: GeoLocation.swift
  Author: Kevin Messina
 Created: July 22, 2024
Modified:
 
©2024-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:

--------------------------------------------------------------------------------------------------------------------------*/

import SwiftUI
import CoreLocation

struct PlaceMarkDetails {
    struct PlaceMarkInfo {
        var name: String = ""
        var address: PlaceMarkInfo_AddressInfo = PlaceMarkInfo_AddressInfo()
        var timeZone: PlaceMarkInfo_TimeZoneInfo = PlaceMarkInfo_TimeZoneInfo()
        var region: PlaceMarkInfo_RegionInfo = PlaceMarkInfo_RegionInfo()
        var coordinate: PlaceMarkInfo_CoordinateInfo = PlaceMarkInfo_CoordinateInfo()
    }
    
    struct PlaceMarkInfo_AddressInfo {
        var address1: String = ""
        var address2: String = ""
        var city: String = ""
        var neighborhood: String = ""
        var county: String = ""
        var state: String = ""
        var zip: String = ""
        var country: String = ""
    }
    
    struct PlaceMarkInfo_TimeZoneInfo {
        var identifier: String = ""
        var description: String = ""
        var abbrev: String = ""
        var hours: Double = 0.0
    }
    
    struct PlaceMarkInfo_RegionInfo {
        var region: String = ""
        var countryCode: String = ""
    }

    struct PlaceMarkInfo_CoordinateInfo {
        var latitude: Double = 0.0
        var longitude: Double = 0.0
        var altitude: Double = 0.0
    }

    @MainActor
    func getPlaceMarkFrom(address: String) -> PlaceMarkInfo? {
//        var placemarkFound: Bool = false
//        var placeMarkInfo = PlaceMarkInfo()
//
//        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
//            guard let placemarks = placemarks,
//                      placemarks.count > 0,
//                  let placemark = placemarks.first 
//            else {
//                print("Failed to retrieve location")
//                return
//            }
//    
//            placeMarkInfo.name = placemark.name ?? "n/a"
//
//            placeMarkInfo.address = PlaceMarkInfo_AddressInfo(
//                address1: placemark.thoroughfare ?? "n/a",
//                address2: placemark.subThoroughfare ?? "n/a",
//                city: placemark.locality ?? "n/a",
//                neighborhood: placemark.subLocality ?? "n/a",
//                county: placemark.subAdministrativeArea ?? "n/a",
//                state: placemark.administrativeArea ?? "n/a",
//                zip: placemark.postalCode ?? "n/a",
//                country: placemark.country ?? "n/a"
//            )
//
//            placeMarkInfo.timeZone = PlaceMarkInfo_TimeZoneInfo(
//                identifier: placemark.timeZone?.identifier ?? "n/a",
//                description: placemark.timeZone?.description ?? "n/a",
//                abbrev: placemark.timeZone?.abbreviation(for: Date()) ?? "n/a",
//                hours: (Double(placemark.timeZone?.secondsFromGMT(for: Date()) ?? 0) / 3600.0)
//            )
//
//            placeMarkInfo.region = PlaceMarkInfo_RegionInfo(
//                region: placemark.region?.identifier ?? "n/a",
//                countryCode: placemark.isoCountryCode ?? "n/a"
//            )
//
//            placeMarkInfo.coordinate = PlaceMarkInfo_CoordinateInfo(
//                latitude: placemark.location?.coordinate.latitude ?? 0.0,
//                longitude: placemark.location?.coordinate.longitude ?? 0.0,
//                altitude: placemark.location?.altitude.convert_m_feet ?? 0.0
//            )
//            
//            placemarkFound = true
//        })//End Geocoder
//
//        return placemarkFound ?placeMarkInfo :nil
        
        
        return nil
    }
    
    @MainActor
    func getPlaceMark(for location: CLLocation) async -> PlaceMarkInfo? {
//        return await withCheckedContinuation { continuation in
//            CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
//                guard error == nil else {
//                    print("Error in reverse geocoding: \(error!.localizedDescription)")
//                    continuation.resume(returning: nil)
//                    return
//                }
//                
//                if let placemark = placemarks?.first{
//                    let placeMarkInfo = PlaceMarkInfo(
//                        name: placemark.name ?? "n/a",
//                        address: PlaceMarkInfo_AddressInfo(
//                            address1: placemark.thoroughfare ?? "n/a",
//                            address2: placemark.subThoroughfare ?? "n/a",
//                            city: placemark.locality ?? "n/a",
//                            neighborhood: placemark.subLocality ?? "n/a",
//                            county: placemark.subAdministrativeArea ?? "n/a",
//                            state: placemark.administrativeArea ?? "n/a",
//                            zip: placemark.postalCode ?? "n/a",
//                            country: placemark.country ?? "n/a"
//                        ),
//                        timeZone: PlaceMarkInfo_TimeZoneInfo(
//                            identifier: placemark.timeZone?.identifier ?? "n/a",
//                            description: placemark.timeZone?.description ?? "n/a",
//                            abbrev: placemark.timeZone?.abbreviation(for: Date()) ?? "n/a",
//                            hours: (Double(placemark.timeZone?.secondsFromGMT(for: Date()) ?? 0) / 3600.0)
//                        ),
//                        region: PlaceMarkInfo_RegionInfo(
//                            region: placemark.region?.identifier ?? "n/a",
//                            countryCode: placemark.isoCountryCode ?? "n/a"
//                        ),
//                        coordinate: PlaceMarkInfo_CoordinateInfo(
//                            latitude: placemark.location?.coordinate.latitude ?? 0.0,
//                            longitude: placemark.location?.coordinate.longitude ?? 0.0
//                        )
//                    )
//                    
//                    continuation.resume(returning: placeMarkInfo)
//                } else {
//                    continuation.resume(returning: nil)
//                }//End If
//            }//End CLGeocoder
//        }//withCheckedContinuation
        
        return nil
    }
}

