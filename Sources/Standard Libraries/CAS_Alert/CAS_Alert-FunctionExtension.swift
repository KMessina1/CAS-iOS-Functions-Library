/*--------------------------------------------------------------------------------------------------------------------------
    File: CAS_Alert-FunctionExtension.swift
  Author: Kevin Messina
 Created: May 29, 2022
Modified:

©2022-2023 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES: REQUIRES ext_Strings library OR uncomment the string commands.
 
--------------------------------------------------------------------------------------------------------------------------*/


import Foundation
import SwiftUI
 
extension String {
    func height(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = self
        label.font = font
        label.sizeToFit()
        
        return label.frame.height
    }
    
    func markdownToAttributed() -> AttributedString {
        do {
            return try AttributedString(
                markdown: self.trim(.trailing),
                options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)
            )
        } catch {
            return AttributedString("Error parsing markdown: \(error)")
        }
    }
    
    // MARK: TRIMMING
    enum TrimmingOptions {
        case replaceAll
        case leading
        case trailing
        case ends
    }
    
    func trim(_ spaces: TrimmingOptions, using characterSet: CharacterSet = .whitespacesAndNewlines) ->  String {
        switch spaces {
            case .replaceAll: return trimAllSpaces(using: characterSet)
            case .leading: return trimLeadingSpaces(using: characterSet)
            case .trailing: return trimTrailingSpaces(using: characterSet)
            case .ends:  return trimLeadingAndTrailingSpaces(using: characterSet)
        }
    }
    
    private func trimLeadingSpaces(using characterSet: CharacterSet) -> String {
        guard let index = firstIndex(where: { !CharacterSet(charactersIn: String($0)).isSubset(of: characterSet) }) else {
            return self
        }
        
        return String(self[index...])
    }
    
    private func trimTrailingSpaces(using characterSet: CharacterSet) -> String {
        guard let index = lastIndex(where: { !CharacterSet(charactersIn: String($0)).isSubset(of: characterSet) }) else {
            return self
        }
        
        return String(self[...index])
    }
    
    private func trimLeadingAndTrailingSpaces(using characterSet: CharacterSet) -> String {
        return trimmingCharacters(in: characterSet)
    }
    
    private func trimAllSpaces(using characterSet: CharacterSet) -> String {
        return components(separatedBy: characterSet).joined()
    }
}

extension CAS_Alert {
    func textHeight(
        screenHeight:CGFloat,
        containerWidth:CGFloat,
        message:String,
        notation:String,
        messageSize:CGFloat,
        notationSize:CGFloat,
        safeArea:CGFloat
    ) -> (height: CGFloat,scrolls: Bool) {
        let textHeight1:CGFloat = message.isEmpty
            ? 0.0
            : message.height(constraintedWidth: containerWidth - 40, font: UIFont.systemFont(ofSize: messageSize, weight: .regular))
        let textHeight2:CGFloat = notation.isEmpty
            ? 0.0
            : notation.height(constraintedWidth: containerWidth - 40, font: UIFont.systemFont(ofSize: notationSize, weight: .regular))
        let textHeight:CGFloat = notation.isEmpty
            ? textHeight1 + textHeight2
            : textHeight1 + 40 + textHeight2
        
        if textHeight < 50.0 {
            return (50,false)
        }else if textHeight > (screenHeight - safeArea) {
            return ((screenHeight - safeArea),true)
        }else{
            return (textHeight,false)
        }
    }
    
    func iconBackground(
        iconSize:CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ?120.0 : 60.0,
        imageName:String,
        iconColor:Color = Color.white,
        backgroundColor:Color
    ) -> some View {
        let size = iconSize
        let circleBackground1:CGFloat = ((size * 2) / 1.05)
        let circleBackground2:CGFloat = ((size * 2) / 1.20)
        let circleBackground3:CGFloat = ((size * 2) / 1.25)
            
        return ZStack {
            Circle()
                .fill(backgroundColor)
                .frame(width: circleBackground1, height: circleBackground1)
            
            Circle()
                .fill(iconColor)
                .frame(width: circleBackground2, height: circleBackground2)
            
            Circle()
                .fill(backgroundColor)
                .frame(width: circleBackground3, height: circleBackground3)
            
            Image(imageName)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(iconColor)
                .frame(width: size, height: size)
        }
    }
}
