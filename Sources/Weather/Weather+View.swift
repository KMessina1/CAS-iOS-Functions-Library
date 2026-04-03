/*--------------------------------------------------------------------------------------------------------------------------
    File: Weather+View.swift
  Author: Kevin Messina
 Created: 7/9/24
Modified:
 
©2024-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import SwiftUI
import WeatherKit
import CoreLocation

public struct WeatherSharedViews: View {
    let CT = CurrentTheme().getThemeFromUserStds()
    
    //Weather Manager
    @ObservedObject var weather: WeatherVM
    
    enum DisplayStyles { case singleLineContext, cardContext, fullSize }
    @State var displayStyle: DisplayStyles
    
    var body: some View {
        VStack {
            if weather.isLoading {
                Text("Weather loading...")
            }else if weather.needsUpating() {
                VStack{
                    Spacer()
                    Text("Weather Needs Refreshing...")
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
            }else{
                switch displayStyle {
                    case .singleLineContext:
                        singleLineView
                    case .cardContext:
                        cardView
                    case .fullSize:
                        fullView
                }
            }//End If
        }//End VStack
        .tint(CT.lightest)
        .preferredColorScheme(CT.colorsForMode().mode)
    }//End Body
}
   
#Preview {
    WeatherSharedViews( weather: WeatherVM(), displayStyle: .cardContext)
}

extension WeatherSharedViews {
    func imgHasAFilledVersionOrNot(_ systemName: String) -> Image {
        if UIImage(systemName: "\(systemName).fill") != nil {
            return Image(systemName: "\(systemName).fill").symbolRenderingMode(.multicolor)
        }else{
            return Image(systemName: systemName).symbolRenderingMode(.multicolor)
            
        }
    }
    
    func smallRow(
        imgName:String,
        title:String,
        label1:String,
        value1:String,
        label2:String,
        value2:String,
        label3:String = "",
        value3:String = ""
    ) -> some View {
        HStack(alignment: .center, spacing: 10) {
            VStack(alignment: .center, spacing:0) {
                Image(systemName: imgName)
                    .resizable()
                    .scaledToFit()
                    .frame(width:40,height:20)
                    .foregroundStyle(CT.accent)
                
                Text(title)
                    .lineLimit(1)
                    .font(.system(size: 12.0, weight: .bold).smallCaps())
                    .foregroundStyle(CT.fair)
            }
            .frame(width: 40)
            
            VStack(spacing:2) {
                LabeledContent(label1, value: value1)
                LabeledContent(label2, value: value2)
            }
            .font(.system(size: 12.0, weight: .semibold))
        }
    }
    
    func largeRow(
        imgName:String,
        title:String,
        label1:String,
        value1:String,
        label2:String,
        value2:String,
        label3:String = "",
        value3:String = ""
    ) -> some View {
        HStack(alignment: .center, spacing: 20) {
            VStack(alignment: .center, spacing:0) {
                Image(systemName: imgName)
                    .resizable()
                    .scaledToFit()
                    .frame(width:90,height:40)
                    .foregroundStyle(CT.accent)
                
                Text(title)
                    .lineLimit(1)
                    .font(.system(size: 18.0, weight: .regular).smallCaps())
                    .foregroundStyle(CT.fair)
            }
            .frame(width: 90)
            .padding(.top, label3.isEmpty ?5 :8)
            
            VStack(spacing: label3.isEmpty ?15 :0) {
                LabeledContent(label1, value: value1)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                LabeledContent(label2, value: value2)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                if !label3.isEmpty {
                    LabeledContent(label3, value: value3)
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                }
            }
            .font(.system(size: 20.0, weight: .regular))
        }
        .padding(.trailing,5)
    }
    
    func largeRow_StackedDetails(
        imgName:String,
        title:String,
        label1:String,
        value1:String,
        label2:String,
        value2:String 
    ) -> some View {
        HStack(alignment: .center, spacing: 20) {
            VStack(alignment: .leading, spacing:0) {
                Image(systemName: imgName)
                    .resizable()
                    .scaledToFit()
                    .frame(width:90,height:40)
                    .foregroundStyle(CT.accent)
                
                Text(title)
                    .lineLimit(1)
                    .font(.system(size: 18.0, weight: .regular).smallCaps())
                    .foregroundStyle(CT.fair)
                    .padding(.leading,15)
            }
            .frame(width: 90)
            .padding(.top, 5)
            
            VStack(spacing: 5) {
                detailLine(label: label1, value: value1)
                detailLine(label: label2, value: value2)
            }
        }
        .font(.system(size: 20.00, weight: .regular))
        .padding(.trailing,5)
    }
    
    func detailLine(label:String,value:String) -> some View {
        VStack(spacing:0) {
            HStack {
                Text(label)
                    .font(.system(size: 12.0, weight: .bold).smallCaps())
                    .foregroundStyle(CT.fair)
                
                Spacer()
            }
            
            HStack {
                Text(value)
                    .font(.system(size: 18.0, weight: .regular))
                
                Spacer()
            }
        }
    }

    var singleLineView: some View {
        let UD = UserDefaults.standard
        let userLoc: Int = UD.integer(forKey: KeyNames.App.Calc.Location.manualLoc) // GPS =0 and User = 1
        let isUserLoc: Bool = (userLoc == 1)
        let city_User: String = UD.string(forKey: KeyNames.App.Calc.User_Address.city) ?? ""
        let state_User: String = UD.string(forKey: KeyNames.App.Calc.User_Address.state) ?? ""
        let city_GPS: String = UD.string(forKey: KeyNames.Weather.city) ?? ""
        let state_GPS: String = UD.string(forKey: KeyNames.Weather.state) ?? ""

        var cityTxt: String {
            if isUserLoc {
                return city_User.isEmpty ?"" :city_User
            } else {
                return city_GPS.lowercased() == "n/a" ?"" :city_GPS
            }
        }

        var stateTxt: String {
            if isUserLoc {
                return city_User.isEmpty ?state_User :", \(state_User)"
            } else {
                return state_GPS.lowercased() == "n/a" ?"" :state_GPS
            }
        }

        let locale: String = "\(cityTxt) \(stateTxt)".trim(.trailing)

        return VStack{
            HStack(spacing: 0) {
                Spacer()
                
                HStack {
                    imgHasAFilledVersionOrNot(weather.currentSymbolName)
                        .font(.title2)
                        .foregroundStyle(CT.lightest)

                    Text(weather.currentTemperature)
                        .padding(.trailing,5)
                        .foregroundStyle(CT.fair)

                    Text(weather.currentCondition)
                        .lineLimit(1)
                        .minimumScaleFactor(0.66)
                        .fontWeight(.light)
                        .foregroundStyle(CT.fair)
                    
                    Image(systemName: "info.bubble.fill")
                        .tint(CT.title)
                        .opacity(0.75)
                        .padding(.leading,10)
                }
                .contentShape(Rectangle())
                .contextMenu {
                    let lastUpdated = weather.asOf.formatted(date: .numeric, time: .shortened)

                    let DU: Int = UserDefaults.standard.integer(forKey: KeyNames.App.Settings.distanceUnit)
                    let isMiles = (DU == DistanceUnits.yards.rawValue)
                    let DUText = isMiles ?txt().mph :txt().km
                    
                    let windSpeed = isMiles ?weather.currentWindSpeed_MPH :weather.currentWindSpeed_KM
                    let windSpeedTxt = windSpeed.formatted(.number.precision(.fractionLength(0)))
                    let gustSpeed = isMiles ?weather.currentWindGust_MPH :weather.currentWindGust_KM
                    let gustSpeedTxt = gustSpeed.formatted(.number.precision(.fractionLength(0)))

                    VStack {
                        Label("Last Updated\n\( lastUpdated )", systemImage: "clock.arrow.circlepath")
                        Label("Temperature: \( weather.currentTemperature )\n\(weather.dailyHighLowAbbrev)", systemImage: "thermometer.medium")
                        Label("Humidity: \( weather.currentHumidity )\nDew Point: \( weather.currentDewPoint )", systemImage: "humidity.fill")
                        Label("Wind Speed: \( windSpeedTxt )\nGusts (Up to): \( gustSpeedTxt ) \( DUText )", systemImage: "wind")
                        Label("Wind Direction: \( weather.currentWindDirection )", systemImage: "safari.fill")
                        Label("Lat: \( weather.latitude )\nLon: \( weather.longitude )", systemImage: "location.square")
                        
                        Button("REFRESH\nLocation & Weather", systemImage: "arrow.clockwise", role: .destructive) {
                            DispatchQueue.main.async {
                                simPrint("WEATHER UPDATE IF NEEDED",action:.API_Weather,log: LFFL())
                                weather.updateWeatherIfNeeded(forceload: true)
                            }
                        }
                    }//End VStack
                }
                
                Spacer()
            }
            .padding(.horizontal, -20)
            .font(.title2)
            .lineLimit(1)
            .minimumScaleFactor(0.75)
            .bold()
            
            Text("for \(isUserLoc ?"User" :"Current") location: \(locale)")
                .italic()
                .font(.callout)
        }//End VStack
        .lineLimit(1)
        .minimumScaleFactor(0.75)
        .foregroundStyle(CT.accent)
        .padding(.bottom,10)
        .padding(.top,-25)
    }
    
    @ViewBuilder
    var cardView: some View {
        let myDivider1 = Divider().frame(height:1.0).overlay(CT.medium).offset(y: -2)
        let myDivider2 = Divider().frame(height:1.25).overlay(CT.accent.opacity(0.75)).offset(y: -3)

        ZStack {
            VStack(alignment : .center) {
                HStack(alignment: .top, spacing: 3) {
                    imgHasAFilledVersionOrNot(weather.currentSymbolName)
                        .font(.system(size: 25, weight: .regular))
                    
                    Text(weather.currentTemperature)
                }//End HStack
                .offset(y: 5)
                .font(.system(size: 30.0, weight: .bold))
                .foregroundStyle(CT.accent)
                
                VStack(alignment: .leading) {
                    HStack(spacing:0) {
                        Spacer()
                        
                        Text("\(weather.currentCondition)")
                            .font(.system(size: 18.0, weight: .regular))
                            .italic()
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .foregroundStyle(CT.medium)
                        
                        Spacer()
                    }
                    
                    myDivider2.offset(y: -5)
                    
                    VStack{
                        smallRow(
                            imgName: "wind",
                            title: "WIND",
                            label1: "Speed",
                            value1: weather.currentWindSpeed,
                            label2: "Gust/to",
                            value2: "\(weather.currentWindGust)"
                        )
                        
                        myDivider1
                        
                        smallRow(
                            imgName: "humidity",
                            title: "HUMID",
                            label1: "Humidity",
                            value1: weather.currentHumidity,
                            label2: "Dew Pt.",
                            value2: weather.currentDewPoint
                        )
                        
                        myDivider1
                        
                        smallRow(
                            imgName: "barometer",
                            title: "PRESS",
                            label1: "Press.",
                            value1: weather.currentPressure,
                            label2: "Trend",
                            value2: weather.currentPressureTrend
                        )
                    }//End VStack
                    .offset(y: -5)
                }//End VStack
                .padding(.horizontal,10)
                
                Spacer()
            }//End VStack
            .frame(width: .infinity)
//            .background(.red)
            
            fullScreenIconView(color: CT.fair)
        }//End ZStack
    }
    
    @ViewBuilder
    var fullView: some View {
        let myDivider1 = Divider().frame(height:1.0).overlay(CT.medium).offset(y: -2)
        let myDivider2 = Divider().frame(height:1.25).overlay(CT.accent.opacity(0.75)).offset(y: -3)
        let myDivider3 = Divider().frame(height:65)

        VStack(alignment: .center) {
            VStack(alignment: .center, spacing: 0){
                HStack{
                    Spacer()
                    
                    Label("WEATHER", systemImage: AppImages.Weather.weather)
                        .font(.system(size: 30.0, weight: .bold))
                        .underline()
                        .foregroundStyle(CT.accent)
                    
                    Spacer()
                }
                .padding(.bottom,7)
                
                HStack(alignment:.center, spacing:1) {
                    Text("Some rows scroll ")
                    
                    Image(systemName: AppImages.arrow_Left)
                        .font(.caption)
                        .foregroundStyle(.red)
                    
                    Image(systemName: AppImages.arrow_Right)
                        .font(.caption)
                        .foregroundStyle(.red)
                    
                    Text(" if needed.")
                }
                .foregroundStyle(CT.fair)
            }
            .padding(.top,6)
            .padding(.bottom,20)
            
            HStack(spacing: 10) {
                imgHasAFilledVersionOrNot(weather.currentSymbolName)
                    .font(.system(size: 30, weight: .regular))
                
                HStack (spacing:1) {
                    Text(weather.currentTemperature.dropLast(1))
                    
                    Text("℉") //Text("℃")
                        .font(.system(size: 24.0, weight: .semibold))
                        .foregroundStyle(CT.light)
                        .offset(y: -5)
                }
                
                HStack (spacing:1) {
                    Text("{")
                        .padding(.top, -5)
                        .font(.system(size: 40.0, weight: .light))
                    
                    VStack {
                        let asOfDate = Calendar.current.isDateInToday(weather.asOf)
                        ? "TODAY @"
                        : weather.asOf.formattedAs(displayDateFormat)
                        
                        Text(asOfDate)
                        Text(weather.asOf.formattedAs(displayDateFormat_Time))
                    }
                    .font(.system(size: 16.0, weight: .regular))
                    .foregroundStyle(CT.light)
                    
                    Text("}")
                        .padding(.top, -5)
                        .font(.system(size: 40.0, weight: .light))
                }
                
                Button(action: {
                    DispatchQueue.main.async {
                        simPrint("WEATHER UPDATE IF NEEDED",action:.API_Weather,log: LFFL())
                        weather.updateWeatherIfNeeded(forceload: true)
                    }
                }, label: {
                    VStack{
                        Image(systemName: AppImages.refresh)
                            .resizable()
                            .scaledToFit()
                    }
                })
                .foregroundStyle(CT.lightest)
                .tint(CT.accent)
                .frame(width:40, height:40)
                .padding(.leading,20)
                .buttonStyle(BorderedProminentButtonStyle())
            }//End HStack
            .font(.system(size: 40.0, weight: .bold))
            .foregroundStyle(CT.accent)
            .padding(.bottom,1)
            
            HStack(spacing:0) {
                Spacer()
                
                Text("Currently \(weather.currentCondition)")
                    .font(.system(size: 24.0, weight: .regular))
                    .italic()
                    .lineLimit(1)
                    .foregroundStyle(CT.fair)
                    .padding(.bottom,2)
                
                Spacer()
            }//End HStack
        }//End VStack
        
        myDivider2
        
        ScrollView {
            largeRow(
                imgName:"thermometer.variable.and.figure",
                title:"TEMPS",
                label1:"Feels Like",
                value1:weather.feelsLike,
                label2:"Today's High",
                value2:weather.currentHighTemp,
                label3:"Today's Low",
                value3:weather.currentLowTemp
            )
            
            myDivider1
            
            largeRow(
                imgName:"humidity",
                title:"HUMIDITY",
                label1:"Humidity Level",
                value1:weather.currentHumidity,
                label2:"Dew Point",
                value2:weather.currentDewPoint
            )
            
            myDivider1
            
            largeRow(
                imgName:"wind",
                title:"WIND",
                label1:"Speed",
                value1:weather.currentWindSpeed,
                label2:"Direction",
                value2:"\(weather.currentWindDirImg) \(weather.currentWindDirectionAbbrev)",
                label3:"Gusts (Up to)",
                value3:" \(weather.currentWindGust)"
            )
            
            myDivider1
            
            largeRow(
                imgName:"barometer",
                title:"Pressure",
                label1:"Sea-Level",
                value1:weather.currentPressure,
                label2:"State",
                value2:weather.currentPressureTrendingState,
                label3:"Trending",
                value3:weather.currentPressureTrend
            )
            
            myDivider1
            
            largeRow(
                imgName:"cloud.sleet.fill",
                title:"PRECIP",
                label1:"Preciptitation",
                value1:weather.currentPrecipitation,
                label2:"Within Hour?",
                value2:weather.currentPrecipChance,
                label3:"Amount",
                value3:weather.currentPrecipAmt
            )
            
            myDivider1
            
            largeRow(
                imgName:"sun.max.trianglebadge.exclamationmark.fill",
                title:"CONDITION",
                label1:"U/V Index",
                value1:"\(weather.currentUVIndex)-\(weather.currentUVExposure)",
                label2:"Visibility",
                value2:weather.currentVisibility,
                label3:"Cloud Cover",
                value3:weather.currentCloudcover
            )
            
            myDivider1
            
            largeRow(
                imgName:"sun.horizon.fill",
                title:"Daylight",
                label1:"Sunrise",
                value1:"\(weather.currentSunrise.formattedAs(displayDateFormat_Time))",
                label2:"Sunset",
                value2:"\(weather.currentSunset.formattedAs(displayDateFormat_Time))"
            )
            
            myDivider1
            
            largeRow(
                imgName:"location",
                title:"Location",
                label1:"Lat",
                value1:"\(weather.latitude)",
                label2:"Lon",
                value2:"\(weather.longitude)",
                label3:"Elev/Sea Level",
                value3:"\( weather.elevation.convert_m_feet.formatted(.number.precision(.fractionLength(2))) ) ft"
            )
            
            myDivider1
            
            VStack(alignment: .leading, spacing: 0) {
                Label("24-Hour Forecast".uppercased(), systemImage: "clock")
                    .font(.system(size: 18.0, weight: .regular).smallCaps())
                    .padding(.leading, 10)
                    .padding(.bottom, 1)
                    .foregroundStyle(CT.accent)
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(weather.hourlyForecast, id: \.time) { weather in
                            VStack(spacing: 3) {
                                Text(weather.time)
                                    .font(.system(size: 16.0, weight: .bold))
                                    .foregroundStyle(CT.fair)
                                
                                imgHasAFilledVersionOrNot(weather.symbolName)
                                    .resizable()
                                    .frame(width: 35, height: 30)
                                    .symbolRenderingMode(.multicolor)
                                    .aspectRatio(contentMode: .fit)
                                
                                Text(weather.temperature)
                                    .font(.system(size: 18.0, weight: .bold))
                            }
                            .padding(.horizontal,5)
                            
                            myDivider3
                        }
                    }
                    .padding(.all,5)
                }
            }//24-Hour
            .font(.body)
            
            myDivider1
            
            VStack(alignment: .leading, spacing: 0) {
                Label("10-Day Forecast".uppercased(), systemImage: "calendar")
                    .font(.system(size: 18.0, weight: .regular).smallCaps())
                    .padding(.leading, 10)
                    .padding(.bottom, 1)
                    .foregroundStyle(CT.accent)
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(weather.tenDayForecast, id: \.day) { weather in
                            VStack(spacing: 3) {
                                Text(weather.day)
                                    .font(.system(size: 16.0, weight: .bold))
                                    .foregroundStyle(CT.fair)
                                
                                imgHasAFilledVersionOrNot(weather.symbolName)
                                    .resizable()
                                    .frame(width: 35, height: 30)
                                    .symbolRenderingMode(.multicolor)
                                    .aspectRatio(contentMode: .fit)
                                
                                Text("\( weather.highTemperature )°/\( weather.lowTemperature )°")
                                    .font(.system(size: 16.0, weight: .bold))
                            }
                            .padding(.horizontal,5)
                            
                            myDivider3
                        }
                    }
                    .padding(.all,5)
                }
            }//10-Day
            .font(.body)
        }//End ScrollView
    }
}
