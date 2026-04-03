/*--------------------------------------------------------------------------------------------------------------------------
    File: Crop.swift
  Author: Kevin Messina
 Created: 6/21/24
Modified:
 
©2024-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import SwiftUI

enum Crop: Equatable {
    case circle
    case square
    case rectangle
    case custom(CGSize)
    
    func name() -> String {
        switch self {
        case .circle: return "Circle"
        case .square: return "Square"
        case .rectangle: return "Rectangle"
        case .custom(let cGSize):
            return "Custom \( Int(cGSize.width) )x\( Int(cGSize.height) )"
        }
    }
    
    func size() -> CGSize {
        switch self {
        case .circle: return .init(width: 300, height: 300)
        case .square: return .init(width: 300, height: 300)
        case .rectangle: return .init(width: 300, height: 500)
        case .custom(let cGSize): return cGSize
        }
    }
}

