/*--------------------------------------------------------------------------------------------------------------------------
    File: db_WhatsNew.swift
  Author: Kevin Messina
 Created: 6/7/25
Modified:
 
©2025-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import Foundation
import GRDB

///Usage:
///do {
///    try db.Queue().Queue_WhatsNew.read { dbTable in
///        let all = try WhatsNewItem.fetchAll(dbTable)
///        let oneDraft = try WhatsNewItem.fetchOne(dbTable)
///        let tenDrafts = try WhatsNewItem.limit(10).fetchAll(dbTable)
///        let draftsCount = try WhatsNewItem.fetchCount(dbTable)
///    }
///} catch {
///    print("\(error)")
///}
public struct WhatsNewItem: Codable, Equatable, FetchableRecord, MutablePersistableRecord {
    var id: Int64?
    var version: Double
    var sortOrder: Int
    var title: String
    var detail: String
    var iconName: String
    
    static let databaseTableName: String = "WhatsNew"
    
    internal enum Columns {
        static let id = Column(CodingKeys.id)
        static let version = Column(CodingKeys.version)
        static let sortOrder = Column(CodingKeys.sortOrder)
        static let title = Column(CodingKeys.title)
        static let detail = Column(CodingKeys.detail)
        static let iconName = Column(CodingKeys.iconName)
    }
    
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}
