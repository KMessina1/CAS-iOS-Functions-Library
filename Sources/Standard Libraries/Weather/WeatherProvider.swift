//--------------------------------------------------------------------------------------------------------------------------
//     File: WeatherProvider.swift
//   Author: Kevin Messina
//  Created: 2/3/26
// Modified:
// 
// ©2026 Creative App Solutions, LLC. - All Rights Reserved.
//--------------------------------------------------------------------------------------------------------------------------
// NOTES:
//--------------------------------------------------------------------------------------------------------------------------

import WeatherKit
import CoreLocation

public struct WeatherProvider {
    public struct Weather_Data {
        let temperatureF: Double
        let humidityPercentage: Double
        let pressureInHg: Double
        let windSpeedMph: Double
        let windAngleDegrees: Double
    }
    
    public func fetchCurrentWeather(lat: Double, lon: Double) async throws -> Weather_Data? {
        let location = CLLocation(latitude: lat, longitude: lon)
        let service = WeatherService.shared
        
        do {
            let weather = try await service.weather(for: location)
            let current = weather.currentWeather
            
            return Weather_Data(
                // 1. Temperature converted to Fahrenheit
                temperatureF: current.temperature.converted(to: .fahrenheit).value,
                
                // 2. Humidity is a Double (0.0 to 1.0), convert to percentage
                humidityPercentage: current.humidity * 100,
                
                // 3. Pressure converted to Inches of Mercury
                pressureInHg: current.pressure.converted(to: .inchesOfMercury).value,
                
                // 4. Wind Speed converted to Miles per Hour
                windSpeedMph: current.wind.speed.converted(to: .milesPerHour).value,
                
                // 5. Wind Angle (Direction) in Degrees
                windAngleDegrees: current.wind.direction.converted(to: .degrees).value
            )
        } catch {
            print("WeatherKit Error: \(error.localizedDescription)")
            return nil
        }
    }
}
