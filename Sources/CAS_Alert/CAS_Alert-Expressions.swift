//

/*--------------------------------------------------------------------------------------------------------------------------
    File: CAS_Alert-Expressions.swift
  Author: Kevin Messina
 Created: 7/15/23
Modified:
 
©2023 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import Foundation

extension CAS_Alert {
    public enum styleTypes:Int,CaseIterable {
        // Same values as styleTypePredefined
        case success = 0
        case error
        case warning
        case cannotSendMail
        case mailSent
        case mailFailed
        case construction
        case notAvail
        case disabled
        case IAP_Needed
        case IAP_NotNeeded
        case IAP_Confirm
        case IAP_Purchased
        case confirmDelete
        case confirmSave
        case confirmUpdate
        case itemIssue
        case info
        case exists_Add
        case failed_Save
        case failed_Update
        case failed_Delete
        case notFound
        case success_Saved
        case success_Updated
        case success_Deleted
        // Unique values
        case notice
        case edit
        case wait
        case serverError
        case custom
        case none
    }

    enum styleTypePredefined:Int,CaseIterable {
        // Same values as styleType
        case success = 0
        case error
        case warning
        case cannotSendMail
        case mailSent
        case mailFailed
        case construction
        case notAvail
        case disabled
        case IAP_Needed
        case IAP_NotNeeded
        case IAP_Confirm
        case IAP_Purchased
        case confirmDelete
        case confirmSave
        case confirmUpdate
        case itemIssue
        case info
        case exists_Add
        case failed_Save
        case failed_Update
        case failed_Delete
        case notice
        case edit
        case wait
        case notFound
        case success_Saved
        case success_Updated
        case success_Deleted
        // Unique values
        case databaseError
        case help
        case invalidDate
        case incompleteInfo
        case genericError
        case requiredCantEditOrDelete
    }

    enum alreadyExistsType:Int,CaseIterable {
        case none = 0
        case name
        case number
    }
    
    enum buttonPressed:Int,CaseIterable {
        //Equates to a bool of 0=false, 1=true
        case cancel_OK = 0
        case action = 1
    }
    
    enum statusTypes:Int,CaseIterable {
        case none = 0
        case cannotDelete
        case cannotDelete_hasSubItems
        case requiredItem
        case exists_Add
        case success_Saved
        case success_Updated
        case success_Deleted
        case failed_Save
        case failed_Update
        case failed_Delete
        case confirmDelete
        case under_construction
        case itemIssue
        case disabled
        case notFound
        case IAP_Needed
        case IAP_Confirm
        case IAP_Purchased
        case warning
    }
    
    enum operationTypes:Int,CaseIterable {
        case none = 0
        case delete
        case save
        case success_Saved
        case search
        case exists_Add
        case error
        case hasRelatedRecords
        case success_Deleted
        case update
        case success_Updated
        case IAP_Needed
        case IAP_Confirm
        case IAP_Purchased
        case under_construction
        case notFound
        case warning
        case disabled
        case itemIssue
        case cannotSendMail
    }
    
    enum presetTypes:Int,CaseIterable {
        case none = 0
        case exists_add
        case under_construction
        case delete
        case deleteSub
        case notFound
        case IAP_Needed
        case IAP_Confirm
        case IAP_Purchased
        case failed_Save
        case failed_Update
        case failed_Delete
        case success_Saved
        case success_Updated
        case success_Deleted
        case warning
        case disabled
        case itemIssue
    }
}
