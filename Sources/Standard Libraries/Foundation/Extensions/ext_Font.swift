/*------------------------------------------------------------------------------------------------------------------------
    File: ext_Font.swift
  Author: Kevin Messina
 Created: 05/28/2025
Modified:
 
©2025-2026 Creative App Solutions, LLC. - All Rights Reserved.
--------------------------------------------------------------------------------------------------------------------------
NOTES:
------------------------------------------------------------------------------------------------------------------------*/

import Foundation
import SwiftUI
import UIKit

extension UIFont {
    static func fractionFont(ofSize pointSize: CGFloat) -> UIFont {
        let systemFontDesc = UIFont.systemFont(ofSize: pointSize).fontDescriptor
        let featureSettings: [UIFontDescriptor.FeatureKey: Int] = [
            .type: kFractionsType,
            .selector: kDiagonalFractionsSelector,
        ]
        let attributes = [
            UIFontDescriptor.AttributeName.featureSettings: [
                featureSettings
            ]
        ]
        let fractionFontDesc = systemFontDesc.addingAttributes(attributes)
        return UIFont(descriptor: fractionFontDesc, size: pointSize)
    }
}

extension Font {
    static func fraction(_ style: UIFont.TextStyle) -> Font {
        let preferredFont = UIFont.preferredFont(forTextStyle: style)
        let size = preferredFont.pointSize
        return Font(UIFont.fractionFont(ofSize: size) as CTFont)
    }
}
