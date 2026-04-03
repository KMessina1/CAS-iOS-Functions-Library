/*--------------------------------------------------------------------------------------------------------------------------
 File: db+Help.swift
 Author: Kevin Messina
 Created: 6/9/24
 Modified:
 
 ©2024 Creative App Solutions, LLC. - All Rights Reserved.
 ----------------------------------------------------------------------------------------------------------------------------
 NOTES:
 --------------------------------------------------------------------------------------------------------------------------*/

import Foundation
import GRDB

///Usage:
///do {
///    try dbQueue.read { db in
///        let all = try Help.fetchAll(db)
///        let oneDraft = try Help.fetchOne(db)
///        let tenDrafts = try Help.limit(10).fetchAll(db)
///        let draftsCount = try Help.fetchCount(db)
///    }
///} catch {
///    print("\(error)")
///}
struct HelpItem: Codable, Equatable, FetchableRecord, MutablePersistableRecord {
    var id: Int64?
    var section: String
    var title: String
    var subTitle: String
    var detail: String
    var notes: String

    static let databaseTableName: String = "Help"
    
    private enum Columns {
        static let id = Column(CodingKeys.id)
        static let section = Column(CodingKeys.section)
        static let title = Column(CodingKeys.title)
        static let subTitle = Column(CodingKeys.subTitle)
        static let detail = Column(CodingKeys.detail)
        static let notes = Column(CodingKeys.notes)
    }
    
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}
