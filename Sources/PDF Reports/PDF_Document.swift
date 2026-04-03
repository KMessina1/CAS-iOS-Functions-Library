/*--------------------------------------------------------------------------------------------------------------------------
    File: PDF_Document.swift
  Author: Kevin Messina
 Created: 4/26/25
Modified:
 
©2025-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import TPPDF
import SwiftUI

extension PDFVals {
    // MARK: - *** ENUMS ***
    enum NotesImagesTypes { case notes, status }
    enum orientationType: Int { case landscape,portrait,square }
    
    // MARK: - *** DOCUMENT FUNCTIONS ***
    func generatePDF(doc: PDFDocument, filename: String) {
        let url = Files().returnPathForFilename(filename, in: .reportsDir).url
        let generator = PDFGenerator(document: doc)
        
        do {
            try generator.generate(to: url)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func docSetup(rptTitle: String, subject: String, bodySize: bodySizes = .body_12) -> PDFDocument {
        let doc = PDFDocument(layout: PDFVals.layout().USLetter_HalfInchBorder)
        doc.info.author = AppInfo.appName
        doc.info.subject = subject
        doc.info.title = rptTitle
        doc.set(font: UIFont.systemFont(ofSize: bodySize.rawValue))
        doc.set(textColor: UIColor.black)
        doc.pagination.style = .customClosure({ page, total in
            return "Page \(page) of \(total)"
        })
        doc.pagination.container = .footerRight
        
        return doc
    }

    // MARK: - *** LAYOUT SETTINGS ***
    struct pageSize {
        static let USLetter: CGSize = CGSize(width: 612, height: 792)
        static let USLegal: CGSize = CGSize(width: 612, height: 1008)
    }
    
    struct marginEdgeInset {
        static let halfInch: UIEdgeInsets = UIEdgeInsets(top: 36, left: 36, bottom: 36, right: 36)
    }
    
    struct lineStyle {
        static let solid: PDFLineStyle = PDFLineStyle(type: .full, color: .darkGray, width: 0.5)
        static let bold: PDFLineStyle = PDFLineStyle(type: .full, color: .black, width: 1.0)
    }
    
    struct layout {
        var USLetter_HalfInchBorder: PDFPageLayout {
            var layout = PDFPageLayout()
            layout.margin = PDFVals.marginEdgeInset.halfInch
            layout.size = PDFVals.pageSize.USLetter
            
            return layout
        }
    }

    // MARK: - *** REPORT FUNCTIONS ***
    func dividerLine(thickness: CGFloat, style: PDFLineType, doc: PDFDocument) {
        doc.add(.contentCenter, space: 10)
        doc.addLineSeparator(PDFContainer.contentLeft, style: PDFLineStyle(type: style, color: .black, width: thickness))
        doc.add(.contentCenter, space: 15)
    }

    func reportDetailTitle(title: String, doc: PDFDocument) {
        doc.add(.contentCenter, space: 5)
        doc.add(textObject: PDFSimpleText(text: "\(title)", style: PDFVals.textStyle.title))
        doc.add(.contentCenter, space: 2)
    }

    func reportDetailSubTitle(title: String, doc: PDFDocument) {
        doc.add(.contentCenter, space: 5)
        doc.add(.contentLeft, attributedText: PDFVals().attribSubTitle("\(title)"))
        doc.add(.contentCenter, space: 2)
    }

    func dividerTitleWithLines(title: String, thickness: CGFloat, style: PDFLineType, doc: PDFDocument) {
        doc.add(.contentCenter, space: 10)
        doc.addLineSeparator(PDFContainer.contentLeft, style: PDFLineStyle(type: style, color: .black, width: thickness))
        doc.add(.contentCenter, space: 2.5)
        doc.add(textObject: PDFVals().reportListItemTitle(title))
        doc.addLineSeparator(PDFContainer.contentLeft, style: PDFLineStyle(type: style, color: .black, width: thickness))
        doc.add(.contentCenter, space: 15)
    }

    func dividerLineIfNotLast(count: Int, maxCount: Int, style: PDFLineType = .full, doc: PDFDocument) {
        if count < (maxCount - 1) {
            doc.add(.contentCenter, space: 10)
            doc.addLineSeparator(PDFContainer.contentLeft, style: PDFLineStyle(type: style, color: .black, width: 1.0))
            doc.add(.contentCenter, space: 5)
        }
    }

    func reportTitle(_ rptTitle: String, dbID: String = "") -> PDFSection {
        let section = PDFSection(columnWidths: [0.08, 0.92])
        section.columns[0].add(.left, image: PDFVals().appImg)
        section.columns[1].add(.left, attributedText: PDFVals().title(rptTitle: rptTitle, dbID: dbID))
        
        return section
    }
    
    func reportListItemTitle(_ title: String, style: PDFTextStyle = PDFVals.textStyle.header2) -> PDFSimpleText {
        let title = PDFSimpleText(text: title, style: style)
        
        return title
    }
    
    func reportListDefaultImage(category: String, type: String, subType:  String, indent: CGFloat = 0.01)
    -> (section: PDFSection, orientation: orientationType, height: CGFloat) {
        var imgName: String = ""

        if category == ICU.Firearm.name {
            imgName = FirearmType().getImgName(name: type, logLFFL: LFFL())
        } else if category == ICU.Accessory.name {
            imgName = AccessoryTypes().getImgName(type: type, name: subType, logLFFL: LFFL())
        } else if category == ICU.Supply.name {
            imgName = SupplyType().getImgName(category: type, name: subType, logLFFL: LFFL())
        } else if category == ICU.Ammunition.name {
            imgName = AppImages.Ammo.assortedAmmo
        }

        let img: PDFImage = PDFImage(image: UIImage().get(imgName), size: thumbnailSize_Square, sizeFit: .widthHeight)
        let imgSection = PDFSection(columnWidths: [indent, 1 - indent])
        imgSection.columns[1].add(.left, image: img)

        return (section: imgSection, orientation: .portrait, height: thumbnailSize_Square.height)
    }
    
    func reportListItemImage(_ filename: String, in dir: Files.directories, indent: CGFloat = 0.01, maxSize: CGSize = CGSize(width: 90, height: 60))
    -> (section: PDFSection, orientation: orientationType, height: CGFloat) {
        let imgInfo = PDFVals().imgFromFile(filename, in: dir)
        let newWd: CGFloat = min(imgInfo.size.width, maxSize.width)
        let newHt: CGFloat = min(imgInfo.size.height, maxSize.height)
        
        let img = PDFImage(image: imgInfo.uImg, size: CGSize(width: newWd, height: newHt), sizeFit: .widthHeight)
        let imgSection = PDFSection(columnWidths: [indent, 1 - indent])
        imgSection.columns[1].add(.left, image: img)
        
        return (section: imgSection, orientation: imgInfo.orientation, height: newHt)
    }
}


