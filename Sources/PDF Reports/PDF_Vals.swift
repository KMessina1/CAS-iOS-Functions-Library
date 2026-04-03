/*--------------------------------------------------------------------------------------------------------------------------
    File: PDF_Vals.swift
  Author: Kevin Messina
 Created: 4/26/25
Modified:
 
©2025-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import Foundation
import UIKit
import TPPDF
import SwiftUI

struct PDFVals {
    // 72 DPI * size in inches
    let createdBy = "Created by \( AppInfo().returnCompanyInfo().name )'s \( AppInfo.appName )"
    let appImg = PDFImage(
        image: UIImage(named: AppInfo.logo) ?? UIImage(named: "NoPhotoText")!,
        size: PDFVals.inlineLogoSize,
        sizeFit: PDFImageSizeFit.widthHeight
    )
    
    // Sizes
    static let inlineImgSize = CGSize(width: 12, height: 12)
    static let inlineLogoSize = CGSize(width: 35, height: 35)
    let thumbnailSize_Square = CGSize(width: 60, height: 60)
    let thumbnailSize_Landscape = CGSize(width: 90, height: 60)
    let thumbnailSize_Portrait = CGSize(width: 60, height: 90)
    let indent: CGFloat = 0.01
    let lgIndent: CGFloat = 0.05
    let image: CGFloat = 0.15
    let icon: CGFloat = 0.03
    let title: CGFloat = 0.15
    let lgTitle: CGFloat = 0.2
    let field: CGFloat = 0.30
    //Font Sizes
    enum bodySizes: CGFloat {
        case body_10 = 10.0
        case body_12 = 12.0
    }

    // Images
    static let urlImg = PDFImage(image: UIImage(systemName: "globe")!, size: inlineImgSize)
    static let emailImg = PDFImage(image: UIImage(systemName: "envelope")!, size: inlineImgSize)
    static let phoneImg = PDFImage(image: UIImage(systemName: "phone.fill")!, size: inlineImgSize)
    static let notesImg = PDFImage(image: UIImage(systemName: "note.text")!, size: inlineImgSize)
    static let statusNotesImg = PDFImage(image: UIImage(systemName: "questionmark.app.dashed")!, size: inlineImgSize)
    
    struct bodyValues {
        let title1: String
        let val1: String
        let title2: String
        let val2: String
    }

    struct indentBodyValues {
        let title1: String
        let val1: String
    }
    
    struct textStyle {
        static let header1 = PDFTextStyle(name: "Header1", font: UIFont.systemFont(ofSize: 28.0, weight: .heavy), color: .black)
        static let header2 = PDFTextStyle(name: "Header2", font: UIFont.systemFont(ofSize: 16.0, weight: .bold), color: .black)
        static let header3 = PDFTextStyle(name: "header3", font: UIFont.systemFont(ofSize: 14.0, weight: .bold), color: .black)
        static let title = PDFTextStyle(name: "title", font: UIFont.systemFont(ofSize: 13.0, weight: .semibold), color: .black)
        static let body = PDFTextStyle(name: "body", font: UIFont.systemFont(ofSize: 12.0, weight: .regular), color: .black)
        static let body2 = PDFTextStyle(name: "body2", font: UIFont.systemFont(ofSize: 10.0, weight: .regular), color: .black)
        static let footer = PDFTextStyle(name: "footer", font: UIFont.systemFont(ofSize: 10.0, weight: .regular), color: .black)
    }
    
    struct attribs {
        static let header1: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 28.0, weight: .heavy),
            .foregroundColor: UIColor.black,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]

        static let header1_dbID: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 28.0, weight: .heavy),
            .foregroundColor: UIColor.black
        ]

        static let header2: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 14.0, weight: .semibold),
            .foregroundColor: UIColor.black,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        static let subTitle_noUnderline: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 13.0, weight: .semibold),
            .foregroundColor: UIColor.black
        ]

        static let subTitle: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 13.0, weight: .semibold),
            .foregroundColor: UIColor.black,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        static let body: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 12.0, weight: .regular),
            .foregroundColor: UIColor.black
        ]
        
        static let body2: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 10.0, weight: .regular),
            .foregroundColor: UIColor.black
        ]

        static let caption: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 9.0, weight: .medium),
            .foregroundColor: UIColor.black
        ]

        static let notes: [NSAttributedString.Key : Any] = [
            .font: UIFont(name: FontName.CourierNew.regular.rawValue, size: 9.0)!,
            .foregroundColor: UIColor.black
        ]
    }
}
