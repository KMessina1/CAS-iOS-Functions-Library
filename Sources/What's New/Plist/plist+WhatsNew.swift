/*--------------------------------------------------------------------------------------------------------------------------
    File: plist+WhatsNew.swift.swift
  Author: Kevin Messina
 Created: 3/20/21
Modified:
 
©2021-2025 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
 
2025_04_30 - Changed data structure to be separate keys and dictionaries for handling versions.
--------------------------------------------------------------------------------------------------------------------------*/

import Foundation

extension WhatsNewView {
    public struct WhatsNewDataStruct: Identifiable {
        let id: UUID = UUID()
        let title: String
        let detail: String
        let iconName: String
    }
    
    public struct WhatsNewKeyStruct: Identifiable {
        var id: Int
        var name: String
    }
    
    public func loadWhatsNewItems() -> (keyNames: [WhatsNewKeyStruct], dict: NSDictionary) {
        var keyNames: [WhatsNewKeyStruct] = []
        var whatsNewDict: NSDictionary = [:]
        
        if let dictPath = Bundle.main.path(forResource: "WhatIsNew", ofType: "plist") {
            whatsNewDict = NSDictionary(contentsOfFile: dictPath)!

            // Get all keys and save in separate array.
            let allKeys = whatsNewDict.allKeys
            for index in 0..<allKeys.count {
                let key = allKeys[index] as! String

                keyNames.append(WhatsNewKeyStruct.init(id: index, name: key))
            }
        }
        
        keyNames = keyNames.sorted(by: { $0.name > $1.name } )
        
        return (keyNames: keyNames, dict: whatsNewDict)
    }
}

