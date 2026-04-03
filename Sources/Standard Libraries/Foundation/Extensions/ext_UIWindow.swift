/*--------------------------------------------------------------------------------------------------------------------------
    File: ext_UIWindow.swift
  Author: Kevin Messina
 Created: 10/4/25
Modified:
 
©2025-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import SwiftUI

extension UIWindow {
    static var current: UIWindow? {
        for scene in UIApplication.shared.connectedScenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            for window in windowScene.windows {
                if window.isKeyWindow { return window }
            }
        }

        return nil
    }
    
    func getScreenWidth() -> CGFloat {
        // Look for the first connected window scene that is active
        let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
        
        // Use the screen associated with that scene, or fallback to the window bounds
        return windowScene?.screen.bounds.width ?? 0
    }
}
