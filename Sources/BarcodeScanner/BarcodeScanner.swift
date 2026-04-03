/*--------------------------------------------------------------------------------------------------------------------------
    File: BarcodeScanner.swift
  Author: Kevin Messina
 Created: 8/13/24
Modified:
 
©2024-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import SwiftUI
import AVFoundation
import CodeScanner //External Package: github.com/twostraws/CodeScanner.git

public struct BarcodeScanner {
    public enum scannerStatusType: Int, CaseIterable, Identifiable {
        case none
        case cancelled
        case found
        case notFound
        case error
        case unsupportedFormat
        
        var id: Int { self.rawValue }
        
        var name: String {
            switch self {
                case .none: return "None"
                case .cancelled: return "Cancelled"
                case .error: return "Scan error."
                case .found: return "Barcode Found."
                case .notFound: return "Barcode Not found."
                case .unsupportedFormat: return "Unsupported Barcode Format."
            }
        }
    }

    public enum statusType: Int, CaseIterable, Identifiable {
        case none
        case cancelled
        case found_Inventory
        case notFound_Inventory
        case found_AmmoCatalog
        case notFound_AmmoCatalog
        
        var id: Int { self.rawValue }
        
        var name: String {
            switch self {
                case .none: return "None"
                case .cancelled: return "Cancelled"
                case .found_Inventory: return "Found in Inventory table."
                case .notFound_Inventory: return "Not found in Inventory table."
                case .found_AmmoCatalog: return "Found in Ammo Catalog table."
                case .notFound_AmmoCatalog: return "Not found in Ammo Catalog table."
            }
        }
    }

    public func torch(on: Bool, brightness: Float = 1.0) {
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
    
    /// If using the CODESCANNER Swift Package, this is a reusable view to be included in a sheet view.
    public struct scanView: View {
        enum ActiveAlert { case none, scanError, scanUnsupportedFormat }
        @State var activeAlert: ActiveAlert = .none
        @State var showAlert: Bool = false
        @State var isFlashlightOn: Bool = false
        @State var testData: String = ""
        @Binding var show: Bool
        @Binding var scannedCode: String
        @Binding var scannedResult: scannerStatusType

        var body: some View {
            ZStack {
                CodeScannerView(
                    codeTypes:[.upce,.ean13], //UPC-e (UPCE), UPC-a (EAN-13)
                    scanMode:.once,
                    showViewfinder:true,
                    simulatedData: testData,
                    shouldVibrateOnSuccess:true,
                    isTorchOn: isFlashlightOn
                ) { response in
                    activeAlert = .none

                    switch response {
                        case .success(let result):
                            scannedResult = .found
                            simPrint("Scanner Found barcode: \(result.string)", action: .info, log: LFFL())
                        case .failure(let error):
                            scannedResult = .notFound
                            simPrint("Scanner barcode error ", action: .error, errorMsg: error.localizedDescription, log: LFFL())
                    }

                    if case let .success(results) = response {
                        let scanResults = results.string
                        
                        if scanResults.isEmpty {
                            activeAlert = .scanUnsupportedFormat
                            scannedCode = ""
                            scannedResult = .unsupportedFormat
                        }else{
                            if scanResults.count > 12 {
                                if scanResults.hasPrefix("0") {
                                    scannedCode = scanResults.substring(fromTo: 1...scanResults.count)
                                }else{
                                    scannedCode = scanResults.substring(fromTo: 0...scanResults.count - 1)
                                }
                            }else{
                                scannedCode = scanResults
                            }
                            activeAlert = .none
                        }
                    }else{
                        activeAlert = .scanError
                        scannedResult = .error
                        scannedCode = ""
                    }
                    
                    if activeAlert != .none {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            showAlert.toggle()
                        }
                    }

                    show = false
                }
                
                VStack(alignment: .leading) {
                    HStack{
                        Button(action: {
                            scannedResult = .cancelled
                            show = false
                        }, label: {
                            Image.getResizable(AppImages.xMark)
                                .frame(width:25,height:25)
                                .foregroundStyle(.white)
                        })
                        .padding(.all,10)
                        .glassEffect(
                            .regular
                            .tint(.white.opacity(0.2))
                        )
                        .padding([.top,.leading],10)
                        .cornerRadius(15)

                        Spacer()
                        
                        Button(action: {
                            isFlashlightOn.toggle()
                        }, label: {
                            Image.getResizable(isFlashlightOn ?AppImages.lightbulb_On :AppImages.lightbulb_Off)
                                .frame(width:20,height:20)
                                .foregroundStyle(.yellow)
                        })
                        .padding(.all,15)
                        .glassEffect(
                            .regular
                                .tint(deviceIs.Sim || deviceIs.CanvasPreview ?.gray.opacity(0.2) :.yellow.opacity(0.2))
                        )
                        .padding([.top,.trailing],10)
                        .cornerRadius(15)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Text("⚠️ Unsupported barcodes will not scan. ⚠️")
                            .font(.callout)
                            .bold()
                            .lineLimit(1)
                            .minimumScaleFactor(0.66)
                            .foregroundStyle(.white)
                            .padding(.horizontal,12)
                            .padding(.vertical,2)
                            .background(
                                Capsule().fill(.red.opacity(0.2))
                            )
                            .padding(.horizontal, 10)
                        
                        Spacer()
                    }
                    .padding(.horizontal,20)
                    .padding(.bottom,5)
                }
                .alert(isPresented: $showAlert, content: {
                    switch activeAlert {
                        case .scanError: return alertType(AT.Scanner.barcodeError)
                        case .scanUnsupportedFormat: return alertType(AT.Scanner.unsupportedFormat)
                        default: return alertType(AT.App.defaultType)
                    }
                })
            }
            .presentationCornerRadius(20)
            .presentationDetents([.height(300)])
            .presentationDragIndicator(.hidden)
            .interactiveDismissDisabled()
        }
    }
}
