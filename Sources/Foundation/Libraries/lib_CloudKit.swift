/*--------------------------------------------------------------------------------------------------------------------------
    File: lib_CloudKit.swift
  Author: Kevin Messina
 Created: 5/19/24
Modified:
 
©2024-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import Foundation
import Network

var networkMonitor = NetworkMonitor()

@Observable
final class NetworkMonitor {
    let networkMonitor = NWPathMonitor()
    let workerQueue = DispatchQueue(label: "Monitor")
    var isConnected = false
    
    init() {
        networkMonitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
        }
       
        networkMonitor.start(queue: workerQueue)
    }
}


/// Useage: CloudKeys().integer(forKey: "app.theme.id", defaultValue: 0)
struct CloudKeys {
    // MARK: - *** INTEGER ***
    func integer(forKey: String) -> Int {
        guard
            let result = NSUbiquitousKeyValueStore.default.object(forKey: forKey) as? Int
        else {
            return 0
        }
        
        return result
    }
    
    func setInteger(forKey: String, value: Int) {
        NSUbiquitousKeyValueStore.default.set(value, forKey: forKey)
        NSUbiquitousKeyValueStore().synchronize()
    }

    // MARK: - *** STRING ***
    func string(forKey: String, defaultValue: String) -> String {
        guard
            let result = NSUbiquitousKeyValueStore.default.string(forKey: forKey)
        else {
            // Put in update queue for next sync
            NSUbiquitousKeyValueStore.default.set(defaultValue, forKey: forKey)
            NSUbiquitousKeyValueStore().synchronize()
            
            return defaultValue
        }
        
        return result
    }
    
    func setString(forKey: String, value: String) {
        NSUbiquitousKeyValueStore.default.set(value, forKey: forKey)
        NSUbiquitousKeyValueStore().synchronize()
    }
}

