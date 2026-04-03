/*--------------------------------------------------------------------------------------------------------------------------
    File: CAS_Alert-ColorExtension.swift
  Author: Kevin Messina
 Created: May 22, 2022
Modified:
 
©2022-2023 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
 
--------------------------------------------------------------------------------------------------------------------------*/

import Foundation
import SwiftUI

// MARK: - *** Color Extension ***
extension Color {
    /// Converts a Color to UIColor type
    var toUIColor:UIColor {
        return UIColor(self)
    }
    
    func uiColor() -> UIColor {
        let components = self.components()
        return UIColor(red: components.r, green: components.g, blue: components.b, alpha: components.a)
    }
        
    func components() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        let scanner = Scanner(string: self.description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0
        
        let result = scanner.scanHexInt64(&hexNumber)
        if result {
            r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
            g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            a = CGFloat(hexNumber & 0x000000ff) / 255
        }
        return (r, g, b, a)
    }
        
//    var convertToData:Data {
//        return UIColor(self).convertToData
//    }
        
    init(hex: String) {
        self.init(hex: hex, alpha:1)
    }
    
    init(hex: String, alpha: Double? = 1) {
        var hexWithoutSymbol = hex
        if hexWithoutSymbol.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let end = hex.endIndex
            
            hexWithoutSymbol = String(hex[start..<end])
        }
        
        let scanner = Scanner(string: hexWithoutSymbol)
        var hexInt:UInt64 = 0x0
        scanner.scanHexInt64(&hexInt)
        
        var r:UInt64!, g:UInt64!, b:UInt64!
        switch (hexWithoutSymbol.count) {
            case 3: // #RGB
                r = ((hexInt >> 4) & 0xf0 | (hexInt >> 8) & 0x0f)
                g = ((hexInt >> 0) & 0xf0 | (hexInt >> 4) & 0x0f)
                b = ((hexInt << 4) & 0xf0 | hexInt & 0x0f)
                break;
            case 6: // #RRGGBB
                r = (hexInt >> 16) & 0xff
                g = (hexInt >> 8) & 0xff
                b = hexInt & 0xff
                break;
            default:
                break;
        }
        
        self.init(
            red: (Double(r!)/255),
            green: (Double(g!)/255),
            blue: (Double(b!)/255),
            opacity: alpha!
        )
    }

    struct Alert {
        struct colorRecord {
            let id:UUID = UUID()
            let Indx:Int
            let Name:String
            let Hex:String
            let Color:Color
        }

        static let cancel           = colorRecord(Indx: 3, Name: "alerts_cancel", Hex: "#8E8E94",Color:Color(hex:"#8E8E94"))
        static let confirm          = colorRecord(Indx: 1, Name: "alerts_confirm", Hex: "#D52837",Color:Color(hex:"#D52837"))
        static let confirm2         = colorRecord(Indx: 2, Name: "alerts_confirm2", Hex: "#800040",Color:Color(hex:"#800040"))
        static let construction     = colorRecord(Indx: 4, Name: "alerts_construction", Hex: "#FF9401",Color:Color(hex:"#FF9401"))
        static let edit             = colorRecord(Indx: 5, Name: "alerts_edit", Hex: "#7BB4D2",Color:Color(hex:"#7BB4D2"))
        static let error            = colorRecord(Indx: 6, Name: "alerts_error", Hex: "#FE3A2F",Color:Color(hex:"#FE3A2F"))
        static let info             = colorRecord(Indx: 7, Name: "alerts_info", Hex: "#011892",Color:Color(hex:"#011892"))
        static let IAP              = colorRecord(Indx: 8, Name: "alerts_IAP", Hex: "#346900",Color:Color(hex:"#346900"))
        static let notice           = colorRecord(Indx: 10, Name: "alerts_notice", Hex: "#4071FB",Color:Color(hex:"#4071FB"))
        static let notAvail         = colorRecord(Indx: 9, Name: "alerts_notAvail", Hex: "#004080",Color:Color(hex:"#004080"))
        static let success          = colorRecord(Indx: 11, Name: "alerts_success", Hex: "#1AA58D",Color:Color(hex:"#1AA58D"))
        static let text             = colorRecord(Indx: 12, Name: "alerts_text", Hex: "#FFFFFF",Color:Color(hex:"#FFFFFF"))
        static let wait             = colorRecord(Indx: 13, Name: "alerts_wait", Hex: "#FFD478",Color:Color(hex:"#FFD478"))
        static let warning          = colorRecord(Indx: 14, Name: "alerts_warning", Hex: "#FFCC01",Color:Color(hex:"#FFCC01"))

        let arrAlertImgs:[colorRecord] = [
            cancel,confirm,confirm2,construction,edit,error,info,IAP,notice,notAvail,success,text,wait,warning
        ]
        
        func getColorNamed(_ name:String) -> Color {
            if let filteredItem = arrAlertImgs.filter({ $0.Name == name }).first {
                return filteredItem.Color
            } else {
                simPrint(type: .error, msg: "Error loading finding array element named: \(name)", log: logFileFunctionLine())
                return .black
            }
        }
    }
}
