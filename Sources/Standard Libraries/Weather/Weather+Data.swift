/*--------------------------------------------------------------------------------------------------------------------------
    File: Weather+Data.swift
  Author: Kevin Messina
 Created: 6/18/24
Modified:
 
©2024-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import Foundation

public struct WeatherData {
    public struct windage {
        var id: Int = 0
        var name: String = ""
        var abbrev: String = ""
        var arrow: String = ""
        var angle: Double = 0.0
    }
    
    public let ordinalDirections: [String] = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]

    public let ordinalWindDirections: [windage] = [
        windage.init(id: 1, name:"North", abbrev:"N", arrow: "↓", angle: 0.0),
        windage.init(id: 2, name:"Northeast", abbrev:"NE", arrow: "↙︎", angle: 45.0),
        windage.init(id: 3, name:"East", abbrev:"E", arrow: "←", angle: 90.0),
        windage.init(id: 4, name:"Southeast", abbrev:"SE", arrow: "↖︎", angle: 135.0),
        windage.init(id: 5, name:"South", abbrev:"S", arrow: "↑", angle: 180.0),
        windage.init(id: 6, name:"Southwest", abbrev:"SW", arrow: "↗︎", angle: 225.0),
        windage.init(id: 7, name:"West", abbrev:"W", arrow: "→", angle: 270.0),
        windage.init(id: 8, name:"Northwest", abbrev:"NW", arrow: "↘︎", angle: 315.0)
    ]

    public func returnOrdWindDirForAngle(_ forAngle: Double) -> windage {
        var useAngleValue: Double = 0.0
        
        switch forAngle {
            case 22.25..<67.5 : useAngleValue = 45.0 //NE
            case 67.5..<112.5 : useAngleValue = 90.0 //E
            case 112.5..<157.5 : useAngleValue = 135.0 //SE
            case 157.5..<202.5 : useAngleValue = 180.0 //S
            case 202.5..<247.5 : useAngleValue = 225.0 //SW
            case 247.5..<292.5 : useAngleValue = 270.0 //W
            case 292.5..<337.5 : useAngleValue = 315.0 //NW
            case 337.5...360 : useAngleValue = 0.0
            default: useAngleValue = 0.0 //N
        }
        
        return ordinalWindDirections.filter( { $0.angle == useAngleValue } ).first ?? windage()
    }
    
    public struct city {
        let id:Int
        let name:String
        let lat:Double
        let lon:Double
    }
    
    public let cities = [
        city.init(id: 0, name: "Park, CA", lat: 37.334606, lon: -122.009102),
        city.init(id: 1, name: "Jacksonville, FL", lat: 30.332184, lon: -81.655647),
        city.init(id: 2, name: "Albany, NY", lat: 42.652580, lon: -73.756233),
        city.init(id: 3, name: "Houston, TX", lat: 29.760799, lon: -95.369507),
        city.init(id: 4, name: "Anchorage, AK", lat: 61.216579, lon: -149.899597),
        city.init(id: 5, name: "Current Loc {N/A}", lat: 37.334606, lon: -122.009102),
        city.init(id: 6, name: "Custom Location", lat: 0, lon: 0)
    ]
    
    public struct HourWeather: Codable {
        let time: String
        let symbolName: String
        let temperature: String
    }
    
    public struct DailyWeather: Codable {
        let day: String
        let symbolName: String
        let lowTemperature: String
        let highTemperature: String
    }
    
    public func isSameHourOrLater(date1: Date, date2: Date) -> Bool {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "ha"
        
        let calendar = Calendar.current
        let comparisonResult = calendar.compare(date1, to: date2, toGranularity: .hour)
        
        return (comparisonResult == .orderedSame || comparisonResult == .orderedDescending)
    }
    
    public func hourFormatter(date: Date) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "ha"
        
        let calendar = Calendar.current
        
        let inputDateComponents = calendar.dateComponents([.day,.hour], from: date)
        let currentDateComponents = calendar.dateComponents([.day,.hour], from: Date())
        
        return (inputDateComponents == currentDateComponents) ?"Now" :dateformatter.string(from: date)
    }
    
    public func dayFormatter(date: Date) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "EEE"
        
        let calendar = Calendar.current
        
        let inputDateComponents = calendar.dateComponents([.day], from: date)
        let currentDateComponents = calendar.dateComponents([.day], from: Date())
        
        return (inputDateComponents == currentDateComponents) ?"Today" :dateformatter.string(from: date)
    }
}
