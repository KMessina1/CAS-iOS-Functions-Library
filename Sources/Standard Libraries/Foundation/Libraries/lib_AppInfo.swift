/*--------------------------------------------------------------------------------------------------------------------------
    File: lib_AppInfo.swift
  Author: Kevin Messina
 Created: 7/1/23
Modified: 3/9/2024
 
©2023-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import Foundation
import SwiftUI

/// TabBar->TabItem titles/names in your app.
///
/// This is the basic set of TabBar Names used across many standard apps.
/// To EXTEND this list, add a new section in your code by:
///
///     extension TabNames {
///         static let Settings = TabNames.TabInfoStruct(title: "Settings", imgName: AppImages.settings)
///     }
///
/// - Returns: String name of Tab and systemImageName for SFImages.
struct TabNames {
    struct TabInfoStruct {
        var title: String
        var imgName: String
    }
}

// MARK: - *** APP KEY NAMES ***
/// Key/Value names for user defaults.
///
/// This is the basic set of Key Names used across many standard apps.
/// To EXTEND this list, add a new section in your code by:
///
///     extension KeyNames {
///         static let line = KeyNames(rawValue: "line")
///     }
///
/// - Returns: String 'key' name to be used in User Defaults or similar Key/Value.
struct KeyNames: RawRepresentable {
    var rawValue: String
    
    /* App Generic */
    struct App {
        var rawValue: String
        
        static let copyright = KeyNames.App(rawValue: "c.circle").rawValue
        static let needsInit = KeyNames.App(rawValue: "app.needsInit").rawValue
        static let installationDate = KeyNames.App(rawValue: "app.installationDate").rawValue
        static let currentPage = KeyNames.App(rawValue: "app.currentPage").rawValue
        static let copyrightYear = KeyNames.App(rawValue: "app.copyrightYear").rawValue
        static let copyrightReserved = KeyNames.App(rawValue: "app.copyrightReserved").rawValue
        static let appStoreURL = KeyNames.App(rawValue: "app.appStoreURL").rawValue
        static let themeID = KeyNames.App(rawValue: "app.themeID").rawValue
        static let appVersion = KeyNames.App(rawValue: "app.version").rawValue
        static let showWhatsNew = KeyNames.App(rawValue: "app.whatsNew").rawValue
        static let requiresLogin = KeyNames.App(rawValue: "app.requiresLogin").rawValue

        /* App Store Rating */
        struct Rating {
            var rawValue: String
            
            static let lastBuildVersion = KeyNames.App.Rating(rawValue: "app.rating.lastBuildVersion").rawValue

            /* App Store Rating Milestone Counts */
            struct MilestoneCount {
                var rawValue: String
                
                static let event1 = KeyNames.App.Rating.MilestoneCount(rawValue: "app.rating.milestoneCount.inventory").rawValue
                static let event2 = KeyNames.App.Rating.MilestoneCount(rawValue: "app.rating.milestoneCount.rangeSession").rawValue
            }
        }
        
        /* ☁️iCloud Variables */
        struct Settings {
            var rawValue: String
            
        }
    }
    
    /* Company */
    struct Company {
        var rawValue: String
        
        static let name = KeyNames.Company(rawValue: "appInfo.Company.Name").rawValue
        static let subsidiary = KeyNames.Company(rawValue: "appInfo.Company.Subsidiary").rawValue
        static let address1 = KeyNames.Company(rawValue: "appInfo.Company.Address1").rawValue
        static let address2 = KeyNames.Company(rawValue: "appInfo.Company.Address2").rawValue
        static let city = KeyNames.Company(rawValue: "appInfo.Company.City").rawValue
        static let state = KeyNames.Company(rawValue: "appInfo.Company.State").rawValue
        static let zipCode = KeyNames.Company(rawValue: "appInfo.Company.ZipCode").rawValue
        static let country = KeyNames.Company(rawValue: "appInfo.Company.Country").rawValue
        static let location = KeyNames.Company(rawValue: "appInfo.Company.Location").rawValue
        static let website = KeyNames.Company(rawValue: "appInfo.Company.Website").rawValue
        static let url = KeyNames.Company(rawValue: "https:\\CreativeApps.US\(website)").rawValue
        static let phone = KeyNames.Company(rawValue: "appInfo.Company.Phone").rawValue
        static let email_Contact = KeyNames.Company(rawValue: "appInfo.Company.Contact").rawValue
        static let email_Support = KeyNames.Company(rawValue: "appInfo.Company.Support").rawValue
        static let appStoreURL = KeyNames.Company(rawValue: "appInfo.Company.AppStoreURL").rawValue
    }
}

// MARK: - *** APP INFO ***
struct AppInfo {
    // MARK: - *** DEVELOPER INFO ***
    struct Developer {
        static let name = "Creative App Solutions, LLC."
        static let subsidiary = ""
        static let address1 = "13050 Gran Bay Parkway"
        static let address2 = "Suite 401"
        static let city = "Jacksonville"
        static let state = "Florida"
        static let zipCode = "32258"
        static let country = "USA"
        static let product = "🇺🇸 Proudly made in the USA 🇺🇸"
        static let email_Info = "Info@CreativeApps.US"
        static let email_TechSupport = "Support@CreativeApps.US"
        static let phone = ""
        static let website = "CreativeApps.US"
        static let url = "https://creativeapps.us"
        static let author = "Kevin Messina"
    }
    
    // MARK: - *** APP INFO ***
    static let appName: String = (Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String) ?? "n/a"
    static let version: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "n/a"
    static let build: String = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? "n/a"
    
    func isThisVersionNewerThanCurrent(_ testVersion: Double) -> Bool {
        let versionInfo = versionNumbers()
        let version: Double = Double("\(versionInfo.major).\(versionInfo.minor)") ?? 0.0 //disregard revision and build...
        
        return (version > testVersion)
    }

    func versionNumbers() -> (version: Double, major: Int, minor: Int, revision: Int, build: Int) {
        var major: Int = 0
        var minor: Int = 0
        var revision: Int = 0
        var version: Double = 0.0
        var build: Int = 0
        
        let versionString: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
        if !versionString.isEmpty {
            let versionNums: [Int] = versionString
                .split(separator: ".")
                .compactMap { Int(String($0).trimmingCharacters(in: .whitespacesAndNewlines)) }
            
            switch versionNums.count {
                case 2:
                    major = versionNums[0]
                    minor = versionNums[1]
                    version = Double("\(major).\(minor)") ?? 0.0
                case 3:
                    major = versionNums[0]
                    minor = versionNums[1]
                    revision = versionNums[2]
                    version = Double("\(major).\(minor).\(revision)") ?? 0.0
                default: break
            }
        }
        
        let buildString: String = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? ""
        build = Int(buildString) ?? 0

        return (version: version, major: major, minor: minor, revision: revision, build: build)
    }
    
    func versionWithBuild(showV:Bool, showParensBuild:Bool) -> String {
        var text = showV ?"v\( AppInfo.version )" :"\( AppInfo.version )"
        text.append(showParensBuild ?" (\( AppInfo.build ))" :".\( AppInfo.build )" )

        return text
    }

    func isCurrentVersionNewerThan(_ version: String, save: Bool, key: String) -> Bool {
        let UD = UserDefaults.standard
        let currentVersion:Double = Double(AppInfo().versionNumbers().version)
        let lastSavedVersion:Double = UD.double(forKey: version)
        let versionsDontMatch = (currentVersion != lastSavedVersion)

        if save {
            UD.set(versionsDontMatch, forKey: key)
            UD.set(currentVersion, forKey: KeyNames.App.appVersion)
            UD.synchronize()
        }
        
        return versionsDontMatch
    }

    // MARK: - *** COPYRIGHT INFO ***
    struct CopyrightInfo {
        let company:String
        let subsidiary:String
        let years:String
        let short:String
        let full:String
        let allRights:String
    }
    
    func returnCopyRightInfo() -> CopyrightInfo {
        @AppStorage(KeyNames.App.copyrightYear) var startYear = 0
        @AppStorage(KeyNames.App.copyrightReserved) var allRights = ""
        @AppStorage(KeyNames.Company.name) var company = ""
        @AppStorage(KeyNames.Company.subsidiary) var subsidiary = ""

        let currentYear = Date().year
        var yearRange:String = ""
        var years:String = ""
        var short:String =  ""
        var full:String = ""

        if startYear > 0 {
            yearRange = (currentYear - startYear) > 0 ?"\( startYear )-\( currentYear )" :"\( startYear )"
            years = "©\( yearRange )"
            short =  "©\( yearRange ) \( company.uppercased() )"
            full = subsidiary.isEmpty
                ?"©\( yearRange ) \( company.uppercased() )"
                :"©\( yearRange ) \( company.uppercased() )\nsubsidiary of \( subsidiary )"
        }else{
            years = "©\( currentYear )"
            short =  "©\( currentYear ) \( company.uppercased() )"
            full = subsidiary.isEmpty
                ?"©\( currentYear ) \( company.uppercased() )"
                :"©\( currentYear ) \( company.uppercased() )\nsubsidiary of \( subsidiary )"
        }
        
        return CopyrightInfo.init(
            company: company,
            subsidiary: subsidiary,
            years: years,
            short: short,
            full: full,
            allRights: allRights
        )
    }
    
    struct CopyrightView: View {
        var copyright = AppInfo().returnCopyRightInfo()
        var color:Color = .black
        
        var body: some View {
            VStack(spacing:3) {
                Text(copyright.full)
                    .font(deviceIs.Pad ?.body :.caption)
                    .minimumScaleFactor(0.66)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                
                Text(copyright.allRights)
                    .font(deviceIs.Pad ?.callout :.caption2)
                    .italic()
                    .minimumScaleFactor(0.66)
                    .lineLimit(1)
            }
            .foregroundStyle(color)
        }
    }

    // MARK: - *** FUNCTIONS ***
    struct CompanyInfo {
        let name:String
        let susbidiary:String
        let address1:String
        let address2:String
        let city:String
        let state:String
        let country:String
        let location:String
        let website:String
    }
    
    func returnCompanyInfo() -> CompanyInfo {
        @AppStorage(KeyNames.Company.name) var company = "n/a"
        @AppStorage(KeyNames.Company.subsidiary) var subsidiary = "n/a"
        @AppStorage(KeyNames.Company.address1) var address1 = "n/a"
        @AppStorage(KeyNames.Company.address2) var address2 = "n/a"
        @AppStorage(KeyNames.Company.city) var city = "n/a"
        @AppStorage(KeyNames.Company.state) var state = "n/a"
        @AppStorage(KeyNames.Company.country) var country = "n/a"
        @AppStorage(KeyNames.Company.location) var location = "n/a"
        @AppStorage(KeyNames.Company.website) var website = "n/a"

        return CompanyInfo.init(
            name: company,
            susbidiary: subsidiary,
            address1: address1,
            address2: address2,
            city: city,
            state: state,
            country: country,
            location: location,
            website: website
        )
    }
    
    func ShowInfo() -> Void {
        let repeats = 100
        
        if !runtimeIs().Release {
            simPrint(String(repeating: "=", count: repeats), action: .noPrefix,log: "")
            /* App Info */
            simPrint("   App Name: \( AppInfo.appName )", action: .noPrefix,log: "")
            simPrint("    Version: \( AppInfo.version )", action: .noPrefix,log: "")
            simPrint("      Build: (\( AppInfo.build ))", action: .noPrefix,log: "")
            simPrint("    Company: \( returnCompanyInfo().name )", action: .noPrefix,log: "")
            simPrint("     Device: \( UIDevice.Family().typeIs() )", action: .noPrefix,log: "")
            simPrint("Environment: \( UIDevice.Family().environmentIs() )", action: .noPrefix,log: "")
            simPrint("    RunTime: \( runtimeIs().runtimeType() )", action: .noPrefix,log: "")
            simPrint("  Execution: \( Date().formattedAs(Date.formats.EEEE_MMMM_d_yyyy_at_hmm_a) )", action: .noPrefix,log: "")
            simPrint(String(repeating: "-", count: repeats), action: .noPrefix,log: "")
            simPrint("    Library: \(Files().getPathForFilename("",in: .libDir).path)", action: .folder,log: "")
            simPrint(" User Def's: \(Files().getPathForFilename("",in: .libDir).path)Preferences", action: .folder,log: "")
            simPrint("     Caches: \(Files().getPathForFilename("",in: .cacheDir).path)", action: .folder,log: "")
            simPrint("  Documents: \(Files().getPathForFilename("",in: .docsDir).path)", action: .folder,log: "")
            simPrint(String(repeating: "=",  count: repeats), action: .noPrefix,log: "",LF_End: true)
        }
    }
}

