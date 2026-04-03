
/*--------------------------------------------------------------------------------------------------------------------------
    File: ext_UIDevice.swift
  Author: Kevin Messina
 Created: 2/6/22
Modified:
 
©2022-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import Foundation
import UIKit

// MARK: - *** UIDevice extensions ***
public extension UIDevice {
    var physicalMemoryInGB: UInt64 {
        return (ProcessInfo().physicalMemory / 1024) // in GB
    }
    
    var physicalMemoryInMB: UInt64 {
        return physicalMemoryInGB / 1024 // in MB
    }
    
    func remainingFreeSpaceInGB() -> Int64 {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        guard
            let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: documentDirectory),
            let freeSize = systemAttributes[.systemFreeSize] as? NSNumber
        else {
            return 0
        }
        return (freeSize.int64Value / 1024) // in GB
    }

    func remainingFreeSpaceInMB() -> Int64 {
        return remainingFreeSpaceInGB() / 1024
    }

    static var isZoomed: Bool { UIScreen().isZoomed }
    
    struct Family {
        // environment Mode
        static var isPreview: Bool { Bool(ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1") }
#if targetEnvironment(simulator)
        static let isSim = Bool(ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1") ?false :true
#else
        static let isSim = false
#endif
        static var isPrevOrSim: Bool { (isPreview || isSim) }

        func environmentIs() -> String {
            if UIDevice.Family.isPreview {
                return "Xcode Preview/Canvas"
            }else if UIDevice.Family.isSim {
                return "Simulator"
            }else {
                return "Device"
            }
        }
//        static let isSim = Bool(TARGET_IPHONE_SIMULATOR == 1)
        
        // device Mode
        static var isPad: Bool { UIDevice.current.userInterfaceIdiom == .pad }
        static var isPhone: Bool { UIDevice.current.userInterfaceIdiom == .phone }
        static var isMac: Bool { UIDevice.current.userInterfaceIdiom == .mac }
        static var isTV: Bool { UIDevice.current.userInterfaceIdiom == .tv }
        static var isCar: Bool { UIDevice.current.userInterfaceIdiom == .carPlay }
        static var isVision: Bool { UIDevice.current.userInterfaceIdiom == .vision }
        
        func typeIs() -> String {
            switch UIDevice.current.userInterfaceIdiom {
                case .pad: return "iPad"
                case .phone: return "iPhone"
                case .carPlay: return "CarPlay"
                case .mac: return "Mac"
                case .vision: return "Vision"
                case .tv: return "TV"
                case .unspecified: return "Unspecified"
                @unknown default:
                    return "Unknown"
            }
        }
    }
    
    struct DiskStatus {
        //MARK: Formatter MB only
        func MBFormatter(_ bytes: Int64) -> String {
            let formatter = ByteCountFormatter()
            formatter.allowedUnits = ByteCountFormatter.Units.useMB
            formatter.countStyle = ByteCountFormatter.CountStyle.decimal
            formatter.includesUnit = false
            
            return formatter.string(fromByteCount: bytes) as String
        }
        
        //MARK: Get String Value
        var totalDiskSpace:String { ByteCountFormatter.string(fromByteCount: totalDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.file) }
        var freeDiskSpace:String { ByteCountFormatter.string(fromByteCount: freeDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.file) }
        var usedDiskSpace:String { ByteCountFormatter.string(fromByteCount: usedDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.file) }
        
        //MARK: Get raw value
        var totalDiskSpaceInBytes:Int64 {
            do {
                let systemAttributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String)
                let space = (systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.int64Value
                return space!
            } catch {
                return 0
            }
        }
        
        var freeDiskSpaceInBytes:Int64 {
            do {
                let systemAttributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String)
                let freeSpace = (systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.int64Value
                return freeSpace!
            } catch {
                return 0
            }
        }
         
        var usedDiskSpaceInBytes:Int64 { totalDiskSpaceInBytes - freeDiskSpaceInBytes }
    }
    
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String {
#if os(iOS)
            switch identifier {
// == iPods ==
                case "iPod5,1":                                       return "iPod touch (5th generation)"
                case "iPod7,1":                                       return "iPod touch (6th generation)"
                case "iPod9,1":                                       return "iPod touch (7th generation)"
// == iPhones ==
                // iPhone 4
                case "iPhone3,1", "iPhone3,2", "iPhone3,3":           return "iPhone 4"
                case "iPhone4,1":                                     return "iPhone 4s"
                // iPhone 5
                case "iPhone5,1", "iPhone5,2":                        return "iPhone 5"
                case "iPhone5,3", "iPhone5,4":                        return "iPhone 5c"
                case "iPhone6,1", "iPhone6,2":                        return "iPhone 5s"
                // iPhone 6
                case "iPhone7,2":                                     return "iPhone 6"
                case "iPhone7,1":                                     return "iPhone 6 Plus"
                case "iPhone8,1":                                     return "iPhone 6s"
                case "iPhone8,2":                                     return "iPhone 6s Plus"
                // iPhone 7
                case "iPhone8,4":                                     return "iPhone SE"
                case "iPhone9,1", "iPhone9,3":                        return "iPhone 7"
                case "iPhone9,2", "iPhone9,4":                        return "iPhone 7 Plus"
                // iPhone 8
                case "iPhone10,1", "iPhone10,4":                      return "iPhone 8"
                case "iPhone10,2", "iPhone10,5":                      return "iPhone 8 Plus"
                // iPhone 10 aka X
                case "iPhone10,3", "iPhone10,6":                      return "iPhone X"
                case "iPhone11,2":                                    return "iPhone XS"
                case "iPhone11,4", "iPhone11,6":                      return "iPhone XS Max"
                case "iPhone11,8":                                    return "iPhone XR"
                // iPhone 11
                case "iPhone12,1":                                    return "iPhone 11"
                case "iPhone12,3":                                    return "iPhone 11 Pro"
                case "iPhone12,5":                                    return "iPhone 11 Pro Max"
                case "iPhone12,8":                                    return "iPhone SE (2nd generation)"
                // iPhone 12
                case "iPhone13,1":                                    return "iPhone 12 mini"
                case "iPhone13,2":                                    return "iPhone 12"
                case "iPhone13,3":                                    return "iPhone 12 Pro"
                case "iPhone13,4":                                    return "iPhone 12 Pro Max"
                // iPhone 13
                case "iPhone14,4":                                    return "iPhone 13 mini"
                case "iPhone14,5":                                    return "iPhone 13"
                case "iPhone14,2":                                    return "iPhone 13 Pro"
                case "iPhone14,3":                                    return "iPhone 13 Pro Max"
                // iPhone 14
                case "iPhone14,6":                                    return "SE (3rd generation)"
                case "iPhone14,7":                                    return "iPhone 14"
                case "iPhone14,8":                                    return "iPhone 14 Plus"
                case "iPhone15,2":                                    return "iPhone 14 Pro"
                case "iPhone15,3":                                    return "iPhone 14 Pro Max"
                // iPhone 15
                case "iPhone15,4":                                    return "iPhone 15"
                case "iPhone15,5":                                    return "iPhone 15 Plus"
                case "iPhone16,1":                                    return "iPhone 15 Pro"
                case "iPhone16,2":                                    return "iPhone 15 Pro Max"
// == iPads ==
                case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":      return "iPad 2"
                case "iPad3,1", "iPad3,2", "iPad3,3":                 return "iPad (3rd generation)"
                case "iPad3,4", "iPad3,5", "iPad3,6":                 return "iPad (4th generation)"
                case "iPad6,11", "iPad6,12":                          return "iPad (5th generation)"
                case "iPad7,5", "iPad7,6":                            return "iPad (6th generation)"
                case "iPad7,11", "iPad7,12":                          return "iPad (7th generation)"
                case "iPad11,6", "iPad11,7":                          return "iPad (8th generation)"
                case "iPad12,1", "iPad12,2":                          return "iPad (9th generation)"
                case "iPad13,18", "iPad13,19":                        return "iPad (10th generation)"
                // iPad Air
                case "iPad4,1", "iPad4,2", "iPad4,3":                 return "iPad Air"
                case "iPad5,3", "iPad5,4":                            return "iPad Air 2"
                case "iPad11,3", "iPad11,4":                          return "iPad Air (3rd generation)"
                case "iPad13,1", "iPad13,2":                          return "iPad Air (4th generation)"
                case "iPad13,16", "iPad13,17":                        return "iPad Air (5th generation)"
                // iPad Mini
                case "iPad2,5", "iPad2,6", "iPad2,7":                 return "iPad mini"
                case "iPad4,4", "iPad4,5", "iPad4,6":                 return "iPad mini 2"
                case "iPad4,7", "iPad4,8", "iPad4,9":                 return "iPad mini 3"
                case "iPad5,1", "iPad5,2":                            return "iPad mini 4"
                case "iPad11,1", "iPad11,2":                          return "iPad mini (5th generation)"
                case "iPad14,1", "iPad14,2":                          return "iPad mini (6th generation)"
                // iPad Pro (9.7")
                case "iPad6,3", "iPad6,4":                            return "iPad Pro (9.7-inch)"
                // iPad Pro (10.5")
                case "iPad7,3", "iPad7,4":                              return "iPad Pro (10.5-inch)"
                // iPad Pro (11")
                case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":        return "iPad Pro (11-inch) (1st generation)"
                case "iPad8,9", "iPad8,10":                             return "iPad Pro (11-inch) (2nd generation)"
                case "iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7":    return "iPad Pro (11-inch) (3rd generation)"
                case "iPad14,3", "iPad14,4":                            return "iPad Pro (11-inch) (4th generation)"
                // iPad Pro 12.9"
                case "iPad6,7", "iPad6,8":                              return "iPad Pro (12.9-inch) (1st generation)"
                case "iPad7,1", "iPad7,2":                              return "iPad Pro (12.9-inch) (2nd generation)"
                case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":        return "iPad Pro (12.9-inch) (3rd generation)"
                case "iPad8,11", "iPad8,12":                            return "iPad Pro (12.9-inch) (4th generation)"
                case "iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11":  return "iPad Pro (12.9-inch) (5th generation)"
                case "iPad14,5", "iPad14,6":                            return "iPad Pro (12.9-inch) (6th generation)"
// == TV ==
                case "AppleTV1,1":                                    return "Apple TV 1gen"
                case "AppleTV2,1":                                    return "Apple TV 2gen"
                case "AppleTV3,1":                                    return "Apple TV 3gen"
                case "AppleTV3,2":                                    return "Apple TV 3gen"
                case "AppleTV5,3":                                    return "Apple TV 4gen"
                case "AppleTV6,2":                                    return "Apple TV 4K 1gen"
                case "AppleTV11,1":                                   return "Apple TV 4K 2gen"
// == Audio Accessories ==
                case "AudioAccessory1,1","AudioAccessory1,2":         return "HomePod"
                case "AudioAccessory5,1":                             return "HomePod mini"
// == Mac ==
                //Mac Mini
                case "PowerMac10,1":     return "Mac Mini (early 2005)"
                case "PowerMac10,2":     return "Mac Mini (late 2005)"
                case "Macmini1,1":       return "Mac Mini (2006)"
                case "Macmini2,1":       return "Mac Mini (2007)"
                case "Macmini3,1":       return "Mac Mini (2009)"
                case "Macmini4,1":       return "Mac Mini (2010)"
                case "Macmini5,1":       return "Mac Mini (2011)"
                case "Macmini5,2":       return "Mac Mini (2011)"
                case "Macmini5,3":       return "Mac Mini (2011)"
                case "Macmini6,1":       return "Mac Mini (2012)"
                case "Macmini6,2":       return "Mac Mini (2012)"
                case "Macmini7,1":       return "Mac Mini (2014)"
                case "Macmini8,1":       return "Mac Mini (2018)"
                case "Macmini9,1":       return "Mac Mini M1 (2020)"
                case "Mac14,3":          return "Mac Mini M2 (2023)"
                case "Mac14,12":         return "Mac Mini M2 Pro (2023)"
                //Mac Studio
                case "Mac13,1":          return "Mac Studio M1 Max)"
                case "Mac13,2":          return "Mac Studio M1 Ultra)"
                case "Mac14,13":         return "Mac Studio M2 Max)"
                case "Mac14,14":         return "Mac Studio M2 Ultra)"
                //iMac
                case "iMac,1":           return "iMac G3 (1998)"
                case "PowerMac2,1":      return "iMac G3 (Slot Loading)"
                case "PowerMac2,2":      return "iMac G3 (2000)"
                case "PowerMac4,1":      return "iMac G3 (2001)"
                case "PowerMac4,2":      return "iMac G4 15\" (2002)"
                case "PowerMac4,5":      return "iMac G4 17\" (2002)"
                case "PowerMac6,1":      return "iMac G4 17\" (2003)"
                case "PowerMac6,2":      return "iMac G4 USB 2.0"
                case "PowerMac8,1":      return "iMac G5"
                case "PowerMac8,2":      return "iMac G5 (Ambient Light Sensor)"
                case "PowerMac12,1":     return "iMac G5 20\" (iSight)"
                case "iMac4,1":          return "iMac (early 2006)"
                case "iMac4,2":          return "iMac (mid 2006)"

                case "Mac21,1":          return "iMac (4-Ports)"
                case "Mac21,3":          return "iMac (2-Ports)"
                case "Mac15,4":          return "iMac (2-Ports)"
                case "Mac15,5":          return "iMac (4-Ports)"
                //XCode Siumulators
                case "i386", "x86_64", "arm64":                       return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
// == Airpods ==
                case "AirTag1,1":                                     return "airTag 1gen"
                case "AirPods1,1":                                    return "airPods 1gen"
                case "AirPods1,2":                                    return "airPods 1gen"
                case "AirPods1,3":                                    return "airPods 1gen"
                case "AirPods2,1":                                    return "airPods 2gen"
                case "AirPods2,2":                                    return "airPods 2gen"
                case "Audio2,1":                                      return "airPods"
                case "AirPodsPro1,1":                                 return "airPods Pro 1gen"
                case "iProd8,1":                                      return "airPods Pro 2gen"
                case "iProd8,6":                                      return "airPods Pro 2gen"
                case "AirPodsMax1,1":                                 return "airPods Max 1gen"
                default:                                              return identifier
            }
#elseif os(tvOS)
            switch identifier {
                case "AppleTV1,1":      return "Apple TV 1gen"
                case "AppleTV2,1":      return "Apple TV 2gen"
                case "AppleTV3,1":      return "Apple TV 3gen"
                case "AppleTV3,2":      return "Apple TV 3gen"
                case "AppleTV5,3":      return "Apple TV 4gen"
                case "AppleTV6,2":      return "Apple TV 4K 1gen"
                case "AppleTV11,1":     return "Apple TV 4K 2gen"
                case "i386", "x86_64":  return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
                default: return identifier
            }
#endif
        }
        
        return mapToDevice(identifier: identifier)
    }()

    // MARK: - *** DEVICES (Preview) ***
    struct PreviewDeviceList  {
        // MARK: - == Desktops ==
        static let Mac:String = "Mac"
        
        // MARK: - == iPhones ==
        struct iPhone {
            struct _4 {
                static let S:String = "iPhone 4s"
            }
            
            struct _5 {
                static let _1:String = "iPhone 5"
                static let S:String = "iPhone 5s"
            }
            
            struct _6 {
                static let _1:String = "iPhone 6"
                static let Plus:String = "iPhone 6 Plus"
            }
            
            struct _6s {
                static let _1:String = "iPhone 6s"
                static let Plus:String = "iPhone 6s Plus"
            }
            
            struct _7 {
                static let _1:String = "iPhone 7"
                static let Plus:String = "iPhone 7 Plus"
            }
            
            struct _8 {
                static let _1:String = "iPhone 8"
                static let Plus:String = "iPhone 8 Plus"
            }
            
            struct SE {
                static let _1:String = "iPhone SE"
                static let _2:String = "iPhone SE (2nd gen)"
            }
            
            struct X {
                static let _1:String = "iPhone X"
                static let XR:String = "iPhone Xr"
            }
            
            struct _11 {
                static let _1:String = "iPhone 11"
                struct Pro {
                    static let _1:String = "iPhone 11 Pro"
                    static let Max:String = "iPhone 11 Pro Max"
                }
                
                struct Xs {
                    static let _1:String = "iPhone Xs"
                    static let Max:String = "iPhone Xs Max"
                }
            }
            
            struct _12 {
                static let _1:String = "iPhone 12"
                static let Mini:String = "iPhone 12 Mini"
                struct Pro {
                    static let _1:String = "iPhone 12 Pro"
                    static let Max:String = "iPhone 12 Pro Max"
                }
            }
            
            struct _13 {
                static let _1:String = "iPhone 13"
                static let Mini:String = "iPhone 13 Mini"
                struct Pro {
                    static let _1:String = "iPhone 13 Pro"
                    static let Max:String = "iPhone 13 Pro Max"
                }
            }
            
            struct _14 {
                static let Base:String = "iPhone 14"
                static let SE:String = "iPhone SE (3rd gen)"
                static let Plus:String = "iPhone 14 Plus"
                static let Pro:String = "iPhone 14 Pro"
                static let Max:String = "iPhone 14 Pro Max"
            }

            struct _15 {
                static let Base:String = "iPhone 15"
                static let Plus:String = "iPhone 15 Plus"
                static let Pro:String = "iPhone 15 Pro"
                static let Max:String = "iPhone 15 Pro Max"
            }
        }
        
        // MARK: - == iPads ==
        struct iPad {
            static let Retina = "iPad Retina"
            static let _1 = "iPad"
            static let _2 = "iPad 2"
            static let _3 = "iPad 3"
            static let _4 = "iPad 4"
            static let _5 = "iPad (5th gen)"
            static let _6 = "iPad (6th gen)"
            static let _7 = "iPad (7th gen)"
            static let _8 = "iPad (8th gen)"
            static let _9 = "iPad (9th gen)"
            
            struct Mini {
                static let _1 = "iPad mini"
                static let _2 = "iPad mini 2"
                static let _3 = "iPad mini 3"
                static let _4 = "iPad mini 4"
                static let _5 = "iPad mini (5th gen)"
                static let _6 = "iPad mini (6th gen)"
            }
            
            struct Air {
                static let _1 = "iPad Air"
                static let _2 = "iPad Air 2"
                static let _3 = "iPad Air (3rd gen)"
                static let _4 = "iPad Air (4th gen)"
            }
            
            struct Pro {
                static let _9_7 = "iPad Pro (9.7-inch)"
                static let _10_5 =  "iPad Pro (10.5-inch)"
                
                struct _11 {
                    static let _1 = "iPad Pro (11-inch)"
                    static let _2 = "iPad Pro (11-inch)  (2nd gen)"
                    static let _3 = "iPad Pro (11-inch)  (3rd gen)"
                }
                
                struct _12_9 {
                    static let _1 = "iPad Pro"
                    static let _2 = "iPad Pro 12.9-inch)  (2nd gen)"
                    static let _3 = "iPad Pro 12.9-inch)  (3rd gen)"
                    static let _4 = "iPad Pro (12.9-inch) (4th gen)"
                    static let _5 = "iPad Pro (12.9-inch) (5th gen)"
                }
            }
        }
        
        // MARK: - == iPods ==
        struct iPodTouch {
            static let _6 = "iPod touch (6th gen)"
            static let _7 = "iPod touch (7th gen)"
            static let _8 = "iPod touch (8th gen)"
        }
        
        // MARK: - == TV ==
        struct TV {
            static let _1 = "Apple TV (1st Gen)"
            static let _2 = "Apple TV (2nd Gen)"
            static let _3 = "Apple TV (3rd Gen)"
            static let _4 = "Apple TV (4th Gen)"
            static let _4k_1 = "Apple TV 4K (1st Gen)"
            static let _4k_2 = "Apple TV 4K (2nd Gen)"
        }
        
        // MARK: - == Watches ==
        struct Watch {
            struct _1 {
                static let _38mm = "Apple Watch 38mm"
                static let _42mm = "Apple Watch 42mm"
            }
            
            struct _2 {
                static let _38mm = "Apple Watch Series 2 38mm"
                static let _42mm = "Apple Watch Series 2 42mm"
            }
            
            struct _3 {
                static let _38mm = "Apple Watch Series 3 38mm"
                static let _42mm = "Apple Watch Series 3 42mm"
            }
            
            struct _4 {
                static let _40mm = "Apple Watch Series 4 40mm"
                static let _44mm = "Apple Watch Series 4 44mm"
            }
            
            struct _5 {
                static let _40mm = "Apple Watch Series 5 40mm"
                static let _44mm = "Apple Watch Series 5 44mm"
            }
            
            struct SE {
                static let _40mm = "Apple Watch SE 40mm"
                static let _44mm = "Apple Watch SE 44mm"
            }
            
            struct _6 {
                static let _40mm = "Apple Watch Series 6 40mm"
                static let _44mm = "Apple Watch Series 6 44mm"
            }
            
            struct _7 {
                static let _40mm = "Apple Watch Series 7 40mm"
                static let _44mm = "Apple Watch Series 7 44mm"
            }
        }
        
        // MARK: - == Color Schemes ==
        struct colorScheme {
            static let dark = "Dark Scheme"
            static let light = "Light Scheme"
        }
    }
}
