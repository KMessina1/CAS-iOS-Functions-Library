/*--------------------------------------------------------------------------------------------------------------------------
    File: AlertConfig.swift
  Author: Kevin Messina
 Created: 2/26/25
Modified:
 
©2025-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import SwiftUI

func alertType(_ alertStruct:AlertStruct) -> Alert {
    return Alert(title: Text(alertStruct.title), message: Text(alertStruct.msg))
}

struct AlertStruct {
    let title: String
    let msg: String
}

typealias AT = AlertTypes
struct AlertTypes {
    struct App {
        static let defaultType = AlertStruct(
            title: "Alert",
            msg: "This is an undefined alert. Please contact us detailing what you were doing when seeing this alert."
        )
        static let tbd = AlertStruct(
            title: "T/B/D!",
            msg: "This Feature is currently not implemented yet."
        )
        static let construction = AlertStruct(
            title: "UNDER CONSTRUCTION",
            msg: "This screen is currently being developed and has many 'missing' features from its final appearance and operation."
        )
    }
    
    struct AppTips {
        static let reset = AlertStruct(
            title: "APP TIPS",
            msg: "Application Tips (help boxes) have been reset to appear."
        )
    }
    
    struct AgeVerification {
        static let failed = AlertStruct(
            title: "DECLARED AGE VERIFICATION",
            msg: """
                 Some States have or will have soon, MINIMUM AGE REQUIREMENTS for accessing certain app content:

                 ・CA, TX, IL, LA, and UT
                 
                 This app does not contain such content. Therefore, all features of this app are availalbe to you.
                 """
        )

        static let passed = AlertStruct(
            title: "DECLARED AGE VERIFICATION",
            msg: "Your Declared Age Verification is VALID."
        )

        static let error = AlertStruct(
            title: "DECLARED AGE VERIFICATION",
            msg: "An unknown ERROR occurred trying to obtain your Declared Age verification."
        )

        static let notAvailable = AlertStruct(
            title: "DECLARED AGE VERIFICATION",
            msg: "The Declared Age Verification request (Service) is NOT AVAILABLE at this time."
        )

        static let invalid = AlertStruct(
            title: "DECLARED AGE VERIFICATION",
            msg: "The Declared Age Verification request is INVALID."
        )

        static let declined = AlertStruct(
            title: "DECLARED AGE VERIFICATION",
            msg: "You have DECLINED to share Declared Age verification information."
        )
    }
    
    struct DB {
        static let unknownError = AlertStruct(
            title: "DATABASE ERROR",
            msg: "An error occurred trying to access database, try again.\n\nPlease report a well described issue to Tech Support via Contact Us from Dashboard [ℹ︎] Menu."
        )
        static let loaded = AlertStruct(
            title: "ITEM LOADED",
            msg: "Your item has been loaded."
        )
        static let saved = AlertStruct(
            title: "ITEM SAVED",
            msg: "Your item has been saved."
        )
        static let updated = AlertStruct(
            title: "ITEM UPDATED",
            msg: "Your item has been updated."
        )
        static let deleted = AlertStruct(
            title: "ITEM DELETED",
            msg: "Your item has been deleted."
        )
        static let notFound = AlertStruct(
            title: "NOT FOUND",
            msg: "Your item was not found."
        )
        //Custom Uses
        static let newAmmoAdded = AlertStruct(
            title: "New Ammo Item Added",
            msg: "Only the name of your new Ammo has been saved. Now you have to set the ballisktic information for this ammo to properly calculate firing solutions."
        )
    }              
    
    struct Document {
        static let error = AlertStruct(
            title: "FILE ERROR",
            msg: "An error occured trying to process item, process was aborted. \n\nPlease report a well described issue to Tech Support via Contact Us from Dashboard [ℹ︎] Menu."
        )
        static let saved = AlertStruct(
            title: "DOCUMENT SAVED",
            msg: "Your scanned document\nhas been saved."
        )
        static let updated = AlertStruct(
            title: "DOCUMENT UPDATED",
            msg: "Your scanned document\nhas been updated."
        )
        static let deleted = AlertStruct(
            title: "DOCUMENT DELETED",
            msg: "Your scanned document\nhas been deleted."
        )
    }
    
    struct Insurance {
        static let unknownError = AlertStruct(
            title: "DATABASE ERROR",
            msg: "An error occurred trying to access database, try again.\n\nPlease report a well described issue to Tech Support via Contact Us from Dashboard [ℹ︎] Menu."
        )
        static let loaded = AlertStruct(
            title: "INS. POLICY LOADED",
            msg: "Your insurance policy has been loaded."
        )
        static let saved = AlertStruct(
            title: "INS. POLICY SAVED",
            msg: "Your insurance policy has been saved."
        )
        static let updated = AlertStruct(
            title: "INS. POLICY UPDATED",
            msg: "Your insurance policy has been updated."
        )
        static let deleted = AlertStruct(
            title: "INS. POLICY DELETED",
            msg: "Your insurance policy has been deleted."
        )
        static let notFound = AlertStruct(
            title: "INS. POLICY NOT FOUND",
            msg: "Your insurance policy was not found."
        )
    }
    
    struct Mail {
        static let notSetup = AlertStruct(
            title: "MAIL ISSUE",
            msg: "Your Email app has not been setup or cannot be accessed."
        )
        static let error = AlertStruct(
            title: "MAIL ERROR",
            msg: "An error occurred trying to send your Mail Message.\n\nMessage was not sent."
        )
        static let canceled = AlertStruct(
            title: "MAIL CANCELED",
            msg: "Mail Message canceled and not sent."
        )
        static let saved = AlertStruct(
            title: "MAIL SAVED",
            msg: "Mail Message saved to your Drafts Mail Folder."
        )
        static let sent = AlertStruct(
            title: "MAIL SENT",
            msg: "Your Mail Message has been sent."
        )
    }
    
    struct Messages {
        static let notSetup = AlertStruct(
            title: "MESSAGE ISSUE",
            msg: "Messages App or Messaging has not been setup or cannot be accessed."
        )
        static let error = AlertStruct(
            title: "MESSAGE ERROR",
            msg: "An error occurred trying to send your Message.\n\nMessage was not sent."
        )
        static let canceled = AlertStruct(
            title: "MESSAGE CANCELED",
            msg: "Message canceled and not sent."
        )
        static let saved = AlertStruct(
            title: "MESSAGE SAVED",
            msg: "Message saved to your Drafts Mail Folder."
        )
        static let sent = AlertStruct(
            title: "MESSAGE SENT",
            msg: "Your Message has been sent."
        )
    }
    
    struct Photo {
        static let error = AlertStruct(
            title: "FILE ERROR",
            msg: "An error occured trying to process item, process was aborted. \n\nPlease report a well described issue to Tech Support via Contact Us from Dashboard [ℹ︎] Menu."
        )
        static let saved = AlertStruct(
            title: "PHOTO SAVED",
            msg: "Your scanned photo\nhas been saved."
        )
        static let updated = AlertStruct(
            title: "PHOTO UPDATED",
            msg: "Your scanned photo\nhas been updated."
        )
        static let deleted = AlertStruct(
            title: "PHOTO DELETED",
            msg: "Your scanned photo\nhas been deleted."
        )
    }
    
    struct Preset {
        static let loaded = AlertStruct(
            title: "PRESET LOADED",
            msg: "Your preset values have been loaded."
        )
        static let saved = AlertStruct(
            title: "PRESET SAVED",
            msg: "Your preset values have been saved."
        )
        static let updated = AlertStruct(
            title: "PRESET UPDATED",
            msg: "Your preset values have been updated."
        )
        static let deleted = AlertStruct(
            title: "PRESET DELETED",
            msg: "Your preset values have been deleted."
        )
        static let blankNameError = AlertStruct(
            title: "PRESET ISSUE",
            msg: "A preset 'Name' is required to continue and cannot be blank."
        )
    }
    
    struct Record {
        static let notFound = AlertStruct(
            title: "NO LOCATION",
            msg: "The location that you entered to search for was not found.\n\nTry just the zip code, or city name."
        )
        static let saved = AlertStruct(
            title: "LOCATION SAVED",
            msg: "Location information has been saved."
        )
        static let deleted = AlertStruct(
            title: "LOCATION DELETED",
            msg: "Location has been deleted."
        )
    }
    
    struct Reminders {
        static let notSetup = AlertStruct(
            title: "REMINDER ISSUE",
            msg: "Your Reminders App has not been setup or cannot be accessed."
        )
        static let error = AlertStruct(
            title: "REMINDER ERROR",
            msg: "An error occurred trying to save your reminder item."
        )
        static let canceled = AlertStruct(
            title: "REMINDER CANCELED",
            msg: "Reminder item was canceled and not sent."
        )
        static let saved = AlertStruct(
            title: "REMINDER SAVED",
            msg: "Reminder item has been saved to your Reminders app under the SCHEDULED event.\n\nThis has a Notifications reminder set inside of the reminder where you can change the date of this corresponding calender event."
        )
        static let notAuthorized = AlertStruct(
            title: "NOT AUTHORIZED",
            msg: "Access to Reminders has be denied. Please go to Settings and grant permission to access Reminders."
        )
    }
    
    struct Scanner {
        static let notFound = AlertStruct(
            title: "SCANNER UNAVAILABLE",
            msg: "This device does not support Camera Scanning."
        )
        static let notAuthorized = AlertStruct(
            title: "NOT AUTHORIZED",
            msg: "Access to your Camera has be denied. Please go to Settings and grant permission to access Camera."
        )
        static let error = AlertStruct(
            title: "SCAN ISSUE",
            msg: "An error occurred trying to access your Camera for Scanning."
        )
        static let barcodeError = AlertStruct(
            title: "SCAN ERROR",
            msg: "An error occurred trying to scan Barcode."
        )
        static let barcodeNotFound = AlertStruct(
            title: "BARCODE: NOT FOUND",
            msg: "The item scanned from barcode was not found."
        )
        static let barcodeNotFound_Add = AlertStruct(
            title: "BARCODE: NOT FOUND",
            msg: "The item scanned from barcode was not found.\n\nDo you want to add a new item?"
        )
        static let unsupportedFormat = AlertStruct(
            title: "BARCODE: ISSUE",
            msg: "The barcode type is unsupported."
        )
        static let deleted = AlertStruct(
            title: "PRESET DELETED",
            msg: "Your preset values have been deleted."
        )
    }
    
    struct ScannedItems_Docs {
        static let unknownError = AlertStruct(
            title: "FILE ERROR",
            msg: "An unknown error occurred trying to process document, process was aborted.\n\nPlease report a well described issue to Tech Support via Contact Us from Dashboard [ℹ︎] Menu."
        )
        static let notFound = AlertStruct(
            title: "FILE NOT FOUND",
            msg: "An error occured trying to locate document, process was aborted. n\nPlease report a well described issue to Tech Support via Contact Us from Dashboard [ℹ︎] Menu."
        )
        static let error = AlertStruct(
            title: "FILE ERROR",
            msg: "An error occured trying to process document, process was aborted. n\nPlease report a well described issue to Tech Support via Contact Us from Dashboard [ℹ︎] Menu."
        )
        static let saved = AlertStruct(
            title: "DOCUMENTS SAVED",
            msg: "Your documents\nsaved succesfully."
        )
        static let updated = AlertStruct(
            title: "DOCUMENTS UPDATED",
            msg: "Your documents\nupdated succesfully."
        )
        static let deleted = AlertStruct(
            title: "DOCUMENT DELETED",
            msg: "Your document\ndeleted succesfully."
        )
        static let metadata = AlertStruct(
            title: "DOCUMENTS METADATA",
            msg: "You have scanned multiple document.\n\nRemember to set the Metadata (Type, Notes, etc.) for each new document."
        )
    }

    struct ScannedItems_Photos {
        static let unknownError = AlertStruct(
            title: "FILE ERROR",
            msg: "An unknown error occurred trying to process photo, process was aborted.\n\nPlease report a well described issue to Tech Support via Contact Us from Dashboard [ℹ︎] Menu."
        )
        static let error = AlertStruct(
            title: "FILE ERROR",
            msg: "An error occured trying to process photo, process was aborted. n\nPlease report a well described issue to Tech Support via Contact Us from Dashboard [ℹ︎] Menu."
        )
        static let saved = AlertStruct(
            title: "PHOTOS SAVED",
            msg: "Your photos\nsaved succesfully."
        )
        static let updated = AlertStruct(
            title: "PHOTOS UPDATED",
            msg: "Your photos\nupdated succesfully."
        )
        static let deleted = AlertStruct(
            title: "PHOTO DELETED",
            msg: "Your photo\ndeleted succesfully."
        )
        static let metadata = AlertStruct(
            title: "PHOTOS METADATA",
            msg: "You have scanned multiple photos.\n\nRemember to set the Metadata (Type, Notes, etc.) for each new photo."
        )
    }
}

