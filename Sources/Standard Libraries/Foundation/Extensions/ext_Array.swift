/*--------------------------------------------------------------------------------------------------------------------------
    File: ext_Array.swift
  Author: Kevin Messina
 Created: 3/22/25
Modified:
 
©2025-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import Foundation

extension Array {
    func returnUniqueEntriesFromArray(_ arr:[String]) -> [String] {
        var newArray:[String] = []
        
        for line in arr {
            if !newArray.contains(line) {
                newArray.append(line)
            }
        }
        
        return newArray.sorted(by: { $0 < $1 })
    }
}


