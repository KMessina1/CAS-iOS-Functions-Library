/*--------------------------------------------------------------------------------------------------------------------------
    File: DocScanFunctions.sswift
  Author: Kevin Messina
 Created: Jun 29, 2024
Modified:

©2024-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:

--------------------------------------------------------------------------------------------------------------------------*/

import UIKit
import VisionKit
import SwiftUI

public enum ScannedDocItemTypes: String {
    case none = "--"
    case receipt = "Reciept"
    case purchase = "Purchase Related"
    case target = "Target"
    case sale = "Sale Related"
    case insurance = "Insurance Policy"
    case certificate = "Certificate"
    case title = "Title/Ownership"
    case application = "Application/Registration"
    case documentation = "Documentation"
    case manual = "Manual/Guide"
    case other = "Other"
    
    static let arr: [String] = [
        none.rawValue,
        application.rawValue,
        certificate.rawValue,
        documentation.rawValue,
        manual.rawValue,
        insurance.rawValue,
        purchase.rawValue,
        receipt.rawValue,
        sale.rawValue,
        target.rawValue,
        title.rawValue,
        other.rawValue
    ]
}

public enum ScannedPicItemTypes: String {
    case none = "--"
    case item = "Item: Photo of Item"
    case manual = "Item: Manual/Guide"
    case driverLicense = "ID: Driver License"
    case stateID = "ID: State ID"
    case militaryID = "ID: Military ID"
    case membership = "ID: Membership ID"
    case permit = "ID: Permit/License"
    case certification = "ID: Certification"
    case target = "Range: Target"
    case rangeCard = "Range: Serssion Card"
    case other = "Other"
    
    static let arr: [String] = [
        none.rawValue,
        item.rawValue,
        manual.rawValue,
        certification.rawValue,
        driverLicense.rawValue,
        militaryID.rawValue,
        membership.rawValue,
        permit.rawValue,
        stateID.rawValue,
        target.rawValue,
        rangeCard.rawValue,
        other.rawValue
    ]
}

public enum ScannedItemType: String {
    case photo = "Photo"
    case document = "Document"
    
    static let arr: [String] = [
        document.rawValue,
        photo.rawValue
    ]
}

public struct VNDocumentCameraViewControllerRepresentable: UIViewControllerRepresentable {
    enum ScannerSaveFormats { case none, JPG, PDF }
    
    @Binding var scanResult: [UIImage]
    
    public func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = context.coordinator
        
        return documentCameraViewController
    }
    
    public func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) { }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(scanResult: $scanResult)
    }
    
    public final class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        @Binding var scanResult: [UIImage]

        init(scanResult: Binding<[UIImage]>) {
            _scanResult = scanResult
        }
        
        /// Tells the delegate that the user successfully saved a scanned document from the document camera.
        public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            controller.dismiss(animated: true, completion: nil)

            let newImages:[UIImage] = (0..<scan.pageCount).compactMap { scan.imageOfPage(at: $0) }
            scanResult.append(contentsOf: newImages)
//            scanResult = (0..<scan.pageCount).compactMap { scan.imageOfPage(at: $0) }
        }
        
        // Tells the delegate that the user canceled out of the document scanner camera.
        public func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            controller.dismiss(animated: true, completion: nil)
        }
        
        /// Tells the delegate that document scanning failed while the camera view controller was active.
        public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            print("Document scanner error: \(error.localizedDescription)")
            controller.dismiss(animated: true, completion: nil)
        }
    }
}

extension UIImage{
    public func resize(toWidth width: CGFloat) -> UIImage? {
        let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}
