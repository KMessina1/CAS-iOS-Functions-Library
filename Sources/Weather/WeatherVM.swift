/*--------------------------------------------------------------------------------------------------------------------------
    File: WeatherVM.swift
  Author: Kevin Messina
 Created: 4/21/24
Modified:
 
©2024-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import WeatherKit
import CoreLocation
import SwiftUI

@MainActor
public class WeatherVM: ObservableObject {
    let weatherService = WeatherService()
    //Location Manager
    @State var locationManager:LocationManager = LocationManager()

    @Published var currentTemperature:String = ""
    @Published var currentTempSymbol:String = ""
    @Published var feelsLike:String = ""
    @Published var currentHighTemp:String = ""
    @Published var currentLowTemp:String = ""
    @Published var dailyHighLowAbbrev:String = "H: 0°  /  L: 0°"
    @Published var dailyHighLowFull:String = "High: 0°  /  Low: 0°"
    @Published var currentCondition:String = ""
    @Published var currentHumidity:String = ""
    @Published var currentWindSpeed: String = ""
    @Published var currentWindDirection: String = ""
    @Published var currentWindDirectionAbbrev: String = ""
    @Published var currentWindDirSymbol: String = ""
    @Published var currentWindDirImg: String = ""
    @Published var currentWindDirAngle: Double = 0.0
    @Published var currentWindGust: String = ""
    @Published var asOf: Date = Date()
    @Published var currentPressure: String = ""
    @Published var currentPressureTrendImg: String = ""
    @Published var currentPressureTrend: String = ""
    @Published var currentPressureState: String = ""
    @Published var currentPressureTrendingState: String = ""
    @Published var currentPressureColor: Color = .white
    @Published var currentDewPoint: String = ""
    @Published var currentSymbolName: String = ""
    @Published var hourlyForecast: [WeatherData.HourWeather] = []
    @Published var tenDayForecast: [WeatherData.DailyWeather] = []
    //Custom
    @Published var isLoading: Bool = false
    @Published var tempUnits: TemperatureUnits = .Fahrenheit
    @Published var pressUnits: PressureUnits = .Hg
    @Published var latitude: Double = deviceIs.Sim ? 37.334606 : 0.0
    @Published var longitude: Double = deviceIs.Sim ? -122.009102 : 0.0
    @Published var currentLocation: CLLocation = CLLocation()
    @Published var currentCity: String = ""
    @Published var currentState: String = ""
    @Published var currentSunrise: Date = Date()
    @Published var currentSunset: Date = Date()
    @Published var currentUVIndex: Int = 0
    @Published var currentUVExposure: String = ""
    @Published var currentVisibility: String = ""
    @Published var currentCloudcover: String = ""
    @Published var currentPrecipitation: String = ""
    @Published var currentPrecipAmt: String = ""
    @Published var currentPrecipChance: String = ""
    //Calculations
    @Published var temperature_Kelvin: Double = 0.00
    @Published var temperature_Celsius: Double = 0.00
    @Published var temperature_Fahrenheit: Double = 0.00
    @Published var pressure_Mercury: Double = 0.00
    @Published var pressure_Pascals: Double = 0.00
    @Published var pressure_Millibars: Double = 0.00
    @Published var currentWindSpeed_MPH: Double = 0.0
    @Published var currentWindSpeed_KM: Double = 0.0
    @Published var currentWindGust_MPH: Double = 0.0
    @Published var currentWindGust_KM: Double = 0.0
    @Published var airDensity_Dry: Double = 0.0
    @Published var airDensity_Moist: Double = 0.0
    @Published var elevation: Double = 0.00
    @Published var humidityRatio: Double = 0.00
    @Published var humidity: Double = 0.0
    @Published var drag_H: String = ""
    @Published var drag_V: String = ""
    @Published var dragCoefficient: String = ""

//    init() {
//        if !isLoading {
//            self.isLoading = true
//            getCurrentLocation()
//            simPrint("Get Current Location on Weather INIT()...",action: .API_Weather, subType: .API_Location,log: LFFL())
//            self.isLoading = false
//        }
//    }

    func setWeatherParams(weather: Weather) {
        Task(priority: .high) {
            let w = weather.currentWeather
            let wc = w.condition.description
            let df = weather.dailyForecast
            
            // Save the auto-generated location updates for weather if not set to User Provided...
            await self.setLocation()
            
            let TU:UnitTemperature = self.setTempUnit()
            self.setTemperatureInfo(temp: w.temperature, forecast: df, date: w.date, symbol: w.symbolName, conditions: wc)
            self.setWindInfo(w.wind)
            self.setPressureInfo(pressure: w.pressure, trend: w.pressureTrend.description)
            self.setCloudCoverInfo(uvIndex: w.uvIndex, visibility: w.visibility, cloudCover: w.cloudCover)
            self.setHumidityInfo(humidity: w.humidity, dewPoint: w.dewPoint, feelsLike: w.apparentTemperature, tempUnit: TU)

            //Hourly Format
            self.setHourlyData(weather: weather, tempUnits: TU)
            simPrint("setHourlyData requested...",action:.API_Weather,log: LFFL())
            
            //Daily Format
            self.set10DayData(weather: weather, tempUnits: TU)
            simPrint("set10DayData...",action:.API_Weather,log: LFFL())
            
            //Save Data
            self.saveWeatherInfo()
            simPrint("Saved Weather info to User Defaults.", action: .API_Weather, log: LFFL())
            
            //Completion
            simPrint("Completed Fetching Weather.", action: .success, subType: .API_Weather, log: LFFL())
        }
    }
    
    func fetchCurrentWeather(lat: Double, lon: Double) async {
        if !self.isLoading {
            DispatchQueue.main.async { [self] in
                isLoading = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                Task(priority: .high) {
                    do {
                        simPrint("Fetching Weather...",action: .API_Weather,log: LFFL())
                        let weather = try await self.weatherService.weather(for: CLLocation(latitude: lat, longitude: lon))
                        setWeatherParams(weather: weather)
                        simPrint("Weather Received...",action: .success, subType: .API_Weather,log: LFFL())
                    } catch {
                        simPrint("Weather Error", action: .error, errorMsg: "error.localizedDescription", log: LFFL())
                    }//End Do/Catch
                    
                    self.isLoading = false
                }//End Task
            }
        }//End If
    }
}
