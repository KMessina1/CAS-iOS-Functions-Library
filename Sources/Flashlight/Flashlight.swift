/*--------------------------------------------------------------------------------------------------------------------------
    File: BarcodeScanner.swift
  Author: Kevin Messina
 Created: 8/13/24
Modified:
 
©2024-2025 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import SwiftUI
import AVFoundation

public struct Flashlight {
    func torch(on: Bool, brightness: Float = 1.0) {
        if let currentDevice = AVCaptureDevice.default(for: AVMediaType.video), currentDevice.hasTorch {
            do {
                try currentDevice.lockForConfiguration()
                //            let torchOn = !currentDevice.isTorchActive
                try currentDevice.setTorchModeOn(level: brightness)
                currentDevice.torchMode = on ? .on : .off
                currentDevice.unlockForConfiguration()
            } catch {
                print("Torch on/off error.")
            }
        }
    }
}
