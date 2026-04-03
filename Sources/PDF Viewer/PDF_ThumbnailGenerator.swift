/*--------------------------------------------------------------------------------------------------------------------------
    File: PDF_ThumbnailGenerator.swift
  Author: Kevin Messina
 Created: 4/16/25
Modified:
 
©2025-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import SwiftUI
import PDFKit

func PDF_GenerateUIImage(
    filename: String,
    in inDir: Files.directories,
    size thumbnailSize: CGSize = CGSize(width: 80, height: 100),
    atPage pageIndex: Int = 0
) -> UIImage {
    let NoimgFile: UIImage = UIImage(named: "NoPhotoText")!
    let documentUrl: URL = Files().getPathForFilename(filename, in: inDir).url
    let pdfDocument = PDFDocument(url: documentUrl)
    let pdfDocumentPage = pdfDocument?.page(at: pageIndex)

    return pdfDocumentPage?.thumbnail(of: thumbnailSize, for: PDFDisplayBox.trimBox) ?? NoimgFile
}

func PDF_GenerateUIImageFromURL(_ fileURL: URL) -> UIImage? {
    let FM = FileManager.default
    let fileName = fileURL.lastPathComponent
    let documentsDirectory = Files().getPathURL(in: .docsDir)
    
    let newPDFURL = documentsDirectory.appendingPathComponent(fileName)
    
    guard
        fileURL.startAccessingSecurityScopedResource()
    else {
        return nil
    }
    
    defer {
        fileURL.stopAccessingSecurityScopedResource()
    }
    
    do {
        try FM.copyItem(at: fileURL, to: newPDFURL)
        
        let tempImg = PDF_GenerateUIImage(filename: fileName, in: .docsDir)
        
        try FM.removeItem(at: newPDFURL)
        
        return tempImg
    } catch {
        return nil
    }
}

func PDF_GenerateUIImageWithResults(
    filename: String,
    fileURL: URL,
    size thumbnailSize: CGSize = CGSize(width: 80, height: 100),
    atPage pageIndex: Int = 0
) -> (uiImage: UIImage, success: Bool) {
    let NoimgFile: UIImage = UIImage(named: "NoPhotoText")!
    let pdfDocument = PDFDocument(url: fileURL)
    let pdfDocumentPage = pdfDocument?.page(at: pageIndex)
    
    let pdfImage: UIImage? = pdfDocumentPage?.thumbnail(of: thumbnailSize, for: PDFDisplayBox.trimBox) ?? nil
    let isSuccess: Bool = (pdfImage != nil)
    let finalImg = isSuccess ?pdfImage! :NoimgFile
    
    return (finalImg, isSuccess)
}
