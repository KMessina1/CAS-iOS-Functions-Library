/*--------------------------------------------------------------------------------------------------------------------------
    File: CAS_Alert-DataModels.swift
  Author: Kevin Messina
 Created: May 18, 2022
Modified: June 29, 2023
 
 ©2022-2023 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
 
2023_06_29  Replaced GRDB Alert information for in memory arrays.

--------------------------------------------------------------------------------------------------------------------------*/

import Foundation
import SwiftUI

// MARK: - *** CAS_ALERT DATA MODEL ***
class CAS_AlertDataModel: ObservableObject {
    @Published var title:String = ""
    @Published var operation:CAS_Alert.operationTypes = .none
    @Published var type:CAS_Alert.statusTypes = .none
    @Published var alreadyExits:CAS_Alert.alreadyExistsType = .none
    @Published var style:CAS_Alert.styleTypes = .none
    @Published var itemName:String = ""
    @Published var itemNumber:String = ""
    @Published var msg:String = ""
    @Published var notation:String = ""
    @Published var show:Bool = false
    @Published var actionButtonTitle:String = ""
    @Published var cancelButtonTitle:String = "Cancel"
    @Published var buttonPressed:CAS_Alert.buttonPressed = .cancel_OK
    @Published var recordIndex:Int64 = -1
    @Published var errorDescription:String = ""
    @Published var tag:Int = 0
    @Published var tagName:CAS_Alert.presetTypes = .none
    @Published var replacementText:String = ""
}

extension CAS_AlertDataModel {
    struct returnValueForType {
        func title(_ type:CAS_Alert.styleTypes, title:String = "") -> String {
            var newTitle:String = ""
            
            switch type {
                case .IAP_Needed: newTitle = "Upgrade?"
                case .IAP_Confirm: newTitle = "Purchase?"
                case .IAP_NotNeeded: newTitle = "Already Purchased"
                case .IAP_Purchased: newTitle = "Purchase Success"
                case .warning: newTitle = "Warning"
                case .success: newTitle = "Success"
                case .success_Saved: newTitle = "Saved"
                case .success_Updated: newTitle = "Updated"
                case .success_Deleted: newTitle = "Deleted"
                case .error: newTitle = "Error"
                case .construction,.disabled: newTitle = "In Development"
                case .notAvail: newTitle = "Not Avilable"
                case .cannotSendMail: newTitle = "Mail Error"
                case .mailSent: newTitle = "Mail Sent"
                case .mailFailed: newTitle = "Mail Issue"
                case .notFound: newTitle = "Not Found"
                case .info: newTitle = "Information"
                case .confirmDelete: newTitle = "Confirm Delete?"
                case .confirmSave: newTitle = "Confirm Save?"
                case .confirmUpdate: newTitle = "Confirm Update?"
                case .exists_Add: newTitle = "Already Exists"
                case .failed_Delete: newTitle = "Delete Error"
                case .failed_Save: newTitle = "Save Error"
                case .failed_Update: newTitle = "Update Error"
                case .itemIssue: newTitle = "Item Issue"
                case .notice: newTitle = "Notice"
                case .edit: newTitle = "Ediiting"
                case .wait: newTitle = "Busy..."
                case .serverError: newTitle = "Server Error"
                case .custom: newTitle = title
                case .none: newTitle = ""
            }
            
            return title.isEmpty ?newTitle :title
        }

        /// Return a predefined notation by CAS_Alert.styleType. Replacement text of ~text~ from db by passing notation parameter.
        func notation(_ type:CAS_Alert.styleTypes, notation:String) -> String {
            let typeText:String = String(reflecting: type)
            let newNotation:String = CASAlertData.Predefined_Messages().getNotationNamed(typeText,replacementText: notation)

            simPrint(type: .info, msg: "Notation:\n\( newNotation )")
            
            return newNotation
        }

        /// Return a predefined message by CAS_Alert.styleType. Replacement text of ~text~ from db by passing msg parameter.
        func msg(_ type:CAS_Alert.styleTypes, msg:String) -> String {
            let typeText:String = String(reflecting: type)
            let newMsg = CASAlertData.Predefined_Messages().getMessageNamed(typeText,replacementText: msg)
 
            simPrint(type: .info, msg: "newMsg: \( newMsg )")
            
            return newMsg
        }
        
        /// Return a predefined color by CAS_Alert.styleType. Force custom color by passing customerColor parameter.
        func backColor(_ type:CAS_Alert.styleTypes, customColor:Color = .black) -> Color {
            var style:CAS_Alert.styleTypePredefined = .info
            var color:Color = .black
            
            switch type {
                case .itemIssue,.warning:
                    style = .itemIssue
                case .IAP_Needed,.IAP_NotNeeded,.IAP_Confirm:
                    style = .IAP_Needed
                case .error,.serverError,.failed_Save,.failed_Update,.failed_Delete:
                    style = .error
                case .cannotSendMail: style = .cannotSendMail
                case .mailFailed: style = .mailFailed
                case .mailSent,.success,.confirmSave,.confirmUpdate,.IAP_Purchased,.success_Saved,.success_Updated,
                     .success_Deleted:
                    style = .success
                case .disabled,.construction:
                    style = .construction
                case .confirmDelete: style = .confirmDelete
                case .exists_Add: style = .exists_Add
                case .notAvail: style = .notAvail
                case .notFound: style = .notFound
                case .info: style = .info
                case .notice: style = .notice
                case .edit: style = .edit
                case .wait: style = .wait
                case .custom: color = customColor
                case .none: color = customColor
            }

            switch type {
                case .custom,.none:
                    color = customColor
                default:
                    color = CAS_AlertDataModel.returnValueForPredefinedType().backColor(style)
            }
            
            return color
        }
        
        func iconColor(_ type:CAS_Alert.styleTypes) -> Color {
            switch type {
                case .construction,.disabled,.wait,.edit:
                    return  Color.black
                default:
                    return Color.white
            }
        }
        
        func imgName(_ type:CAS_Alert.styleTypes) -> String {
            switch type {
                case .warning: return CAS_Alert.images.warning.imgName
                case .IAP_Needed,.IAP_NotNeeded,.IAP_Confirm,.IAP_Purchased:
                    return CAS_Alert.images.IAP.imgName
                case .error,.failed_Save,.failed_Update,.failed_Delete,.exists_Add:
                    return CAS_Alert.images.error.imgName
                case .success,.success_Saved,.success_Updated,.success_Deleted:
                    return CAS_Alert.images.success.imgName
                case .construction: return CAS_Alert.images.construction.imgName
                case .notAvail: return CAS_Alert.images.notAvailable.imgName
                case .mailFailed,.mailSent,.cannotSendMail:
                    return CAS_Alert.images.email.imgName
                case .itemIssue: return CAS_Alert.images.folder.imgName
                case .confirmDelete,.confirmSave,.confirmUpdate:
                    return CAS_Alert.images.confirm.imgName
                case .disabled: return CAS_Alert.images.disabled.imgName
                case .info: return CAS_Alert.images.info.imgName
                case .notice: return CAS_Alert.images.notice.imgName
                case .edit: return CAS_Alert.images.edit.imgName
                case .wait: return CAS_Alert.images.wait.imgName
                case .serverError: return CAS_Alert.images.server.imgName
                case .notFound: return CAS_Alert.images.notFound.imgName
                case .custom,.none:
                    return ""
            }
        }
        
        struct PredefinedMsgRecord {
            var id:UUID = UUID()
            var Indx:Int
            var StatusType:Int
            var StatusTypeText:String
            var Message:String = ""
            var Notation:String = ""
        }

        let arrPredefinedMsg:[PredefinedMsgRecord] = [
            PredefinedMsgRecord(Indx: 1, StatusType: 100, StatusTypeText: "none"),
            PredefinedMsgRecord(Indx: 2, StatusType: 230, StatusTypeText: "confirmDelete",
                                Message: "Are you sure you want to delete\n\n'~text~'\n\n⚠️This cannot be undone."),
            PredefinedMsgRecord(Indx: 3, StatusType: 270, StatusTypeText: "disabled",
                                Notation: """
                                          **Note:** This Function has been disabled and is unavailable at this time.\n
                                          **Reason:** For Development purposes.\n
                                          **Action:** Contact [Technical Support] or the App Developer (See ***Contact Us*** \
                                          in Settings) to email us and understand why this message is appearing.
                                          """),
            PredefinedMsgRecord(Indx: 4, StatusType: 250, StatusTypeText: "under_construction",
                                Message: "Function is temporarily unavailable and in Development."),
            PredefinedMsgRecord(Indx: 5, StatusType: 110, StatusTypeText: "cannotDelete",
                                Message: "Cannot delete '~text~'"),
            PredefinedMsgRecord(Indx: 6, StatusType: 210, StatusTypeText: "failed_Delete",
                                Message: "'~text~' failed to be Deleted."),
            PredefinedMsgRecord(Indx: 7, StatusType: 200, StatusTypeText: "failed_Update",
                                Message: "'~text~' failed to be Updated."),
            PredefinedMsgRecord(Indx: 8, StatusType: 190, StatusTypeText: "failed_Save",
                                Message: "'~text~' failed to be Saved."),
            PredefinedMsgRecord(Indx: 9, StatusType: 180, StatusTypeText: "success_Deleted",
                                Message: "'~text~' was successfully deleted."),
            PredefinedMsgRecord(Indx: 10, StatusType: 170, StatusTypeText: "success_Updated",
                                Message: "'~text~' was successfully updated."),
            PredefinedMsgRecord(Indx: 11, StatusType: 160, StatusTypeText: "success_Saved",
                                Message: "'~text~' was successfully saved."),
            PredefinedMsgRecord(Indx: 12, StatusType: 150, StatusTypeText: "exists_Add",
                                Message: "'~text~' already exists and cannot be added."),
            PredefinedMsgRecord(Indx: 13, StatusType: 140, StatusTypeText: "requiredItem",
                                Message: "'~text~' is required and cannot be deleted."),
            PredefinedMsgRecord(Indx: 14, StatusType: 130, StatusTypeText: "cannotDelete_hasSubItems",
                                Message: """
                                         "'~text~' cannot be deleted because it has Sub-Items associated with it.\n
                                         Delete all Sub-Items before attempting to delete '~text~'.
                                         """),
            PredefinedMsgRecord(Indx: 15, StatusType: 260, StatusTypeText: "itemIssue",
                                Notation: """
                                          **Note:** An issue was detected within this Item.\n
                                          **Reason:** ~text~\n
                                          **Action:** Please check that the information entered is correct and of the data \
                                          type and format that is expected.
                                          """),
            PredefinedMsgRecord(Indx: 16, StatusType: 240, StatusTypeText: "IAP_Needed",
                                Message: """
                                         The limit has been reached for adding new items.\n
                                         If you want pricing and options for purchasing more, press Pricing.
                                         """),
            PredefinedMsgRecord(Indx: 17, StatusType: 220, StatusTypeText: "notFound",
                                Message: "'~text~' was not found."),
            PredefinedMsgRecord(Indx: 18, StatusType: 300, StatusTypeText: "cannotSendMail",
                                Message: """
                                         There was a problem detecting an active Mail account. Please check internet /
                                         connection and email settings for device.
                                         """),
            PredefinedMsgRecord(Indx: 19, StatusType: 231, StatusTypeText: "delete",
                                Message: "Are you sure you want to delete\n\n'~text~'\n\n⚠️This cannot be undone."),
            PredefinedMsgRecord(Indx: 20, StatusType: 242, StatusTypeText: "IAP_Confirm",
                                Message: "Are you sure you want to purchase '~text~'?"),
            PredefinedMsgRecord(Indx: 21, StatusType: 244, StatusTypeText: "IAP_Purchased",
                                Message: "'~text~' was successfully purchased and can now be used.",
                                Notation: """
                                          **NOTE:** In the event the purchase is not immediately showing, go to Settings /
                                          -> In-App Purchases and RESTORE past purchases.
                                          """),
            PredefinedMsgRecord(Indx: 22, StatusType: 990, StatusTypeText: "warning",
                                Message: "~text~")
        ]
        
        func returnTextForStatusType(_ searchFor: String) -> (Message:String,Notation:String) {
            if let filteredItem = arrPredefinedMsg.filter({ $0.StatusTypeText.lowercased() == searchFor.lowercased() }).first {
                return (Message:filteredItem.Message,Notation:filteredItem.Notation)
            } else {
                simPrint(type: .error, msg: "Error loading finding array element named: \(searchFor)", log: logFileFunctionLine())
                return (Message:"n/a",Notation:"n/a")
            }
        }
    }
    
    struct returnValueForPredefinedType {
        func title(_ predefinedType:CAS_Alert.styleTypePredefined,title:String = "") -> String {
            switch predefinedType {
                case .requiredCantEditOrDelete: return title.isEmpty ?"Required Item" :title
                case .exists_Add: return title.isEmpty ?"Already Exists" :title
                case .IAP_Needed: return title.isEmpty ?"Upgrade?" :title
                case .IAP_NotNeeded: return title.isEmpty ?"Already Purchased" :title
                case .incompleteInfo: return title.isEmpty ?"Incomplete Info" :title
                case .warning: return title.isEmpty ?"Data Warning" :title
                case .success: return title.isEmpty ?"Data Success" :title
                case .success_Saved: return title.isEmpty ?"Saved" :title
                case .success_Updated:return title.isEmpty ?"Updated" :title
                case .success_Deleted:return title.isEmpty ?"Deleted" :title
                case .error: return title.isEmpty ?"Data Error" :title
                case .invalidDate: return title.isEmpty ?"Invalid Date" :title
                case .construction,.disabled:
                    return title.isEmpty ?"In Development" :title
                case .notAvail: return title.isEmpty ?"Not Avilable" :title
                case .cannotSendMail: return title.isEmpty ?"Mail Error" :title
                case .mailSent: return title.isEmpty ?"Mail Sent" :title
                case .mailFailed: return title.isEmpty ?"Mail Issue" :title
                case .databaseError: return title.isEmpty ?"Database Error" :title
                case .IAP_Confirm: return title.isEmpty ?"Purchase?" :title
                case .IAP_Purchased: return title.isEmpty ?"Purchase Success" :title
                case .info: return title.isEmpty ?"Information" :title
                case .confirmDelete: return title.isEmpty ?"Confirm Delete?" :title
                case .confirmSave: return title.isEmpty ?"Confirm Save?" :title
                case .confirmUpdate: return title.isEmpty ?"Confirm Update?" :title
                case .itemIssue: return title.isEmpty ?"Item Issue" :title
                case .failed_Save: return title.isEmpty ?"Save Error" :title
                case .failed_Update: return title.isEmpty ?"Update Error" :title
                case .failed_Delete: return title.isEmpty ?"Delete Error" :title
                case .notice: return title.isEmpty ?"Notice" :title
                case .edit: return title.isEmpty ?"Ediiting" :title
                case .wait: return title.isEmpty ?"Busy..." :title
                case .notFound: return title.isEmpty ?"Not Found" :title
                case .help: return title.isEmpty ?"Help" :title
                case .genericError: return title.isEmpty ?"Error" :title
            }
        }

        func styleType(_ predefinedType:CAS_Alert.styleTypePredefined) -> CAS_Alert.styleTypes {
            switch predefinedType {
                case .warning,.incompleteInfo,.requiredCantEditOrDelete:
                    return .warning
                case .IAP_Needed: return .IAP_Needed
                case .IAP_NotNeeded: return .IAP_NotNeeded
                case .IAP_Confirm: return .IAP_Confirm
                case .IAP_Purchased: return .IAP_Purchased
                case .invalidDate,.databaseError,.error,.genericError,.failed_Save,.failed_Update,.failed_Delete:
                    return .error
                case .success: return .success
                case .construction: return .construction
                case .disabled: return .disabled
                case .notAvail: return .notAvail
                case .cannotSendMail: return .cannotSendMail
                case .mailSent: return .mailSent
                case .mailFailed: return .mailFailed
                case .itemIssue: return .itemIssue
                case .confirmDelete: return .confirmDelete
                case .confirmSave: return .confirmSave
                case .confirmUpdate: return .confirmUpdate
                case .exists_Add: return .exists_Add
                case .help: return .custom
                case .info: return .info
                case .notice: return .notice
                case .edit: return .edit
                case .wait: return .wait
                case .notFound: return .notFound
                case .success_Saved: return .success_Saved
                case .success_Updated: return .success_Updated
                case .success_Deleted: return .success_Deleted
            }
        }

        func imgName(_ predefinedType:CAS_Alert.styleTypePredefined) -> String {
            switch predefinedType {
                case .requiredCantEditOrDelete,.warning,.incompleteInfo:
                    return CAS_Alert.images.warning.imgName
                case .IAP_Needed,.IAP_NotNeeded,.IAP_Confirm,.IAP_Purchased:
                    return CAS_Alert.images.IAP.imgName
                case .genericError,.error,.databaseError,.invalidDate,.failed_Save,.failed_Update,.failed_Delete,.exists_Add:
                    return CAS_Alert.images.error.imgName
                case .success,.success_Saved,.success_Updated,.success_Deleted:
                    return CAS_Alert.images.success.imgName
                case .construction: return CAS_Alert.images.construction.imgName
                case .notAvail: return CAS_Alert.images.notAvailable.imgName
                case .mailFailed,.mailSent,.cannotSendMail:
                    return CAS_Alert.images.email.imgName
                case .itemIssue: return CAS_Alert.images.folder.imgName
                case .confirmDelete,.confirmSave,.confirmUpdate:
                    return CAS_Alert.images.confirm.imgName
                case .disabled: return CAS_Alert.images.disabled.imgName
                case .help,.info:
                    return CAS_Alert.images.info.imgName
                case .notice: return CAS_Alert.images.notice.imgName
                case .notFound: return CAS_Alert.images.notFound.imgName
                case .edit: return CAS_Alert.images.edit.imgName
                case .wait: return CAS_Alert.images.wait.imgName
            }
        }

        func backColor(_ predefinedType:CAS_Alert.styleTypePredefined) -> Color {
            switch predefinedType {
                case .itemIssue,.requiredCantEditOrDelete,.warning,.incompleteInfo:
                    return Color.Alert.warning.Color
                case .IAP_Needed,.IAP_NotNeeded,.IAP_Confirm:
                    return Color.Alert.IAP.Color
                case .cannotSendMail,.mailFailed,.genericError,.error,.databaseError,.invalidDate,.failed_Save,
                     .failed_Update,.failed_Delete,.notFound,.exists_Add:
                    return Color.Alert.error.Color
                case .mailSent,.success,.IAP_Purchased,.success_Saved,.success_Updated,.success_Deleted:
                    return Color.Alert.success.Color
                case .disabled,.construction:
                    return Color.Alert.construction.Color
                case .notAvail: return Color.Alert.notAvail.Color
                case .confirmDelete,.confirmSave,.confirmUpdate:
                    return Color.Alert.confirm.Color
                case .help,.info:
                    return Color.Alert.info.Color
                case .notice: return Color.Alert.notice.Color
                case .edit: return Color.Alert.edit.Color
                case .wait: return Color.Alert.wait.Color
            }
        }
        
        func iconColor(_ predefinedType:CAS_Alert.styleTypePredefined) -> Color {
            switch predefinedType {
                case .construction,.disabled:
                    return Color.black
                default: return Color.white
            }
        }
        
        func styleTypeForOperation(_ operation:CAS_Alert.operationTypes) -> CAS_Alert.styleTypePredefined {
            switch operation {
                case .none: return .info
                case .success_Saved: return .success_Saved
                case .success_Deleted: return .success_Deleted
                case .success_Updated: return .success_Updated
                case .error:
                    return .error
                case .exists_Add: return .exists_Add
                case .hasRelatedRecords,.warning:
                    return .warning
                case .search: return .info
                case .save: return .confirmSave
                case .update: return .confirmUpdate
                case .delete: return .confirmDelete
                case .IAP_Needed: return .IAP_Needed
                case .IAP_Confirm: return .IAP_Confirm
                case .IAP_Purchased: return .IAP_Purchased
                case .under_construction: return .construction
                case .disabled: return .disabled
                case .itemIssue: return .itemIssue
                case .cannotSendMail: return .cannotSendMail
                case .notFound: return .notFound
            }
        }
    }
    
    func presetFor(_ presetType:CAS_Alert.presetTypes, titleText:String = "", itemText:String = "") {
        typealias PS = presetStruct
        var newPS:PS

        switch presetType {
            case .none: newPS = PS.init(tagName: presetType)
            case .delete: newPS = PS.init(operation: .delete, type: .confirmDelete, style: .confirmDelete, tag: 110)
            case .deleteSub: newPS = PS.init(operation: .delete, type: .confirmDelete, style:.confirmDelete, tag: 120)
            case .failed_Delete: newPS = PS.init(operation: .error, type: .failed_Delete, style:.failed_Delete, tag: 130)
            case .failed_Update: newPS = PS.init(operation: .error, type: .failed_Update, style:.failed_Update,tag: 610)
            case .failed_Save: newPS = PS.init(operation: .error, type: .failed_Save, style:.failed_Save,tag: 610)
            case .IAP_Needed: newPS = PS.init(operation: .IAP_Needed, type: .IAP_Needed, style: .IAP_Needed, tag: 100)
            case .IAP_Confirm: newPS = PS.init(operation: .IAP_Confirm, type: .IAP_Confirm, style: .IAP_Confirm, tag: 102)
            case .IAP_Purchased: newPS = PS.init(operation: .IAP_Purchased, type: .IAP_Purchased, style: .IAP_Purchased, tag: 104)
            case .notFound: newPS = PS.init(operation: .notFound, type: .notFound, style: .notFound, tag: 190)
            case .success_Saved: newPS = PS.init(operation: .success_Saved, type: .success_Saved, style: .success_Saved, tag: 200)
            case .success_Updated: newPS = PS.init(operation: .success_Updated, type: .success_Updated, style: .success_Updated, tag: 300)
            case .success_Deleted: newPS = PS.init(operation: .success_Deleted, type: .success_Deleted, style: .success_Deleted, tag: 140)
            case .exists_add: newPS = PS.init(operation: .exists_Add, type: .exists_Add, style:.exists_Add , tag: 400)
            case .under_construction: newPS = PS.init(operation: .under_construction, type: .under_construction, style: .construction, tag: 500)
            case .disabled: newPS = PS.init(operation: .disabled, type: .disabled, style:.disabled, itemName: title, tag: 510)
            case .itemIssue: newPS = PS.init(operation: .itemIssue, type: .itemIssue, style: .itemIssue, tag: 910)
            case .warning: newPS = PS.init(operation: .warning, type: .warning, style: .warning, tag: 900)
        }

        // Set alert background and icon foreground colors
        newPS.backColor = returnValueForType().backColor(newPS.style)
        newPS.iconColor = returnValueForType().iconColor(newPS.style)

        // Set action & cancel button titles
        switch presetType {
            case .IAP_Needed:
                newPS.actionTitle = "Pricing"
                newPS.cancelTitle = "Cancel"
            case .IAP_Confirm:
                newPS.actionTitle = "Buy"
                newPS.cancelTitle = "Cancel"
            case .delete,.deleteSub:
                newPS.actionTitle = "Delete"
                newPS.cancelTitle = "Cancel"
            default: ()
        }

        // Set RESET DATA
        switch presetType {
            case .under_construction,.IAP_Needed:
                newPS.resetData = true
            default: ()
        }

        if newPS.resetData {
            resetData()
        }
        
        operation = newPS.operation
        type = newPS.type
        style = newPS.style
        actionButtonTitle = newPS.actionTitle
        cancelButtonTitle = newPS.cancelTitle
        tag = newPS.tag

        tagName = presetType // tagName is always this functions presetType unless overridden manually

        title = CAS_AlertDataModel.returnValueForType().title(newPS.style, title: titleText)
        msg = CAS_AlertDataModel.returnValueForType().msg(newPS.style, msg: itemText)
        notation = CAS_AlertDataModel.returnValueForType().notation(newPS.style, notation: itemText)
    }
    
    struct presetStruct {
        var resetData:Bool = false
        var operation:CAS_Alert.operationTypes = .none
        var tagName:CAS_Alert.presetTypes = .none
        var type:CAS_Alert.statusTypes = .none
        var style:CAS_Alert.styleTypes = .none
        var actionTitle:String = ""
        var cancelTitle:String = "OK"
        var title:String = ""
        var msg:String = ""
        var itemName:String = ""
        var itemNumber:String = ""
        var backColor:Color = .black
        var iconColor:Color = .white
        var tag:Int = 0
    }

    func resetData() {
        title = ""
        operation = .none
        type = .none
        alreadyExits = .none
        itemName = ""
        itemNumber = ""
        msg  = ""
        notation = ""
        show = false
        actionButtonTitle = ""
        cancelButtonTitle = ""
        buttonPressed = .cancel_OK
        recordIndex = -1
        errorDescription = ""
        tag = 0
    }
}

// MARK: - *** CAS_Alert Extension ***
extension CAS_Alert {
    struct images {
        struct imgRecord {
            let id:UUID = UUID()
            let Indx:Int
            let Name:String
            let imgName:String
        }
        
        static let address      = imgRecord(Indx: 1, Name: "Address", imgName: "alert_Address")
        static let appStore     = imgRecord(Indx: 2, Name: "AppStore", imgName: "alert_AppStore")
        static let barcode      = imgRecord(Indx: 3, Name: "Barcode", imgName: "alert_Barcode")
        static let camera       = imgRecord(Indx: 4, Name: "Camera", imgName: "alert_Camera")
        static let confirm      = imgRecord(Indx: 5, Name: "Confirm", imgName: "alert_Confirm")
        static let construction = imgRecord(Indx: 6, Name: "Construction", imgName: "alert_Construction")
        static let creditCard   = imgRecord(Indx: 7, Name: "CreditCard", imgName: "alert_CreditCard")
        static let disabled     = imgRecord(Indx: 8, Name: "Disabled", imgName: "alert_Disabled")
        static let edit         = imgRecord(Indx: 9, Name: "Edit", imgName: "alert_Edit")
        static let email        = imgRecord(Indx: 10, Name: "Email", imgName: "alert_Email")
        static let error        = imgRecord(Indx: 11, Name: "Error", imgName: "alert_Error")
        static let folder       = imgRecord(Indx: 12, Name: "Folder", imgName: "alert_Folder")
        static let frame        = imgRecord(Indx: 13, Name: "Frame", imgName: "alert_Frame")
        static let gift         = imgRecord(Indx: 14, Name: "Gift", imgName: "alert_Gift")
        static let IAP          = imgRecord(Indx: 15, Name: "IAP", imgName: "alert_IAP")
        static let info         = imgRecord(Indx: 16, Name: "Info", imgName: "alert_Info")
        static let instagram    = imgRecord(Indx: 17, Name: "Instagram", imgName: "alert_Instagram")
        static let internet     = imgRecord(Indx: 18, Name: "Internet", imgName: "alert_Internet")
        static let notAvailable = imgRecord(Indx: 19, Name: "NotAvaialble", imgName: "alert_NotAvaialble")
        static let notFound     = imgRecord(Indx: 20, Name: "NotFound", imgName: "alert_NotFound")
        static let notice       = imgRecord(Indx: 21, Name: "Notice", imgName: "alert_Notice")
        static let package      = imgRecord(Indx: 22, Name: "Package", imgName: "alert_Package")
        static let photos       = imgRecord(Indx: 23, Name: "Photos", imgName: "alert_Photos")
        static let printer      = imgRecord(Indx: 24, Name: "Printer", imgName: "alert_Printer")
        static let search       = imgRecord(Indx: 25, Name: "Search", imgName: "alert_Search")
        static let server       = imgRecord(Indx: 26, Name: "Server", imgName: "alert_Server")
        static let simulator    = imgRecord(Indx: 27, Name: "Simulator", imgName: "alert_Simulator")
        static let stopHand     = imgRecord(Indx: 28, Name: "StopHand", imgName: "alert_StopHand")
        static let stopSign     = imgRecord(Indx: 29, Name: "StopSign", imgName: "alert_StopSign")
        static let success      = imgRecord(Indx: 30, Name: "Success", imgName: "alert_Success")
        static let thanks       = imgRecord(Indx: 31, Name: "Thanks", imgName: "alert_Thanks")
        static let trophy       = imgRecord(Indx: 32, Name: "Trophy", imgName: "alert_Trophy")
        static let wait         = imgRecord(Indx: 33, Name: "Wait", imgName: "alert_Wait")
        static let warning      = imgRecord(Indx: 34, Name: "Warning", imgName: "alert_Warning")
        static let website      = imgRecord(Indx: 35, Name: "Website", imgName: "alert_Website")

        let arrAlertImgs:[imgRecord] = [
            address,appStore,barcode,camera,confirm,construction,creditCard,disabled,edit,email,error,folder,frame,gift,IAP,
            info,instagram,internet,notAvailable,notFound,notice,package,photos,printer,search,server,simulator,stopHand,
            stopSign,success,thanks,trophy,wait,warning,website
        ]
        
        func getImageNamed(_ name:String) -> String {
            if let filteredItem = arrAlertImgs.filter({ $0.Name == name }).first {
                return filteredItem.imgName
            } else {
                simPrint(type: .error, msg: "Error loading finding array element named: \(name)", log: logFileFunctionLine())
                return ""
            }
        }
    }
}


