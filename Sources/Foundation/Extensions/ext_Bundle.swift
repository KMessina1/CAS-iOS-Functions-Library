/*------------------------------------------------------------------------------------------------------------------------
    File: ext_Bundle.swift
  Author: Kevin Messina
 Created: 09/05/2024
Modified:
 
©2024-2026 Creative App Solutions, LLC. - All Rights Reserved.
--------------------------------------------------------------------------------------------------------------------------
NOTES:
------------------------------------------------------------------------------------------------------------------------*/

import Foundation

extension Bundle {
    /// Text("\( Bundle.main.version().release )")
    /// Text("\( Bundle.main.version().build )")
    /// Text("\( Bundle.main.version().formatted(.v) )")
    struct version {
        enum versionPrefix { case none,v,version }
        enum versionSuffix { case none,period,parens,build }

        var release: String {
            return (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "n/a"
        }
        
        var build: String {
            return (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? "n/a"
        }
        
        func formatted(prefix:versionPrefix, suffix:versionSuffix) -> String {
            var prefixTxt: String = ""
            var suffixTxt: String = ""

            switch prefix {
                case .none: prefixTxt = ""
                case .v: prefixTxt = "v"
                case .version: prefixTxt = "Version "
            }

            switch suffix {
                case .none: suffixTxt = ""
                case .period: suffixTxt = ".\(build)"
                case .parens: suffixTxt = " (\(build))"
                case .build: suffixTxt = "build: \(build)"
            }

            return "\(prefixTxt)\(release)\(suffixTxt)"
        }
    }
}
