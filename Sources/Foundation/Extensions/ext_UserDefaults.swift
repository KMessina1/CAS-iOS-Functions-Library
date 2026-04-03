/*--------------------------------------------------------------------------------------------------------------------------
    File: lib_UserDefaults.swift
  Author: Kevin Messina
 Created: 7/1/23
Modified: 3/22/24
 
©2023-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
 
2024_03_22 - Added modern Swift replacements for Datre, Color, UIColor and Date helpers for storing their data type.
 
--------------------------------------------------------------------------------------------------------------------------*/

import Foundation
import SwiftUI

extension UserDefaults {
    // Search & Validate Key is present
    func isKeyPresent(_ key: String) -> Bool { return (UserDefaults.standard.object(forKey: key) != nil) }
    
    // Color
    func set(color: Color, forKey key: String) {
        let cgColor = UIColor(color).cgColor
        let components = cgColor.components
        UserDefaults.standard.set(components, forKey: key)
        UserDefaults.standard.synchronize()
    }

    func color(forKey key: String) -> Color? {
        guard
            let components = UserDefaults.standard.object(forKey: key) as? [CGFloat]
        else {
            return .black
        }

        let color = Color(.sRGB,
                          red: components[0],
                          green: components[1],
                          blue: components[2],
                          opacity:components[3] )
        
        return color
    }
    
// Date
    func set(date: Date?, forKey key: String){ self.set(date, forKey: key) }
    func date(forKey key: String) -> Date? { return self.value(forKey: key) as? Date }
}
