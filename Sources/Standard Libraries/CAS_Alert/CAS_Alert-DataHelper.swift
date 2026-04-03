/*--------------------------------------------------------------------------------------------------------------------------
    File: CAS_Alert-DataHelper.swift
  Author: Kevin Messina
 Created: May 17, 2022
Modified:
 
 ©2022-2023 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:


--------------------------------------------------------------------------------------------------------------------------*/

import SwiftUI
import SwiftData

//var CASAlert_dbQueue: DatabaseQueue!

// MARK: - *** CAS ALERT DATA ***
struct CASAlertData {
    // MARK: - *** Status Types ***
    struct StatusType:Identifiable,Equatable,Hashable {
        var id:UUID = UUID()
        var index:Int64 = -1
        var name:String = ""
        var number:Int = -1
    }

    // MARK: - *** Predefined_Messages ***
    struct Predefined_Messages: Identifiable,Equatable,Hashable {
        var id:UUID = UUID()
        var Indx:Int64 = Int64()
        var StatusType:CAS_Alert.statusTypes = .none
        var Message:String = ""
        var Notation:String = ""
        
        func getMessageNamed(_ name:String, replacementText:String = "") -> String {
            var type = String(reflecting: name.lowercased()).components(separatedBy: ".").last ?? ""
            type = type.replacingOccurrences(of: "\"", with: "")

            var newMessage = CAS_AlertDataModel.returnValueForType().returnTextForStatusType(name).Message
            newMessage = newMessage.replacingOccurrences(of: "~text~", with: replacementText)

            return newMessage
        }

        func getNotationNamed(_ name:String,replacementText:String = "") -> String {
            var type = String(reflecting: name.lowercased()).components(separatedBy: ".").last ?? ""
            type = type.replacingOccurrences(of: "\"", with: "")
            
            var newNotation = CAS_AlertDataModel.returnValueForType().returnTextForStatusType(name).Notation
            newNotation = newNotation.replacingOccurrences(of: "~text~", with: replacementText)
            
            return newNotation
        }
    }
}


