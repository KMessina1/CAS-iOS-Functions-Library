/*--------------------------------------------------------------------------------------------------------------------------
    File: sharedConstants.swift
  Author: Kevin Messina
 Created: Oct 15, 2019
Modified:

©2019-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:

2025/08/02- Added Global Constants
2024_10_29- Added DeviceIs for Orientation.
2019_10_15- Converted to Swift 5.1 on Oct. 15, 2019
--------------------------------------------------------------------------------------------------------------------------*/

import Foundation
import UIKit


// MARK: - *** GLOBAL CONSTANTS ***
let allItemsText: String = "ALL ITEMS"
let notSelectedText: String = "Not Selected"
let unselectedText: String = "-- Unselected --"
let dashesTxt: String = "--"
let NotApplicableText: String = "* Not Applicable *"
let displayDateFormat = Date.formats.MMM_d_yyyy
let displayDateFormat_Short = Date.formats.MMddyy
let displayDateFormat_Time_Short = Date.formats.h_mm_a
let displayDateFormat_Time = Date.formats.h_mm_ss_a
let recordDateFormat = Date.formats.yyyyMMdd
let fileDateFormat = "yyyyMMdd@HHmmss_SSS"

enum FractionTypes: Int, CaseIterable, Identifiable {
    case f0_16
    case f1_16
    case f1_8
    case f3_16
    case f1_4
    case f5_16
    case f3_8
    case f7_16
    case f1_2
    case f9_16
    case f5_8
    case f11_16
    case f3_4
    case f13_16
    case f7_8
    case f15_16
    
    var id: Int { self.rawValue }
    
    static let arr: [String] = [
        f0_16.displayCode,f1_16.displayCode,f1_8.displayCode,f3_16.displayCode,f1_4.displayCode,f5_16.displayCode,
        f3_8.displayCode,f7_16.displayCode,f1_2.displayCode,f9_16.displayCode,f5_8.displayCode,f11_16.displayCode,
        f3_4.displayCode,f13_16.displayCode,f7_8.displayCode,f15_16.displayCode
    ]
    
    var displayCode: String {
        switch self {
            case .f0_16: return "0"
            case .f1_16: return "1/16"
            case .f1_8: return "1/8"
            case .f3_16: return "3/16"
            case .f1_4: return "1/4"
            case .f5_16: return "5/16"
            case .f3_8: return "3/8"
            case .f7_16: return "7/16"
            case .f1_2: return "1/2"
            case .f9_16: return "9/16"
            case .f5_8: return "5/8"
            case .f11_16: return "11/16"
            case .f3_4: return "3/4"
            case .f13_16: return "13/16"
            case .f7_8: return "7/8"
            case .f15_16: return "15/16"
        }
    }

    var fractionValue: Double {
        var newVal: Double = 0.0
        
        switch self {
            case .f0_16: newVal =  0.0000
            case .f1_16: newVal =  0.0625
            case .f1_8: newVal =  0.1250
            case .f3_16: newVal =  0.1875
            case .f1_4: newVal =  0.2500
            case .f5_16: newVal =  0.3125
            case .f3_8: newVal =  0.3750
            case .f7_16: newVal =  0.4375
            case .f1_2: newVal =  0.5000
            case .f9_16: newVal =  0.5625
            case .f5_8: newVal =  0.6250
            case .f11_16: newVal =  0.6875
            case .f3_4: newVal =  0.7500
            case .f13_16: newVal =  0.8125
            case .f7_8: newVal =  0.8750
            case .f15_16: newVal = 0.9375
        }
        
        return newVal
    }
}

func getFractionChar(inputVal: Double) -> FractionTypes {
    let fraction = modf(inputVal).1
    
    switch fraction {
        case ..<0.0625: return .f0_16
        case ..<0.1250: return .f1_16
        case ..<0.1875: return .f1_8
        case ..<0.2500: return .f3_16
        case ..<0.3125: return .f1_4
        case ..<0.3750: return .f5_16
        case ..<0.4375: return .f3_8
        case ..<0.5000: return .f7_16
        case ..<0.5625: return .f1_2
        case ..<0.6250: return .f9_16
        case ..<0.6875: return .f5_8
        case ..<0.7500: return .f11_16
        case ..<0.8125: return .f3_4
        case ..<0.8750: return .f13_16
        case ..<0.9375: return .f7_8
        case ..<1.0000: return .f5_16
        default: return .f0_16
    }
}

func getFractionTypeFromString(_ inputVal: String) -> FractionTypes {
    switch inputVal {
        case "1/16": return .f1_16
        case "1/8": return .f1_8
        case "3/16": return .f3_16
        case "1/4": return .f1_4
        case "5/16": return .f5_16
        case "3/8": return .f3_8
        case "7/16": return .f7_16
        case "1/2": return .f1_2
        case "9/16": return .f9_16
        case "5/8": return .f5_8
        case "11/16": return .f11_16
        case "3/4": return .f3_4
        case "13/16": return .f13_16
        case "7/8": return .f7_8
        case "15/16": return .f15_16
        default: return .f0_16
    }
}

// MARK: - *** DEVICE IS CONSTANTS ***
struct deviceIs {
    // display Preview
    
    static var Sim: Bool {
#if targetEnvironment(simulator)
            return true
#else
            return false
#endif
    }
    
    static let CanvasPreview = Bool(ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1")
    // device Mode
    static let Pad: Bool = Bool(UIDevice.current.userInterfaceIdiom == .pad)
    static let Phone: Bool = Bool(UIDevice.current.userInterfaceIdiom == .phone)
    static let Mac: Bool = Bool(UIDevice.current.userInterfaceIdiom == .mac)
    static let TV: Bool = Bool(UIDevice.current.userInterfaceIdiom == .tv)
    static let Car: Bool = Bool(UIDevice.current.userInterfaceIdiom == .carPlay)
    static let Reality: Bool = Bool(UIDevice.current.userInterfaceIdiom == .vision)
    static let Unspecified: Bool = Bool(UIDevice.current.userInterfaceIdiom == .unspecified)
    // device Orientation
    var Portrait: Bool = Bool(UIDevice.current.orientation.isPortrait)
    var Landscape: Bool = Bool(UIDevice.current.orientation.isLandscape)
    var PadLandscape: Bool = (Bool(UIDevice.current.userInterfaceIdiom == .pad) && Bool(UIDevice.current.orientation.isLandscape))

    enum deviceTypeEnum:String {
        case Sim = "Sim"
        case CanvasPreview = "Preview"
        case Pad = "iPad"
        case Phone = "iPhone"
        case TV = "TV"
        case Car = "Car"
        case Unspecified = "Unspecified"
        case Mac = "Mac"
        case Reality = "Reality"
    }
    
    func deviceType() -> deviceTypeEnum {
        if deviceIs.Sim { return .Sim }
        else if deviceIs.CanvasPreview { return .CanvasPreview }
        else if deviceIs.Pad { return .Pad }
        else if deviceIs.Phone { return .Phone }
        else if deviceIs.TV { return .TV }
        else if deviceIs.Car { return .Car }
        else { return .Unspecified }
    }
    
    func runningOS() -> (name:String,versionStr:String,versionNum:Double,full:String) {
        let systemVersion = UIDevice.current.systemVersion
        let systemVersionNum = Double(systemVersion) ?? 0.0
        let systemName = UIDevice.current.systemName
        let full = "\(systemName) \(systemVersion)"
        return (systemName,systemVersion,systemVersionNum,full)
    }
    
    func named() -> String {
        let name = UIDevice.current.name
        return name
    }

    func DeviceFamily() -> (family:String,model:String) {
        let family = UIDevice.current.model
        let name = UIDevice.current.name
        return (family,name)
    }
    
    /// 1.0 is fully charged, 0.0 is fully depleted.
    func batteryRemaining() -> (full:String,value:Float) {
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        let batteryRemaining = abs(UIDevice.current.batteryLevel) * 100
        let batteryRemainingStr = "\( batteryRemaining )%"

        UIDevice.current.isBatteryMonitoringEnabled = false

        return (batteryRemainingStr, batteryRemaining)
    }
}

// MARK: - *** CHAR SETS ***
/// Character sets (Valid for comparison/usage)
public struct acceptableCharSets {
    static let allChars:String      = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 '-/:;()$&@.,?![]{}#%^*+=_|~<>\""
    static let alpha:String         = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz " // Has space char
    static let alphaOnly:String     = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    static let currency_US:String   = "0123456789.-$¢"
    static let numbersOnly:String   = "0123456789"
    static let numeric:String       = "0123456789-"
    static let decimal:String       = "0123456789."
    static let decimalPad:String    = "0123456789.-"
    static let dateOnly:String      = "0123456789/"
    static let alphaNumeric:String  = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
    static let emailAddress:String  = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz 0123456789!#$%&'*+-/=?^_`{|}~"
    static let tableIndex:String    = "*0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    
    struct tableSectionTitles {
        static let alpha:String        = "ABCDEFGHIJKLMNOPQRSTUVWXYZ "
        static let alphaNumeric:String = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ "
        static let tableIndex:String   = "*0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    }
    
    struct SQL {
        static let CR = "\n"
        static let TAB = "\t"
        static let LR = "\r"
        static let LRCR = "\r\n"
        static let doubleApostrophes = "''"
        static let doubleBackSlashes = "\\"
        static let doubleQuotes = "\"\""
        static let quotes = "\""
    }
}


// MARK: - *** HTML TYPES ***
/// HTML MIME Types
public struct HTML {
    static let boundary = "---------------------------14737809831466499882746641449"

    struct formatting {
        static let bold = "<b>"
        static let unbold = "</b>"
        static let italic = "<i>"
        static let unitalic = "</i>"
        static let lineFeed = "</br>"
        static let lineFeed1 = "</br>"
        static let lineFeed2 = "</br></br>"
        static let lineFeed3 = "</br></br></br>"
    }
    
    struct MimeTypes {
        enum MimeTypeValues { case csv,img_JPG,img_PNG,pdf,text,zipArchive }

        static let CSV:String!          = "text/csv"
        static let Img_JPG:String!      = "image/jpeg"
        static let Img_PNG:String!      = "image/png"
        static let PDF:String!          = "application/pdf"
        static let Text:String!         = "text/csv"
        static let ZipArchive:String!   = "application/zip"
    }
}


// MARK: - *** HTTP ***
public func statusCodes_HTTP(_ code:Int) -> String {
    switch code {
        case 100: return "Continue"
        case 101: return "Switching Protocols"
        
        case 200: return "OK"
        case 201: return "Created"
        case 202: return "Accepted"
        case 203: return "Non-Authoritative Information"
        case 204: return "No Content"
        case 205: return "Reset Content"
        case 206: return "Partial Content"
        
        case 300: return "Multiple Choices"
        case 301: return "Moved Permanently"
        case 302: return "Moved Temporarily"
        case 303: return "See Other"
        case 304: return "Not Modified"
        case 305: return "Use Proxy"
        
        case 400: return "Bad Request"
        case 401: return "Unauthorized"
        case 402: return "Payment Required"
        case 403: return "Forbidden"
        case 404: return "Not Found"
        case 405: return "Method Not Allowed"
        case 406: return "Not Acceptable"
        case 407: return "Proxy Authentication Required"
        case 408: return "Request Time-out"
        case 409: return "Conflict"
        case 410: return "Gone"
        case 411: return "Length Required"
        case 412: return "Precondition Failed?"
        case 413: return "Request Entity Too Large"
        case 414: return "Request-URI Too Large"
        case 415: return "Unsupported Media Type"
        
        case 500: return "Internal Server Error"
        case 501: return "Not Implemented"
        case 502: return "Bad Gateway"
        case 503: return "Service Unavailable"
        case 504: return "Gateway Time-out"
        case 505: return "HTTP Version not supported"
        
        default: return "Unknown status code \(code) returned."
    }
}


// MARK: - *** LANGUAGES ***
/// SPPORTED LANGUAGES Constants
public struct Languages {
    static let arabic:String!               = "ar"
    static let chinese_simplified:String!   = "zh-hans"
    static let english:String!              = "en"
    static let french:String!               = "fr"
    static let hindi:String!                = "hi"
    static let italian:String!              = "it"
    static let japanese:String!             = "ja"
    static let portuguese:String!           = "pt"
    static let russian:String!              = "ru"
    static let spanish:String!              = "es"
}

// MARK: - *** MAPPING ***
/// MAPPING Constants
public struct Mapping {
    struct Types {
        static let standard:Int  = 0
        static let satellite:Int = 1
        static let hybrid:Int    = 2
    }
    
    struct ZoomTo {
        static let pin       = 0.0025
        static let area      = 0.05
        static let region    = 0.9
        static let country   = 35.0
    }
}



