/*--------------------------------------------------------------------------------------------------------------------------
    File: lib_Functions.swift
  Author: Kevin Messina
 Created: 6/21/23
Modified:
 
©2023-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import Foundation
import Swift
import SwiftUI

// MARK: Filter Characters and limit length
/// filterTextAndLimitLength
/// - Parameters:
///   - text: String to be processed.
///   - chars: Acceptable characters in resultant string.
///   - length: if > 0, then limits length. Enter 0 for unlimited.
/// - Returns: string filtered by chars parameter and limited in length if length parameter > 0
func filterTextAndLimitLength(_ text:String, chars:String, length: Int) -> String {
    var newText = text.filter(chars.contains) // Filter allowable characters in set
    
    if length > 0 { //Limit num chars
        newText = String(newText.prefix(length))
    }
    
    return newText
}

func limitValue(oldValue:Double, newValue:Double, maxValue: Double) -> Double {
    return (newValue > maxValue) ?oldValue :newValue
}

func imgHasAFilledVersionOrNot(_ systemName: String) -> Image {
    if UIImage(systemName: "\(systemName).fill") != nil {
        return Image(systemName: "\(systemName).fill").symbolRenderingMode(.multicolor)
    }else{
        return Image(systemName: systemName).symbolRenderingMode(.multicolor)
        
    }
}

// MARK: - *** DEBUG ***
public enum SimPrintDisplayType { case all,errorsOnly }
public var simPrintDisplay: SimPrintDisplayType = .all

public enum simPrintType { case
    //General
    info,noPrefix,
    //Status
    success,warning,error,
    //Details
    detail,detail_1,detail_2,
    //API
    API,API_Weather,API_Location,API_GeoLocation,
    //Files
    folder,document,photo,
    //Data
    database,record,recordSaved,recordDeleted,recordUpdated,recordDetail,recordFetch,
    //Text Messaging
    txtMsg_NoSubject,txtMsg_NoAttachment,
    //Appear/Disappear of views
    viewAppear,viewDisappear,
    //Archiving Functions
    zipArchive,unZipArchive
}

public enum simPrintSubject { case
    //General
    none,
    //Function
    calculation,UI,
    //Database
    dbFunction,
    //API
    API,API_Weather,API_Location,API_GeoLocation
}

public enum simPrintDBType { case success,warning,error,info,skipped }

public enum simPrintDBAction:String {
    case fetchAll = "FetchAll"
    case fetchOne = "FetchOne"
    case fetchCount = "FetchCount"
    case update = "Update"
    case delete = "Delete"
    case alreadyExists = "AlreadyExists"
    case insert = "Insert"
    case upsert = "Upsert"
    case migrate = "Migrate"
    case cloudRead = "cloud: Read"
    case cloudWrite = "cloud: Write"
    case cloudDelete = "cloud: Delete"
}

public enum simPrintDBMigrationAction:String {
    case insert = "Insert"
    case upsert = "Upsert"
    case alter = "Alter"
    case delete = "Delete"
    case drop = "Drop"
    case create = "Create"
    case rename = "Rename"
    case add = "Add"
    case copy = "Copy"
    case update = "Update"
    case exists = "Exists"
    case migration = "Migration"
    case replace = "Replace"
    case skip = "Skip"
}

public enum simPrintDBMigrationItem:String {
    case table = "Table"
    case record = "Record"
    case column = "Columns"
    case none = ""
}

public enum simPrintDBMigrationIssues:String {
    case duplicate = "Duplicate (Already exists)"
    case exists = "Exists as named"
    case notFound = "Not Found"
    case none = ""
    case error = "Error"
}


/// simPrint
///
/// Usage:   simPrint("AppRating: Show review", action: .detail, log: LFFL())
///
/// - Parameters:
///   - action: simPrintType
///   - msg: msg description
///   - errorMsg: Error message if thist info (from enum)
///   - subType: Subject Matter if thist info (from enum)
///   - file: #file file description
///   - function: #function function description
///   - line: #line line description
///   - log: log: LFFL() - must be run from point in code to get line and function info.
///   - LF_Start: true/false (purely aesthetic pretty printing line feed)
///   - LF_End: true/false (purely aesthetic pretty printing line feed)
///   - forceShow: true/false (force show is to not check for simulator or canvas running)
///
public func simPrint(
    _ msg:String,
    action:simPrintType,
    subType:simPrintSubject = .none,
    errorMsg:String = "",
    file:String = "",
    function:String = "",
    line:Int = -1,
    log:String,
    LF_Start:Bool = false,
    LF_End:Bool = false,
    forceShow:Bool = false
) {
    if !(
        deviceIs.Sim ||
        (deviceIs.Phone && simPrintDisplay == .all) ||
        deviceIs.CanvasPreview ||
        forceShow == true
    ) {
        return
    }
    
    if (
        simPrintDisplay != .all &&
        action != .error &&
        forceShow == false
    ) {
        return
    }
    
    var txt:String = ""
    
    if LF_Start {
        txt = "\n\n"
    }

    switch action {
        case .API: txt.append("🛜")
        case .API_Weather: txt.append("🛜🌦️")
        case .API_Location: txt.append("🛜🧭")
        case .API_GeoLocation: txt.append("🛜🏠")
        case .info: txt.append("ℹ️")
        case .detail: txt.append("🔤")
        case .detail_1: txt.append("└──➤ ")
        case .detail_2: txt.append("└─────➤ ")
        case .success: txt.append("ℹ️✅")
        case .warning: txt.append("ℹ️⚠️")
        case .error: txt.append("ℹ️‼️")
        case .folder: txt.append("📂 ")
        case .document: txt.append("📝")
        case .photo: txt.append("🏞️")
        case .noPrefix: txt = ""
        case .database: txt.append("🗄️")
        case .record: txt.append("💿")
        case .recordDetail: txt.append("└──➤ 💿")
        case .recordFetch: txt.append("🗄️➤💿")
        case .recordSaved,.recordUpdated: txt.append("💿✅")
        case .recordDeleted: txt.append("💿❌")
        case .txtMsg_NoSubject,.txtMsg_NoAttachment: txt.append("💬❌")
        case .viewAppear: txt.append("📲✅")
        case .viewDisappear: txt.append("📲❌")
        case .zipArchive: txt.append("🗄️⇲")
        case .unZipArchive: txt.append("🗄️⇱")
    }

    switch subType {
        case .none: break
        case .calculation: txt.append("🧮")
        case .dbFunction: txt.append("🗃️")
        case .UI: txt.append("🎨")
        case .API_Weather: txt.append("🛜🌦️")
        case .API_Location: txt.append("🛜🧭")
        case .API_GeoLocation: txt.append("🛜🏠")
        case .API: txt.append("🛜🌐")
    }
    
    switch action {
        case .error:
            txt.append(msg.isEmpty ?"\(errorMsg)\(log)" :"\(msg) (\(errorMsg)) \(log)")
        default:
            txt.append("\(msg)\(log)")
    }

    if LF_End {
        txt.append("\n")
    }

    print(txt)
}

/// Alias to logFileFunctionLine() function that returns the location of the place in your code that the call was made from.
/// - Parameters:
///   - fileName: Filename that the function is in
///   - functionName: Function name that was called
///   - lineNumber: Line# function called from
///   - columnNumber: Col# within the Line# function called from
/// - Returns: ex: └──➤ Called by GRDB-Setup.swift - copydb.Queue() at line# 70 [col#: 122]
func LFFL(fileName: String = #filePath,functionName: String = #function,lineNumber: Int = #line,columnNumber: Int = #column) -> String {
    return logFileFunctionLine(fileName: fileName,functionName: functionName,lineNumber: lineNumber,columnNumber: columnNumber)
}

func logFileFunctionLine(fileName: String = #filePath,functionName: String = #function,lineNumber: Int = #line,columnNumber: Int = #column) -> String {
    return "\n└──➤ Called by \(URL(fileURLWithPath: fileName).lastPathComponent) - \(functionName) @ line# \(lineNumber) [col#: \(columnNumber)]"
}

func simPrintDetails(errorMsg:String = "",file:String = #file,function:String = #function,line:Int = #line,col:Int = #column) -> String {
    var txt:String = "\n└─➤Called by:"
    
    if !file.isEmpty {
        let fileName:String = URL(fileURLWithPath: file).lastPathComponent
        txt.append("\n└──➤🗂FILENAME: \( fileName ) ")
    }
    
    if !function.isEmpty {
        txt.append("🔠FUNCTION: \( function ) ")
    }
    
    if (line >= 0) {
        txt.append("\n└──➤#️⃣COLUMN#: \( col ) " )
    }
    
    if (col >= 0) {
        txt.append("\n└──➤#️⃣LINE#: \( line ) " )
    }
    
    
    if !errorMsg.isEmpty {
        txt.append("\n└──➤❌ERROR: \( errorMsg )")
    }
    
    return txt
}

public func simPrintDB(
    type:simPrintDBType,
    action:simPrintDBAction,
    found:Int = 0,
    table:String,
    db:String = "",
    query:String = "",
    msg:String = "",
    file:String = "",
    function:String = "",
    line:Int = -1,
    log:String = "",
    LF_Start:Bool = false,
    LF_End:Bool = false
) {
    if !(deviceIs.Sim || deviceIs.CanvasPreview) {
        return
    }

    if ((simPrintDisplay != .all) && (type != .error)) {
        return
    }
    
    var txt:String = ""
    let database = db.isEmpty ? AppInfo.dataBase1 :db
    var recordCount = found
    
    if LF_Start {
        txt.append("\n")
    }

    switch type {
        case .success: txt.append("🗄✅ DB Success; ")
        case .warning: txt.append("🗄⚠️ DB Warning; ")
        case .info: txt.append("🗄ℹ️ dbTable info; ")
        case .error:
            txt.append("🗄❌ DB Error; ")
            recordCount = 0
        case .skipped: txt.append("🗄➥ DB Skipped; ")
    }
    
    txt.append("\(action.rawValue) from \(table) in \(database)")
    
    switch action {
        case .fetchAll,.fetchOne,.fetchCount: txt.append(", Found \(recordCount) records. ")
        case .update: txt.append(", Updating 1 record. ")
        case .delete: txt.append(", Deleting 1 record. ")
        case .insert: txt.append(", Inserting 1 record. ")
        case .upsert: txt.append(", Upserting 1 record. ")
        case .migrate: txt.append(", migrating database. ")
        case .alreadyExists: txt.append(", DUPLCIATE: Already exists in table/database. ")
        case .cloudRead: txt.append(", Reading 1 Record. ")
        case .cloudWrite: txt.append(", Writing 1 Record. ")
        case .cloudDelete: txt.append(", Deleting 1 Record. ")
    }

    if !msg.isEmpty {
        txt.append(msg)
    }

    txt.append("Query: \(String(describing: query.isEmpty ?"n/a" :query))")
    txt.append(log)
    
    if LF_End {
        txt.append("\n")
    }

    print(txt)
}



public func simPrintDBMigration(
    type: simPrintDBType,
    action: simPrintDBMigrationAction,
    item: simPrintDBMigrationItem,
    issue: simPrintDBMigrationIssues,
    table: String = "",
    columns: String = "",
    msg: String,
    log: String,
    migrationID: String
) {
    var txt = ""

    switch type {
        case .success: txt.append("DB MIGRATION: ---->🗄✅ DB Success; ")
        case .warning: txt.append("DB MIGRATION: ---->🗄⚠️ DB Warning; ")
        case .error: txt.append("DB MIGRATION: ---->🗄❌ DB Error; ")
        case .info: txt.append("DB MIGRATION: ---->🗄ℹ️ dbTable info; ")
        case .skipped: txt.append("DB MIGRATION: ---->🗄➥ DB Skipped; ")
    }
    
    switch action {
        case .alter: txt.append("Altering")
        case .delete: txt.append("Deleting")
        case .insert: txt.append("Inserting")
        case .upsert: txt.append("Upserting")
        case .drop: txt.append("Dropping")
        case .create: txt.append("Creating")
        case .rename: txt.append("Renaming")
        case .add: txt.append("Adding")
        case .copy: txt.append("Copying")
        case .update: txt.append("Updating")
        case .exists: txt.append("Exists")
        case .migration: txt.append("Migrating")
        case .replace: txt.append("Replacing")
        case .skip: txt.append("Skipping")
    }

    switch item {
        case .table: txt.append(" table")
        case .record: txt.append(" record")
        case .column: txt.append(" column")
        case .none: txt.append(" n/a")
    }

    switch issue {
        case .duplicate: txt.append(", DUPLICATE: Already exists in table/database.")
        case .notFound: txt.append(", NOT FOUND in table/database.")
        case .none: txt.append("")
        case .error: txt.append(", Error.")
        case .exists: txt.append(", EXISTS: Already exists as named.")
    }

    txt.append(", Msg: \(msg)")
    txt.append(log)

    txt.append(", DB Migration for ID: \(migrationID)")
    
    print("\(txt)\n")
}

