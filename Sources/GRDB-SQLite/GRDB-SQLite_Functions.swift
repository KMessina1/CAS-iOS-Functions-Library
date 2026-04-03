/*--------------------------------------------------------------------------------------------------------------------------
    File: GRDB-SQLite_Functions.swift
  Author: Kevin Messina
 Created: Aug 18, 2020
Modified: May 12, 2021
 
©2020-2022 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
Notes:

2021_05_12 - Change Settings.DatabaseTableName to the more generic passed parameter of table for various functions.
           - Added filter for suffixing ASC and DESC to query unless ORDER BY is not empty.
2021_01_25 - Added initDBQue(filename:String)
--------------------------------------------------------------------------------------------------------------------------*/

import Foundation
import GRDB
import SwiftUI

var dbQueue_Data: DatabaseQueue!
var dbQueue_Help: DatabaseQueue!
var dbQueue_WhatsNew: DatabaseQueue!

struct db {
    class Version {
        var Schema: Int32 = 0
        var User: Int = 0
    }

    struct ID {
        static let none: Int64 = -1
        static let temp: Int64 = -99
        static let deselected: Int64 = -999
    }
}

enum dbActionType { case none,insert,update,delete }

/// Console Usage: po alertData.allItems(limit: 1)
protocol AllItems {
    func allItems(limit: Int) -> [String: Any]
}

extension AllItems {
    func allItems(limit: Int = Int.max) -> [String: Any] {
        return props(obj: self, count: 0, limit: limit)
    }
    
    private func props(obj: Any, count: Int, limit: Int) -> [String: Any] {
        let mirror = Mirror(reflecting: obj)
        var result: [String: Any] = [:]
        for (prop, val) in mirror.children {
            guard let prop = prop else { continue }
            if limit == count {
                result[prop] = val
            } else {
                let subResult = props(obj: val, count: count + 1, limit: limit)
                result[prop] = subResult.count == 0 ? val : subResult
            }
        }
        return result
    }
}

protocol Loopable {
    var allProperties: [String: Any] { get }
}

extension Loopable {
    var allProperties: [String: Any] {
        var result = [String: Any]()
        Mirror(reflecting: self).children.forEach { child in
            if let property = child.label {
                result[property] = child.value
            }
        }
        return result
    }
}

/// Functions that query/change SQLite databases.
struct SQL {
    // MARK: - *** INIT DatabaseQueue ***
    func copyFromMainBundleAndInitInDocsDirAndInitdb(filename:String) -> DatabaseQueue {
        if !Files().exists(filename: filename, in: .docsDir) {
            Files().copyFromBundle(fileName: filename, to: .docsDir)
        }

        do {
            let dbURL:URL = Files().getPathURL(in: .docsDir).appendingPathComponent(filename)
            
            return try DatabaseQueue(path: dbURL.path)
        }catch{
            fatalError("'\( filename.uppercased() )' could not be initialized as GRDB SQL Database Queue.")
        }
    }

// MARK: - *** GET ***
    func get(
        dbQue:DatabaseQueue,
        select:String? = "",
        table:String,
        where whereCondition:String? = "",
        orderBy:String? = "",
        ascending:Bool? = true
    ) throws -> [Row] {
        var records:[Row] = []
        
        var query = ""
        query += (select!.isEmpty) ?"SELECT * FROM \(table)" :"SELECT \(select!) FROM \(table)"
        query += (whereCondition!.isEmpty) ?"" :" WHERE \(whereCondition!)"
        query += (orderBy!.isEmpty) ?"" :" ORDER BY \(orderBy!)"
        if !orderBy!.isEmpty { query += ascending! ?" ASC" :" DESC" }
        query += ";"
        
        do {
            try dbQue.inDatabase { dbTable in
                records = try Row.fetchAll(dbTable, sql: query)
            }
            simPrintDB(type:.success,action:.fetchAll,found:records.count,table:table,query:query, log: LFFL())
        } catch {
            simPrintDB(type:.error,action:.fetchAll,table:table,query:query,msg:error.localizedDescription, log: LFFL())
        }
        
        return records
    }

    func getFirstRecordIndex(
        dbQue:DatabaseQueue,
        table:String,
        orderBy:String
    ) throws -> Int64 {
        var records:[Row] = []
        
        let query = "SELECT * FROM \(table) ORDER BY \(orderBy) ASC LIMIT 1;"
        
        do {
            try dbQue.inDatabase { dbTable in
                records = try Row.fetchAll(dbTable, sql: query)
            }

            simPrintDB(type:.success,action:.fetchAll,found:records.count,table:table,query:query, log: LFFL())

            return records.first?["indx"] ?? db.ID.none
        } catch {
            simPrintDB(type:.error,action:.fetchAll,table:table,query:query,msg:error.localizedDescription, log: LFFL())
            return -1
        }
    }

    func getRecordIndex(
        dbQue:DatabaseQueue,
        table:String,
        whereBy:String,
        orderBy:String
    ) throws -> Int64 {
        var records:[Row] = []
        
        let query = "SELECT * FROM \(table) WHERE \(whereBy) ORDER BY \(orderBy) ASC LIMIT 1;"
        
        do {
            try dbQue.inDatabase { dbTable in
                records = try Row.fetchAll(dbTable, sql: query)
            }
            
            simPrintDB(type:.success,action:.fetchAll,found:records.count,table:table,query:query, log: LFFL())
            
            return records.first?["indx"] ?? db.ID.none
        } catch {
            simPrintDB(type:.error,action:.fetchAll,table:table,query:query,msg:error.localizedDescription, log: LFFL())
            return -1
        }
    }

    func getWithQuery(
        dbQue:DatabaseQueue,
        query:String,
        table:String
    ) throws -> [Row] {
        var records:[Row] = []
        
        do {
            try dbQue.inDatabase { dbTable in
                records = try Row.fetchAll(dbTable, sql: query)
            }
            simPrintDB(type:.success,action:.fetchAll,found:records.count,table:table,query:query, log: LFFL())
        } catch {
            simPrintDB(type:.error,action:.fetchAll,table:table,query:query,msg:error.localizedDescription, log: LFFL())
        }
        
        return records
    }

    func getCount(
        dbQue:DatabaseQueue,
        table:String
    ) throws -> Int {
        var count:Int = 0
        let query = "SELECT COUNT(*) FROM \(table);"
        
        do {
            try dbQue.inDatabase { dbTable in
                count = try Row.fetchAll(dbTable, sql: query).count
            }
            simPrintDB(type:.success,action:.fetchAll,found:count,table:table,query:query, log: LFFL())
        } catch {
            simPrintDB(type:.error,action:.fetchAll,table:table,query:query,msg:error.localizedDescription, log: LFFL())
        }
        
        return count
    }

// MARK: - *** UPDATE ***
    @discardableResult func update(
        dbQue:DatabaseQueue,
        table:String,
        fieldsAndVals:[String : AnyObject],
        where whereCondition:String? = ""
    ) throws -> Bool {
        var fields:String = ""
        var count = 0
        for (key,value) in fieldsAndVals {
            fields += "\(key)='\(value)'"
            
            count += 1
            if count < fieldsAndVals.count {
                fields += ","
            }
        }
        
        var query = "UPDATE \(table) SET \(fields)"
        
        if whereCondition!.isEmpty {
            query += ";"
        }else{
            query += " WHERE \(whereCondition!);"
        }
        
        do {
            try dbQue.inDatabase { dbTable in
                try dbTable.execute(sql: query)
            }
            
            simPrintDB(type:.success,action:.update,found:1,table:table,query:query, log: LFFL())
            return true
        } catch {
            simPrintDB(type:.error,action:.update,table:table,query:query,msg:error.localizedDescription, log: LFFL())
            return false
        }
    }
    
    @discardableResult func updateRecord(
        dbQue:DatabaseQueue,
        table:String,
        fieldsAndValsArray:[[String : AnyObject]],
        where whereCondition:String? = ""
    ) throws -> Bool {
        var fields:String = ""
        var count = 0
        for keyValuePair in fieldsAndValsArray {
            for (key,value) in keyValuePair {
                fields += "\(key)='\(value)'"
                
                count += 1
                if count < fieldsAndValsArray.count {
                    fields += ","
                }
            }
        }
        
        var query = "UPDATE \(table) SET \(fields)"
        
        if whereCondition!.isEmpty {
            query += ";"
        }else{
            query += " WHERE \(whereCondition!);"
        }
        
        do {
            try dbQue.inDatabase { dbTable in
                try dbTable.execute(sql: query)
            }
            
            simPrintDB(type:.success,action:.update,found:1,table:table,query:query, log: LFFL())
            return true
        } catch {
            simPrintDB(type:.error,action:.update,table:table,query:query,msg:error.localizedDescription, log: LFFL())
            return false
        }
    }
    
// MARK: - *** DELETE ***
    @discardableResult func delete(dbQue:DatabaseQueue,table:String,where whereCondition:String? = "") throws ->Bool {
        var query = "DELETE FROM \(table)"
        
        if whereCondition!.isEmpty {
            query += ";"
        }else{
            query += " WHERE \(whereCondition!);"
        }
        
        do {
            try dbQue.inDatabase { dbTable in
                try dbTable.execute(sql: query)
            }
            
            simPrintDB(type:.success,action:.delete,found:1,table:table,query:query, log: LFFL())
            return true
        } catch {
            simPrintDB(type:.error,action:.delete,table:table,query:query,msg:error.localizedDescription, log: LFFL())
            return false
        }
    }
    
// MARK: - *** INSERT ***
    @discardableResult func insert(dbQue:DatabaseQueue,table:String,cols:String,values:String) throws -> (success:Bool,error:SQL.error) {
        let query = "INSERT INTO \( table ) (\( cols )) VALUES (\( values ));"
        
        do {
            try dbQue.inDatabase { dbTable in
                try dbTable.execute(sql: query)
            }
            
            simPrintDB(type:.success,action:.insert,found:1,table:table,query:query, log: LFFL())
            return (true,.none)
        } catch {
            simPrintDB(type:.error,action:.insert,table:table,query:query,msg:error.localizedDescription, log: LFFL())
            return (false,.insertFailure)
        }
    }

    
// MARK: - *** ERROR FUNCTIONS ***
    enum error:Error { case none, recordNotFound, insertFailure, deleteFailure, updateFailure,  unknownFailure }

    struct errorAlert {
        var title:String
        var message:String
        var dismissButtonText:String = "OK"
    }
    
    func getErrorMsg(_ error:error) -> (errorAlert) {
        switch error {
            case .none: return errorAlert.init(title: "", message: "")
            case .recordNotFound: return errorAlert.init(title: "DATABASE ERROR", message: "Record not found.")
            case .insertFailure: return errorAlert.init(title: "DATABASE ERROR", message: "Failed to add new record.")
            case .deleteFailure: return errorAlert.init(title: "DATABASE ERROR", message: "Failed deleting record.")
            case .updateFailure: return errorAlert.init(title: "DATABASE ERROR", message: "Failed updating record.")
            case .unknownFailure: return errorAlert.init(title: "DATABASE ERROR", message: "An unknown SQL Failure has occurred.")
        }
    }
    
    func getErrorMsgAlert(_ err:error) -> Alert {
        let dbAlert = getErrorMsg(err)
        
        return Alert(title: Text(dbAlert.title), message: Text(dbAlert.message))
    }
}

extension Row {
    /** CAS: Returns tuple of GRDB SQLite Database's Row data in [String:AnyObject] format.
     
     * Version: 1.0
     * Author: Creative App Solutions
     
     - Example: let dict = try Row.fetchAll(dbTable, CalibersAndGauges.all()).map { $0.asDictionary }
     
     - Requires: GRDB Sqlite
     - Returns: [String:AnyObject] Dictionary of Row data.
     **/
    var asDictionary:[String:AnyObject] {
        var dict:[String:AnyObject] = [:]
        
        for (column, dbValue) in self {
            dict[column] = dbValue.storage.value as AnyObject
        }
        
        return dict
    }
}


