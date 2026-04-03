/*--------------------------------------------------------------------------------------------------------------------------
    File: ViewRouter.swift
  Author: Kevin Messina
 Created: 3/9/24
Modified:
 
©2024 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import Foundation
import Observation

/// Used by ViewRouter
//enum Page: Int { case splash,home,income,employeeList,addEmployee,fixedAssets }

// MARK: - *** APP IMAGES ***
/// View Router PAGE number
///
/// This is the basic set of view router page numbers used across many standard apps.
/// To EXTEND this list, add a new section in your code by:
///
///     extension Pages {
///         static let line = Pages(rawValue: "line")
///     }
///
/// - Returns: Integer of Page Number (aka screen number)
struct Page: RawRepresentable,Equatable {
    var rawValue: Int

    static func ==(lhs: Page, rhs: Page) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
    
    static let splash = 0
    static let home = 1
    static let settings = 2
}

@Observable class ViewRouter {
    var currentPage: Int = Page(rawValue: UserDefaults.standard.integer(forKey: KeyNames.App.currentPage)).rawValue
    
    func saveCurrentPage() {
        let UD:UserDefaults = .standard
        
        UD.setValue(UD.isKeyPresent(KeyNames.App.currentPage)
                    ?self.currentPage
                    :Page.home,
                    forKey: KeyNames.App.currentPage
        )
        
        UD.synchronize()
        
        simPrint(
            type: .info,
            msg: "Saving next startup screen as \( self.currentPage ) (\( self.currentPage )).",
            log: logFileFunctionLine()
        )
    }
    
    func loadCurrentPage() {
        let UD:UserDefaults = .standard
        
        let storedValue:Int = UD.isKeyPresent(KeyNames.App.currentPage)
            ? UD.integer(forKey: KeyNames.App.currentPage)
            : Page.splash
        
        self.currentPage = Page(rawValue: storedValue).rawValue
        
        simPrint(
            type: .info,
            msg: "Setting current startup screen as \( self.currentPage ) (\( self.currentPage )).",
            log: logFileFunctionLine()
        )
    }
}

