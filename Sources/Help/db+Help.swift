/*--------------------------------------------------------------------------------------------------------------------------
 File: db+Help.swift
 Author: Kevin Messina
 Created: 6/9/24
 Modified:
 
 ©2024-2026 Creative App Solutions, LLC. - All Rights Reserved.
 ----------------------------------------------------------------------------------------------------------------------------
 NOTES:
 --------------------------------------------------------------------------------------------------------------------------*/

import Foundation
import GRDB

///Usage:
///do {
///    try db.Queue().Queue_Help.read { dbTable in
///        let all = try Help.fetchAll(dbTable)
///        let oneDraft = try Help.fetchOne(dbTable)
///        let tenDrafts = try Help.limit(10).fetchAll(dbTable)
///        let draftsCount = try Help.fetchCount(dbTable)
///    }
///} catch {
///    print("\(error)")
///}
struct HelpItem: Codable, Equatable, FetchableRecord, MutablePersistableRecord {
    var id: Int64?
    var section: String
    var sortOrder: Int
    var title: String
    var subTitle: String
    var detail: String
    var notes: String

    static let databaseTableName: String = "Help"
    
    internal enum Columns {
        static let id = Column(CodingKeys.id)
        static let section = Column(CodingKeys.section)
        static let sortOder = Column(CodingKeys.sortOrder)
        static let title = Column(CodingKeys.title)
        static let subTitle = Column(CodingKeys.subTitle)
        static let detail = Column(CodingKeys.detail)
        static let notes = Column(CodingKeys.notes)
    }
    
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}
