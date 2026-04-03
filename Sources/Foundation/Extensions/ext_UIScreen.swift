/*--------------------------------------------------------------------------------------------------------------------------
    File: ext_UIScreen.swift
  Author: Kevin Messina
 Created: 1/25/21
Modified:
 
 ©2021-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
 NOTES:
--------------------------------------------------------------------------------------------------------------------------*/


import Foundation
import UIKit

extension UIScreen{
    static var current: UIScreen? {
        UIWindow.current?.screen
    }

    var width: CGFloat { (UIScreen.current != nil) ?UIScreen.current!.bounds.size.width :0 }
    var height: CGFloat { (UIScreen.current != nil) ?UIScreen.current!.bounds.size.height :0 }
    var size: CGSize { (UIScreen.current != nil) ?UIScreen.current!.bounds.size :CGSizeMake(0,0) }
    var isZoomed: Bool { (UIScreen.current != nil) ?UIScreen.current!.scale > UIScreen.current!.nativeScale :false }
}
