/*--------------------------------------------------------------------------------------------------------------------------
    File: PDF_Functions.swift
  Author: Kevin Messina
 Created: 7/18/25
Modified:
 
©2025-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import Foundation
import SwiftUI

/// Saves origin file to \documents directory.
/// - Parameters:
///   - fileURL: URL AND Path for PDF
///   - newFilename: Renamed fle
func PDF_Import(from fileURL: URL, newFilename: String) {
    let FM = FileManager.default
    let documentsDirectory = Files().getPathURL(in: .tempDir)
    let newPDFURL = documentsDirectory.appendingPathComponent(newFilename)
    
    guard
        fileURL.startAccessingSecurityScopedResource()
    else {
        print("Error starting security scope for accessing shared file folder.")
        return
    }
    
    defer {
        fileURL.stopAccessingSecurityScopedResource()
    }
    
    do {
        try FM.copyItem(at: fileURL, to: newPDFURL)
        print("Imported PDF: \(fileURL.lastPathComponent)")
    } catch {
        print("Error importing PDF from remote files location: \(error)")
    }
}

func PDF_SaveData(data: Data, filename: String, in dir: Files.directories) {
    let fileURL = Files().getPathForFilename(filename, in: dir).url

    guard
        fileURL.startAccessingSecurityScopedResource()
    else {
        return
    }
    
    defer {
        fileURL.stopAccessingSecurityScopedResource()
    }
    
    do {
        try data.write(to: fileURL, options: .atomic)
        
        print("PDF saved successfully at: \(fileURL.path)")
    } catch {
        print("Error saving PDF: \(error.localizedDescription)")
    }
}


