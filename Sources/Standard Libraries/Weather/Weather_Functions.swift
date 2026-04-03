/*--------------------------------------------------------------------------------------------------------------------------
    File: Weather_Functions.swift
  Author: Kevin Messina
 Created: 8/19/24
Modified:
 
©2024-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import Foundation
import CoreLocation
import WeatherKit
import MapKit
import SwiftUI

extension WeatherVM {
    public func saveWeatherInfo() {
        let UD = UserDefaults.standard
        
        UD.set(self.currentTemperature, forKey: KeyNames.Weather.currentTemperature)
        UD.set(self.feelsLike, forKey: KeyNames.Weather.feelsLike)
        UD.set(self.currentHighTemp, forKey: KeyNames.Weather.currentHighTemp)
        UD.set(self.currentLowTemp, forKey: KeyNames.Weather.currentLowTemp)
        UD.set(self.dailyHighLowAbbrev, forKey: KeyNames.Weather.dailyHighLowAbbrev)
        UD.set(self.dailyHighLowFull, forKey: KeyNames.Weather.dailyHighLowFull)
        UD.set(self.currentCondition, forKey: KeyNames.Weather.currentCondition)
        UD.set(self.currentHumidity, forKey: KeyNames.Weather.currentHumidity)
        UD.set(self.currentWindSpeed, forKey:  KeyNames.Weather.currentWindSpeed)
        UD.set(self.currentWindDirection, forKey: KeyNames.Weather.currentWindDirection)
        UD.set(self.currentWindDirectionAbbrev, forKey: KeyNames.Weather.currentWindDirectionAbbrev)
        UD.set(self.currentWindDirImg, forKey: KeyNames.Weather.currentWindDirImg)
        UD.set(self.currentWindDirAngle, forKey: KeyNames.Weather.currentWindDirectionAngle)
        UD.set(self.currentWindGust, forKey: KeyNames.Weather.currentWindGust)
        UD.set(date: self.asOf, forKey: KeyNames.Weather.asOf)
        UD.set(self.currentPressure, forKey: KeyNames.Weather.currentPressure)
        UD.set(self.currentPressureTrendImg, forKey: KeyNames.Weather.currentPressureTrendImg)
        UD.set(self.currentPressureTrend, forKey: KeyNames.Weather.currentPressureTrend)
        UD.set(self.currentPressureState, forKey: KeyNames.Weather.currentPressureState)
        UD.set (color: self.currentPressureColor, forKey: KeyNames.Weather.currentPressureColor)
        UD.set(self.currentDewPoint, forKey: KeyNames.Weather.currentDewPoint)
        UD.set(self.currentSymbolName, forKey: KeyNames.Weather.currentSymbolName)
        if let contentData = try? JSONEncoder().encode(self.hourlyForecast) {
            UD.set(contentData, forKey: KeyNames.Weather.hourlyForecast)
        }
        if let contentData = try? JSONEncoder().encode(self.tenDayForecast) {
            UD.set(contentData, forKey: KeyNames.Weather.tenDayForecast)
        }
        UD.set(self.isLoading, forKey: KeyNames.Weather.isLoading)
        UD.set(Int(self.tempUnits.rawValue), forKey: KeyNames.Weather.tempUnits)
        UD.set(Int(self.pressUnits.rawValue), forKey: KeyNames.Weather.pressUnits)
        UD.set(self.latitude, forKey: KeyNames.Weather.lat)
        UD.set(self.longitude, forKey: KeyNames.Weather.lon)
        UD.set(self.currentSunrise, forKey: KeyNames.Weather.currentSymbolName)
        UD.set(self.currentSunset, forKey: KeyNames.Weather.currentSunset)
        UD.set(self.currentUVIndex, forKey: KeyNames.Weather.currentUVIndex)
        UD.set(self.currentUVExposure, forKey: KeyNames.Weather.currentUVExposure)
        UD.set(self.currentVisibility, forKey: KeyNames.Weather.currentVisibility)
        UD.set(self.currentCloudcover, forKey: KeyNames.Weather.currentCloudcover)
        UD.set(self.currentPrecipitation, forKey: KeyNames.Weather.currentPrecipitation)
        UD.set(self.currentPrecipAmt, forKey: KeyNames.Weather.currentPrecipAmt)
        UD.set(self.currentPrecipChance, forKey: KeyNames.Weather.currentPrecipChance)
        UD.set(self.airDensity_Dry, forKey: KeyNames.Weather.airDensity_Dry)
        UD.set(self.airDensity_Moist, forKey: KeyNames.Weather.airDensity_Moist)
        UD.set(self.drag_H, forKey: KeyNames.Weather.drag_H)
        UD.set(self.drag_V, forKey: KeyNames.Weather.drag_V)
        UD.set(self.dragCoefficient, forKey: KeyNames.Weather.dragCoefficient)
        UD.set(self.elevation, forKey: KeyNames.Weather.elevation)
        UD.set(self.pressure_Mercury, forKey: KeyNames.Weather.currentPressure_HG)
        UD.set(self.pressure_Pascals, forKey: KeyNames.Weather.currentPressure_MB)
        UD.set(self.pressure_Millibars, forKey: KeyNames.Weather.currentPressure_P)
        UD.set(self.temperature_Kelvin, forKey: KeyNames.Weather.currentTemperature_K)
        UD.set(self.temperature_Celsius, forKey: KeyNames.Weather.currentTemperature_C)
        UD.set(self.temperature_Fahrenheit, forKey: KeyNames.Weather.currentTemperature_F)
        UD.set(self.currentWindSpeed_MPH, forKey:  KeyNames.Weather.currentWindSpeed_MPH)
        UD.set(self.currentWindSpeed_KM, forKey:  KeyNames.Weather.currentWindSpeed_KM)
        UD.set(self.currentWindGust_MPH, forKey:  KeyNames.Weather.currentWindGust_MPH)
        UD.set(self.currentWindGust_KM, forKey:  KeyNames.Weather.currentWindGust_KM)
        UD.set(self.humidityRatio, forKey:  KeyNames.Weather.currentHumidityRatio)
        UD.set(self.humidity, forKey:  KeyNames.Weather.humidity)
        UD.set(self.currentCity, forKey:  KeyNames.Weather.city)
        UD.set(self.currentState, forKey:  KeyNames.Weather.state)

        //Set the time of the last save.
        UD.set(date: Date.now, forKey: KeyNames.Weather.lastFetch)
        UD.synchronize()
    }
    
    public func getSavedWeatherInfo() {
        let UD = UserDefaults.standard
        
        self.currentTemperature = UD.string(forKey: KeyNames.Weather.currentTemperature) ?? ""
        self.feelsLike = UD.string(forKey: KeyNames.Weather.feelsLike) ?? ""
        self.currentHighTemp = UD.string(forKey: KeyNames.Weather.currentHighTemp) ?? ""
        self.currentLowTemp = UD.string(forKey: KeyNames.Weather.currentLowTemp) ?? ""
        self.dailyHighLowAbbrev = UD.string(forKey: KeyNames.Weather.dailyHighLowAbbrev) ?? ""
        self.dailyHighLowFull = UD.string(forKey: KeyNames.Weather.dailyHighLowFull) ?? ""
        self.currentCondition = UD.string(forKey: KeyNames.Weather.currentCondition) ?? ""
        self.currentHumidity = UD.string(forKey: KeyNames.Weather.currentHumidity) ?? ""
        self.currentWindSpeed = UD.string(forKey: KeyNames.Weather.currentWindSpeed) ?? ""
        self.currentWindDirection = UD.string(forKey: KeyNames.Weather.currentWindDirection) ?? ""
        self.currentWindDirectionAbbrev = UD.string(forKey: KeyNames.Weather.currentWindDirectionAbbrev) ?? ""
        self.currentWindDirImg = UD.string(forKey: KeyNames.Weather.currentWindDirImg) ?? ""
        self.currentWindDirAngle = UD.double(forKey: KeyNames.Weather.currentWindDirectionAngle)
        self.currentWindGust = UD.string(forKey: KeyNames.Weather.currentWindGust) ?? ""
        self.asOf = UD.date(forKey: KeyNames.Weather.asOf) ?? Date.now
        self.currentPressure = UD.string(forKey: KeyNames.Weather.currentPressure) ?? ""
        self.currentPressureTrendImg = UD.string(forKey: KeyNames.Weather.currentPressureTrendImg) ?? ""
        self.currentPressureTrend = UD.string(forKey: KeyNames.Weather.currentPressureTrend) ?? ""
        self.currentPressureState = UD.string(forKey: KeyNames.Weather.currentPressureState) ?? ""
        self.currentPressureColor = UD.color(forKey: KeyNames.Weather.currentPressureColor) ?? .white
        self.currentDewPoint = UD.string(forKey: KeyNames.Weather.currentDewPoint) ?? ""
        self.currentSymbolName = UD.string(forKey: KeyNames.Weather.currentSymbolName) ?? ""
        if let contentData = UD.object(forKey: KeyNames.Weather.hourlyForecast) as? Data,
           let content = try? JSONDecoder().decode([WeatherData.HourWeather].self, from: contentData) {
            self.hourlyForecast = content
        }
        if let contentData = UD.object(forKey: KeyNames.Weather.tenDayForecast) as? Data,
           let content = try? JSONDecoder().decode([WeatherData.DailyWeather].self, from: contentData) {
            self.tenDayForecast = content
        }
        //Custom
        self.isLoading = UD.bool(forKey: KeyNames.Weather.isLoading)
        self.tempUnits = TemperatureUnits(rawValue: UD.integer(forKey: KeyNames.Weather.tempUnits))!
        self.pressUnits = PressureUnits(rawValue: UD.integer(forKey: KeyNames.Weather.pressUnits)) ?? PressureUnits.Hg
        self.latitude = UD.double(forKey: KeyNames.Weather.lat)
        self.longitude = UD.double(forKey: KeyNames.Weather.lon)
        self.currentLocation = CLLocation(latitude: self.latitude, longitude: self.longitude)
        self.currentSunrise = UD.date(forKey: KeyNames.Weather.currentSymbolName) ?? Date.now
        self.currentSunset = UD.date(forKey: KeyNames.Weather.currentSunset) ?? Date.now
        self.currentUVIndex = UD.integer(forKey: KeyNames.Weather.currentUVIndex)
        self.currentUVExposure = UD.string(forKey: KeyNames.Weather.currentUVExposure) ?? ""
        self.currentVisibility = UD.string(forKey: KeyNames.Weather.currentVisibility) ?? ""
        self.currentCloudcover = UD.string(forKey: KeyNames.Weather.currentCloudcover) ?? ""
        self.currentPrecipitation = UD.string(forKey: KeyNames.Weather.currentPrecipitation) ?? ""
        self.currentPrecipAmt = UD.string(forKey: KeyNames.Weather.currentPrecipAmt) ?? ""
        self.currentPrecipChance = UD.string(forKey: KeyNames.Weather.currentPrecipChance) ?? ""
        self.airDensity_Dry = UD.double(forKey: KeyNames.Weather.airDensity_Dry)
        self.airDensity_Moist = UD.double(forKey: KeyNames.Weather.airDensity_Moist)
        self.drag_H = UD.string(forKey: KeyNames.Weather.drag_H) ?? ""
        self.drag_V = UD.string(forKey: KeyNames.Weather.drag_V) ?? ""
        self.dragCoefficient = UD.string(forKey: KeyNames.Weather.dragCoefficient) ?? ""
        self.elevation = UD.double(forKey: KeyNames.Weather.elevation)
        self.pressure_Mercury = UD.double(forKey: KeyNames.Weather.currentPressure_HG)
        self.pressure_Pascals = UD.double(forKey: KeyNames.Weather.currentPressure_MB)
        self.pressure_Millibars = UD.double(forKey: KeyNames.Weather.currentPressure_P)
        self.temperature_Kelvin = UD.double(forKey: KeyNames.Weather.currentTemperature_K)
        self.temperature_Celsius = UD.double(forKey: KeyNames.Weather.currentTemperature_C)
        self.temperature_Fahrenheit = UD.double(forKey: KeyNames.Weather.currentTemperature_F)
        self.currentWindSpeed_MPH = UD.double(forKey: KeyNames.Weather.currentWindSpeed_MPH)
        self.currentWindSpeed_KM = UD.double(forKey: KeyNames.Weather.currentWindSpeed_KM)
        self.currentWindGust_MPH = UD.double(forKey: KeyNames.Weather.currentWindGust_MPH)
        self.currentWindGust_KM = UD.double(forKey: KeyNames.Weather.currentWindGust_KM)
        self.humidityRatio = UD.double(forKey: KeyNames.Weather.currentHumidityRatio)
        self.humidity = UD.double(forKey: KeyNames.Weather.humidity)
        self.currentCity = UD.string(forKey: KeyNames.Weather.city) ?? ""
        self.currentState = UD.string(forKey: KeyNames.Weather.state) ?? ""
    }

    public func setTemperatureInfo(
        temp: Measurement<UnitTemperature>,
        forecast:Forecast<DayWeather>,
        date: Date,
        symbol: String,
        conditions: String
    ) {
        let Kelvin = temp.converted(to: UnitTemperature.kelvin).value
        let Celsius = temp.converted(to: UnitTemperature.celsius).value
        let Fahrenheit = temp.converted(to: UnitTemperature.fahrenheit).value
        let FahrenheitTxt = Fahrenheit.formatted(.number.precision(.fractionLength(0)))

        if forecast.count > 0 {
            let hi = forecast[0].highTemperature.converted(to: UnitTemperature.fahrenheit).value.formatted(.number.precision(.fractionLength(0)))
            let lo = forecast[0].lowTemperature.converted(to: UnitTemperature.fahrenheit).value.formatted(.number.precision(.fractionLength(0)))

            self.currentHighTemp = "\( hi )°"
            self.currentLowTemp = "\( lo )°"
            self.dailyHighLowAbbrev = "H: \( self.currentHighTemp )  /  L: \( self.currentLowTemp )"
            self.dailyHighLowFull = "High: \( self.currentHighTemp )  /  Low: \( self.currentLowTemp )"
        }else{
            self.currentHighTemp = ""
            self.currentLowTemp = ""
            self.dailyHighLowAbbrev = "H: n/a / L: n/a"
            self.dailyHighLowFull = "High: n/a / Low: n/a"
        }
        
        self.currentTemperature = "\( FahrenheitTxt )°"
        self.temperature_Fahrenheit = Fahrenheit
        self.temperature_Kelvin = Kelvin
        self.temperature_Celsius = Celsius
        self.currentSymbolName = symbol
        self.currentCondition = conditions
        self.asOf = date
    }
    
    public func setCloudCoverInfo(
        uvIndex: UVIndex,
        visibility: Measurement<UnitLength>,
        cloudCover: Double
    ) {
        let UVIndex = uvIndex.value
        let exposure = uvIndex.category.rawValue.capitalized
        let visible = visibility.converted(to: UnitLength.miles).value.formatted(.number.precision(.fractionLength(2)))
        let cover = (cloudCover * 100.0).formatted(.number.precision(.fractionLength(0)))
        
        self.currentUVIndex = UVIndex
        self.currentUVExposure = exposure
        self.currentVisibility = "\( visible ) mi."
        self.currentCloudcover = "\( cover )%"
    }

    public func setHumidityInfo(
        humidity:Double,
        dewPoint:Measurement<UnitTemperature>,
        feelsLike:Measurement<UnitTemperature>,
        tempUnit: UnitTemperature
    ) {
        let humidityRelative = (humidity * 100).formatted(.number.precision(.fractionLength(0)))
        let dewPoint = dewPoint.converted(to: tempUnit).value.formatted(.number.precision(.fractionLength(0)))
        let feelsLike = feelsLike.converted(to: tempUnit).value.formatted(.number.precision(.fractionLength(0)))

        self.currentHumidity = "\( humidityRelative )%"
        self.humidity = Double(humidityRelative) ?? 0.0
        self.currentDewPoint = "\( dewPoint )°"
        self.feelsLike = "\( feelsLike )°"
    }
    
    public func setPressureInfo(pressure: Measurement<UnitPressure>, trend: String) {
        let pressure_Mercury:Double = pressure.converted(to: .inchesOfMercury).value
        let pressure_Pascals:Double = pressure.converted(to: UnitPressure.kilopascals).value
        let pressure_Millibars:Double = pressure.converted(to: UnitPressure.millibars).value

        if pressure_Mercury >= 30.20 {
            self.currentPressureState = "H"
            self.currentPressureTrendingState = "High"
            self.currentPressureColor = .red
        } else if pressure_Mercury <= 29.80 {
            self.currentPressureState = "L"
            self.currentPressureTrendingState = "Low"
            self.currentPressureColor = .blue
        } else {
            self.currentPressureState = "-"
            self.currentPressureTrendingState = "Steady"
            self.currentPressureColor = .green
        }
        
        switch trend.lowercased() {
            case "rising": self.currentPressureTrendImg = "arrow.up"
            case "falling": self.currentPressureTrendImg = "arrow.down"
            case "steady": self.currentPressureTrendImg = "arrow.up"
            default: self.currentPressureTrendImg = "equal"
        }
        
        self.pressure_Pascals = pressure_Pascals
        self.pressure_Millibars = pressure_Millibars
        self.pressure_Mercury = pressure_Mercury
        self.currentPressure = "\( pressure_Millibars ) mb"
        self.currentPressureTrend = trend
    }
    
    public func windDegreesRounded(_ degrees: Double) -> Double {
        // Normalize to [0, 360)
        let d = ((degrees.truncatingRemainder(dividingBy: 360)) + 360).truncatingRemainder(dividingBy: 360)

        switch d {
            case 0..<22.5: return 0
            case 22.5..<67.5: return 45
            case 67.5..<112.5: return 90
            case 112.5..<157.5: return 135
            case 157.5..<202.5: return 180
            case 202.5..<247.5: return 225
            case 247.5..<292.5: return 270
            case 292.5..<337.5: return 315
            default: return 0 // covers [337.5, 360)
        }
    }

    public func windDirFromDegrees(_ degrees: Double) -> String {
        // Normalize to [0, 360)
        let d = ((degrees.truncatingRemainder(dividingBy: 360)) + 360).truncatingRemainder(dividingBy: 360)

        switch d {
            case 0..<22.5: return "N↑"
            case 22.5..<67.5: return "NE↗︎"
            case 67.5..<112.5: return "E→"
            case 112.5..<157.5: return "SE↘︎"
            case 157.5..<202.5: return "S↓"
            case 202.5..<247.5: return "SW↙︎"
            case 247.5..<292.5: return "W←"
            case 292.5..<337.5: return "NW↖︎"
            default: return "N↑" // covers [337.5, 360)
        }
    }

    public func setWindInfo(_ wind:Wind) {
        let DU: Int = UserDefaults.standard.integer(forKey: KeyNames.App.Settings.distanceUnit)
        let isMiles = (DU == DistanceUnits.yards.rawValue)
        let DUText = isMiles ?txt().mph :txt().km

        let compassDirection = wind.compassDirection
        let windDirAbbrev = wind.compassDirection.abbreviation
        let directionUnit = wind.direction.unit.symbol
        let windSpeed_MPH = wind.speed.converted(to: .milesPerHour).value
        let windSpeed_KM = wind.speed.converted(to: .kilometersPerHour).value
        let windSpeed = isMiles ?windSpeed_MPH :windSpeed_KM
        let windSpeedTxt = windSpeed.formatted(.number.precision(.fractionLength(1)))

        let windGust_MPH = wind.gust?.converted(to: UnitSpeed.milesPerHour).value ?? 0.0
        let windGust_KM = wind.gust?.converted(to: UnitSpeed.kilometersPerHour).value ?? 0.0
        let windGust = isMiles ?windGust_MPH :windGust_KM
        let windGustTxt = windGust.formatted(.number.precision(.fractionLength(0)))
        
        switch windDirAbbrev {
            case "N":
                self.currentWindDirSymbol = "arrow.down.circle"
                self.currentWindDirImg = "⬇︎"
                self.currentWindDirAngle = 180
            case "NE","NNE","ENE":
                self.currentWindDirSymbol = "arrow.down.left.circle"
                self.currentWindDirImg = "⬋"
                self.currentWindDirAngle = 225
            case "E":
                self.currentWindDirSymbol = "arrow.left.circle"
                self.currentWindDirImg = "⬅︎"
                self.currentWindDirAngle = 270
            case "SE","SSE","ESE":
                self.currentWindDirSymbol = "arrow.up.left.circle"
                self.currentWindDirImg = "⬉"
                self.currentWindDirAngle = 315
            case "S":
                self.currentWindDirSymbol = "arrow.up.circle"
                self.currentWindDirImg = "⬆︎"
                self.currentWindDirAngle = 0
            case "SW","SSW","WSW":
                self.currentWindDirSymbol = "arrow.up.right.circle"
                self.currentWindDirImg = "⬈"
                self.currentWindDirAngle = 45
            case "W":
                self.currentWindDirSymbol = "arrow.right.circle"
                self.currentWindDirImg = "➡︎"
                self.currentWindDirAngle = 90
            case "NW","NNW","WNW":
                self.currentWindDirSymbol = "arrow.down.right.circle"
                self.currentWindDirImg = "⬊"
                self.currentWindDirAngle = 135
            default:
                self.currentWindDirSymbol = ""
                self.currentWindDirImg = ""
                self.currentWindDirAngle = 0
        }
        
        self.currentWindDirection = "\(windDirAbbrev)\(directionUnit) \(compassDirection)"
        self.currentWindDirectionAbbrev = "\(windDirAbbrev)"
        self.currentWindSpeed = "\( windSpeedTxt ) \( DUText )"
        self.currentWindSpeed_MPH = windSpeed_MPH
        self.currentWindSpeed_KM = windSpeed_KM
        self.currentWindGust = "\( windGustTxt ) \( DUText )"
        self.currentWindGust_MPH = windGust_MPH
        self.currentWindGust_KM = windGust_KM
    }
    
    public func setTempUnit() -> UnitTemperature {
        switch self.tempUnits {
            case .Celsius:
                self.currentTempSymbol = "C"
                return UnitTemperature.celsius
            case .Fahrenheit:
                self.currentTempSymbol = "F"
                return UnitTemperature.fahrenheit
        }
    }
    
    public func setLocation() async {
        // Save the auto-generated location updates for weather if not set to User Provided...
        if UserDefaults.standard.integer(forKey: KeyNames.App.Calc.Location.manualLoc) == 0 {
            self.latitude = self.locationManager.location?.coordinate.latitude ?? 0.0
            self.longitude = self.locationManager.location?.coordinate.longitude ?? 0.0
            self.elevation = self.locationManager.location?.altitude ?? 0.0
            
            simPrint("Weather Mode: Automatic ; ",action: .info, subType: .API_Weather,log: LFFL())
        }else{
            self.latitude = self.locationManager.location?.coordinate.latitude ?? 0.0
            self.longitude = self.locationManager.location?.coordinate.longitude ?? 0.0
            self.elevation = self.locationManager.location?.altitude ?? 0.0
        }

        self.currentLocation = CLLocation(latitude: self.latitude, longitude: self.longitude )

        // Get the detailed location details for the lat/lon of location regardless if user or auto set location...
        if let placeMarkInfo = await PlaceMarkDetails().getPlaceMark(for: self.currentLocation) {
            // Update Weather Info
            self.currentCity =  placeMarkInfo.address.city.lowercased() == "n/a" ?placeMarkInfo.name :placeMarkInfo.address.city
            self.currentState = placeMarkInfo.address.state
            let UD = UserDefaults.standard
            UD.set(self.currentCity, forKey: KeyNames.Weather.city)
            UD.set(self.currentState, forKey: KeyNames.Weather.state)
            UD.synchronize()

            simPrint("Weather locale placemark found",action:.success, subType:.API_GeoLocation , log: LFFL())
        }else{
            simPrint("Weather locale Failed to retrieve location ",action: .error, subType: .API_GeoLocation,log: LFFL())
            print("Failed to retrieve location")
        }
        
        simPrint("Weather Mode: User Input; ",action: .info, subType: .API_Weather,log: LFFL())

        simPrint("Current Location Settings; ",action: .info, subType: .API_Location,log: LFFL())
        simPrint("----------------------------------------------------", action: .detail, log: "")
        simPrint("Current Lat: \( self.latitude)", action: .detail_1, log: "")
        simPrint("Current Lon: \( self.longitude)", action: .detail_1, log: "")
        simPrint("Current Alt: \( self.elevation)", action: .detail_1, log: "")
        simPrint("Current City: \( self.currentCity)", action: .detail_1, log: "")
        simPrint("Current State: \( self.currentState)", action: .detail_1, log: "")
        simPrint("----------------------------------------------------\n", action: .detail, log: "")
    }
    
    public func getCurrentLocation() {
        // Determine auto or user location...
        let userLocSetting: Int = UserDefaults.standard.integer(forKey: KeyNames.App.Calc.Location.manualLoc)
        let isUserLoc: Bool = (userLocSetting == 1)

        // If user location, then we have to override the lat & lon from GPS...
        if isUserLoc {
            let UD = UserDefaults.standard
            self.latitude = UD.double(forKey: KeyNames.App.Calc.User_Address.latitude)
            self.longitude = UD.double(forKey: KeyNames.App.Calc.User_Address.longitude)
            self.elevation = UD.double(forKey: KeyNames.App.Calc.Elevation.aboveSeaLevel)
            self.currentLocation = CLLocation(latitude: self.latitude, longitude: self.longitude)
            simPrint("Weather - Location: Using USER location information", action: .success, subType: .API_Weather, log: LFFL())
            
            simPrint("Weather: Fetching new.", action: .success, subType: .API_Weather,log: LFFL())
            Task(priority: .high) {
                await self.fetchCurrentWeather(lat:self.latitude, lon: self.longitude)
            }
        }else{
            if let myLocation = self.locationManager.location,
               !self.isLoading
            {
                self.latitude = myLocation.coordinate.latitude
                self.longitude = myLocation.coordinate.longitude
                self.elevation = myLocation.altitude
                self.currentLocation = CLLocation(latitude: self.latitude, longitude: self.longitude)
                simPrint("Weather - Location: Using current location information", action: .success, subType: .API_Weather, log: LFFL())
                
                simPrint("Weather: Fetching new.", action: .success, subType: .API_Weather,log: LFFL())
                Task(priority: .high) {
                    await self.fetchCurrentWeather(lat:self.latitude, lon: self.longitude)
                }
            } else {
                Task(priority: .high, operation: {
                    try? await self.locationManager.requestUserAuthorization()
                    self.locationManager.startCurrentLocationUpdates()
                    simPrint("Weather - Location: Requesting Location access", action: .warning, subType: .API_Weather, log: LFFL())
                })
            }
        }
    }
    
    public func needsUpating() -> Bool {
        let temp0: Bool = (self.currentTemperature.isEmpty || self.currentTemperature == "0°")
        let hi0: Bool = (self.currentHighTemp.isEmpty || self.currentHighTemp == "0°")
        let lo0: Bool = (self.currentLowTemp.isEmpty || self.currentLowTemp == "0°")
        
        let needsUpdating: Bool = Bool(temp0 && hi0 && lo0)
        
        simPrint("Weather Needs Updating: \(needsUpdating.asTrueFalse)", action: .info, subType: .API_Weather, log: LFFL())
        return needsUpdating
    }
    
    public func updateWeatherIfNeeded(forceload:Bool = false) -> Void {
        let weatherNeedsUpdate = needsUpating()
        
        if forceload {
            simPrint("Weather: FORCE LOADING, fetching anew.", action: .info, subType: .API_Weather, log: LFFL())
            DispatchQueue.main.async {
                self.getCurrentLocation()
            }
            
            return
        }
        
        if self.isLoading {
            simPrint("Weather: isLoading... ignoring refresh request.", action: .info, subType: .API_Weather, log: LFFL())
        }else{
            /*  Does the user defaults have a stored value for the last fetch of weather?
             Yes, read the date. No, load weather.
             */
            if let lastFetch = UserDefaults.standard.date(forKey: KeyNames.Weather.lastFetch) {
                simPrint("Weather: Last fetch found in User Defaults.", action: .info, subType: .API_Weather, log: LFFL())
                
                /*  Has more than 10 minutes elapsed since the last fetch of weather?
                 Yes:    Reload weather.
                 No:     Are some required weather fields empty?
                 Yes:    Load last saved weather information from user defaults.
                 No:     Ignore and exit without doing anything
                 */
                if Date().haveMinutesElapsedFromNow(minutes: 10, from: lastFetch) {
                    DispatchQueue.main.async {
                        self.getCurrentLocation()
                        simPrint("Weather: More than 10 minutes has elapsed since Last fetch, fetching new.", action: .warning, subType: .API_Weather, log: LFFL())
                    }
                }else if weatherNeedsUpdate {
                    DispatchQueue.main.async {
                        self.getSavedWeatherInfo()
                        simPrint("Weather: Required fields are blank in weather, fetching new.", action: .warning, subType: .API_Weather, log: LFFL())
                    }
                }else{
                    simPrint("Weather: data is still fresh, ignoring refresh request.", action: .success, subType: .API_Weather, log: LFFL())
                }
            }else{
                if self.locationManager.location != nil {
                    simPrint("Weather: Fetching new.", action: .success, subType: .API_Weather,log: LFFL())
                    Task(priority: .high) {
                        await self.fetchCurrentWeather(lat:self.latitude, lon: self.longitude)
                    }
                }else{
                    DispatchQueue.main.async {
                        self.getCurrentLocation()
                        simPrint("Weather: Last fetch NOT found in User Defaults, fetching new", action: .warning, subType: .API_Weather, log: LFFL())
                    }
                }
            }
        }
    }
    
    public func setHourlyData(weather: Weather, tempUnits: UnitTemperature) -> Void {
        self.hourlyForecast.removeAll()
        weather.hourlyForecast.forecast.forEach { hour in
            if self.hourlyForecast.count < 24 {
                if WeatherData().isSameHourOrLater(date1: hour.date, date2: Date()) {
                    let data = hour.temperature.converted(to: tempUnits).value.formatted(.number.precision(.fractionLength(0)))
                    
                    if self.hourlyForecast.count < 1 {
                        self.currentPrecipitation = hour.precipitation.rawValue
                        self.currentPrecipAmt = "\( hour.precipitationAmount.converted(to: UnitLength.inches).value.formatted(.number.precision(.fractionLength(2))) )\""
                        self.currentPrecipChance = "\( (hour.precipitationChance * 100).formatted(.number.precision(.fractionLength(0))) )%"
                    }
                    
                    self.hourlyForecast.append(WeatherData.HourWeather(
                        time: WeatherData().hourFormatter(date: hour.date),
                        symbolName: hour.symbolName,
                        temperature: "\( data )°"
                    ))
                }
            }
        }
    }
    
    public func set10DayData(weather: Weather, tempUnits: UnitTemperature) {
        self.tenDayForecast.removeAll()
        weather.dailyForecast.forecast.forEach { day in
            let low = day.lowTemperature.converted(to: tempUnits).value.formatted(.number.precision(.fractionLength(0)))
            let high = day.highTemperature.converted(to: tempUnits).value.formatted(.number.precision(.fractionLength(0)))
            
            if self.tenDayForecast.count < 1 {
                self.currentSunrise = day.sun.sunrise ?? Date.now
                self.currentSunset = day.sun.sunset ?? Date.now
            }
            
            self.tenDayForecast.append(WeatherData.DailyWeather(
                day: WeatherData().dayFormatter(date: day.date),
                symbolName: day.symbolName,
                lowTemperature: "\( low )",
                highTemperature: "\( high )"
            ))
        }
    }
}

