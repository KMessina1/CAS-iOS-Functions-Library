/*--------------------------------------------------------------------------------------------------------------------------
    File: GRDB-Setup.swift
  Author: Kevin Messina
 Created: 3/22/25
Modified:
 
©2025-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import Foundation
import GRDB
import SwiftUI

struct dbFunctions {
    // MARK: *** DB SETUP FUNCTIONS ***
    enum databaseTypes: Int { case primary, help, whatsNew }

    func setupSQL_Database(dbType: databaseTypes, overwrite: Bool = false, updateVersion: Int = 0, versionOverwrite: Bool = false) {
        var storedVersionKey = ""
        var dbFilename: String = ""

        switch dbType {
            case .primary:
                storedVersionKey = Databases.primaryDB.versionKey
                dbFilename = Databases.primaryDB.fullFilename
            case .help:
                storedVersionKey = Databases.helpDB.versionKey
                dbFilename = Databases.helpDB.fullFilename
            case .whatsNew:
                storedVersionKey = Databases.whatsNewDB.versionKey
                dbFilename = Databases.whatsNewDB.fullFilename
        }

        let storedVersion = UserDefaults.standard.integer(forKey: storedVersionKey)

        //Copy Database to docs directory so it can be written to
        if overwrite {
            overwritedb()
        } else if versionOverwrite {
            if !Files().exists(filename: dbFilename, in: .docsDir) {
                copydb()
            }else if updateVersion > storedVersion {
                overwritedb()
            }
        }else{
            copydb()
        }

        UserDefaults.standard.set(updateVersion, forKey: storedVersionKey)
        UserDefaults.standard.synchronize()

        setDatabaseQueue()
        
        // MARK: - *** FUNCTIONS ***
        func setDatabaseQueue() {
            let dbPath = Files().getPathForFilename(dbFilename, in: .docsDir).path
            switch dbType {
                case .primary: dbQueue_Data = try! DatabaseQueue(path: dbPath)
                case .help: dbQueue_Help = try! DatabaseQueue(path: dbPath)
                case .whatsNew: dbQueue_WhatsNew = try! DatabaseQueue(path: dbPath)
            }
        }
        
        func copydb() {
            if !Files().exists(filename: dbFilename, in: .docsDir) {
                Files().copyFromBundle(fileName: dbFilename, to: .docsDir)
                simPrint("Database: \(dbFilename) copied from Main Bundle to Documents.", action: .database, log: LFFL())
            }else{
                simPrint("Database: \(dbFilename) already exists in Documents, not copied.", action: .database, log: LFFL())
            }
        }

        func deletedb() {
            if Files().exists(filename: dbFilename, in: .docsDir) {
                Files().delete(fileName: dbFilename, in: .docsDir)
                simPrint("Database: \(dbFilename) deleted from Documents, preapring for new copy overwrite.", action: .database, log: LFFL())
            }
        }

        func overwritedb() {
            deletedb()
            copydb()
        }
    }

    // MARK: *** DB MIGRATION FUNCTIONS ***
    func dbSchemaVersion() -> Int32 {
        var schemaVersion: Int32 = -1
        
        do {
            try dbQueue_Data.read { dbTable in
                schemaVersion = try dbTable.schemaVersion()
            }

            return schemaVersion
        }catch{
            simPrint("!!!!! Migration: Version Failed on read. Error \(error.localizedDescription)", action: .error, log: LFFL())
        }
        
        return  schemaVersion
    }
    
    func dbUserVersion() -> Int {
        var userVersion: Int = -1

        do {
            try dbQueue_Data.read { dbTable in
                userVersion = try UpdateVersion.orderByPrimaryKey().fetchOne(dbTable)?.version ?? -1
            }
        }catch{
            simPrint("!!!!! Migration: Version Failed on read. Error \(error.localizedDescription)", action: .error, log: LFFL())
        }
        
        return userVersion
    }
    
    func ShowDbInfo() -> Void {
        let repeats = 100
        let primaryFilePath = Files().getPathForFilename(Databases.primaryDB.fullFilename, in: .docsDir).path
        
        if !runtimeIs().Release {
            simPrint(String(repeating: "=", count: repeats), action: .noPrefix,log: "",LF_Start: true)
            /* dbTable info */
            simPrint("    Type: SQLite", action: .noPrefix,log: "")
            simPrint(" Wrapper: GRDB", action: .noPrefix,log: "")
            simPrint("  Schema: v\( dbSchemaVersion() )", action: .noPrefix,log: "")
            simPrint("    User: v\( dbUserVersion() )", action: .noPrefix,log: "")
            simPrint("Filepath: \( primaryFilePath )", action: .noPrefix,log: "",forceShow: true)
            simPrint(String(repeating: "=",  count: repeats), action: .noPrefix,log: "",LF_End: true,forceShow: true)
        }
    }
        
    func dbVersionNeedsUpdate(dbType: databaseTypes) -> (needsUpdate: Bool, ver: Int) {
        var needsUpdate:Bool = false
        var storedVersionKey = ""
        var dbFilename: String = ""
        let table: String = "Version"

        switch dbType {
            case .primary: 
                storedVersionKey = "version.primary"
                dbFilename = Databases.primaryDB.fullFilename
            case .help:
                storedVersionKey = "version.help"
                dbFilename = Databases.helpDB.fullFilename
            case .whatsNew:
                storedVersionKey = Databases.whatsNewDB.versionKey
                dbFilename = Databases.whatsNewDB.fullFilename
        }

        @AppStorage(storedVersionKey) var storedVersion: Int = 0

        let queryVersion: String = "SELECT * FROM \(table) WHERE id=(SELECT max(id) FROM \(table)) LIMIT 1;"
        
        do {
            switch dbType {
                case .primary:
                    try dbQueue_Data.read { dbTable in
                        let tableExists = try dbTable.tableExists(table)
                        if tableExists {
                            if let lastRec = try VersionItem.fetchOne(dbTable, sql: queryVersion) {
                                needsUpdate = (lastRec.version > storedVersion)
                                storedVersion = lastRec.version
                            }
                        }
                    }
                case .help:
                    try dbQueue_Help.read { dbTable in
                        let tableExists = try dbTable.tableExists(table)
                        if tableExists {
                            if let lastRec = try VersionItem.fetchOne(dbTable, sql: queryVersion) {
                                needsUpdate = (lastRec.version > storedVersion)
                                storedVersion = lastRec.version
                            }
                        }else{
                            needsUpdate = true
                        }
                    }
                case .whatsNew:
                    try dbQueue_WhatsNew.read { dbTable in
                        let tableExists = try dbTable.tableExists(table)
                        if tableExists {
                            if let lastRec = try VersionItem.fetchOne(dbTable, sql: queryVersion) {
                                needsUpdate = (lastRec.version > storedVersion)
                                storedVersion = lastRec.version
                            }
                        }else{
                            needsUpdate = true
                        }
                    }
            }
        } catch {
            simPrintDB(type: .error, action: .fetchOne, table: table, msg: "Error getting version \(error.localizedDescription).",log: LFFL())
        }
        
        simPrint("DB needs updating: \(dbFilename): \(needsUpdate ?"Yes" :"No")", action: .database, log: LFFL())
        
        return (needsUpdate, storedVersion)
    }

    func updateDatabase() {
        //Attempt Migration if needed
        do {
            simPrint("db migration attempt if needed...)...", action: .database, log: LFFL())
            try dbMigration().dbMigrator.migrate(dbQueue_Data)
        } catch {
            simPrint("db migration attempt error: \(error.localizedDescription).", action: .error, log: LFFL())
            print("\(error)")
        }
    }
    
    func hasCompletedMigrations() -> Bool {
        let migrator = DatabaseMigrator()
        var migrations: Bool = false
        
        do {
            try dbQueue_Data.read { dbTable in
                try migrations = migrator.hasCompletedMigrations(dbTable)
            }
        } catch {
            simPrintDB(type: .error, action: .fetchOne, found: 0, table: "grdb_migrations", msg: error.localizedDescription, log: LFFL())
        }
        
        return migrations
    }
    
    func getMigrationRecords() -> [String] {
        var records:[Row] = []
        var migrations: [String] = []
        
        let query = "SELECT identifier FROM grdb_migrations;"
        
        do {
            try dbQueue_Data.inDatabase { dbTable in
                records = try Row.fetchAll(dbTable, sql: "SELECT * FROM grdb_migrations ORDER BY identifier DESC;")
            }
            simPrintDB(type:.success,action:.fetchAll,found:records.count,table:"grdb_migrations",query:query, log: LFFL())
        } catch {
            simPrintDB(type:.error,action:.fetchAll,table:"grdb_migrations",query:query,msg:error.localizedDescription, log: LFFL())
        }
        
        for rec in records {
            migrations.append(rec["identifier"]!)
        }
        
        return migrations
    }
}
