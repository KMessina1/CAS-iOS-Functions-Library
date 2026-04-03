/*--------------------------------------------------------------------------------------------------------------------------
    File: MailHelper.swift
  Author: Kevin Messina
 Created: Sep 29, 2020
Modified: Jun 23, 2024

©2020-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
Notes:
 
2024_11_19  Updated for iOS 18+. Reduced code size.
--------------------------------------------------------------------------------------------------------------------------*/

import SwiftUI
import MessageUI
import AVFoundation
import Foundation

struct MailView: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss
    @Binding var data: ComposeMailData
    @Binding var result: Result<MFMailComposeResult, Error>?

    enum mailSubjectType: String { case suggestion,support,contact,tellAFriend,other,supportSendData }

    struct mimeTypes {
        //Audio
        static let audioAAC: String = "audio/aac" //AAC audio
        static let audioMPEG: String = "audio/mpeg" //MP3 audio
        static let audioWAV: String = "audio/wav" //Waveform Audio Format
        //Binary
        static let binary: String = "application/octet-stream" //Binary files (default for attachments)
        //Images
        static let imageJPEG: String = "image/jpeg" //JPEG image files
        static let imagePNG: String = "image/png" //PNG image files
        static let imageTIFF: String = "image/tiff" //Tagged Image File Format (TIFF)
        //Data
        static let JSON: String = "application/json" //Used for JSON Data
        //Text
        static let textPlain: String = "text/plain" //Simple text messages (default for email body)
        static let textHTML: String = "text/html" //HTML formatted email body
        static let textCSV: String = "text/csv" //Comma-separated values (CSV)
        //Mail Message
        static let message: String = "message/rfc822" //Used for forwarding or replying with the original message as an attachment
        //Mail Attachments
        static let mixed: String = "multipart/mixed" //Used for emails with attachments, containing both text and other parts
        //PDF
        static let pdf: String = "application/pdf" //PDF documents
        //Video
        static let videoMP4: String = "video/mp4" //MP4 video
        static let videoMPEG: String = "video/mpeg" //MPEG Video
        //Zip/Archive
        static let zipArchive: String = "application/zip" //ZIP archive
    }
    
    struct ComposeMailData {
        var type: mailSubjectType = .support
        var subject: String? = ""
        var recipients: [String]? = []
        var message: String? = ""
        var attachments: [AttachmentData]? = []
    }
    
    struct AttachmentData {
        var data: Data
        var mimeType: String
        var fileName: String
    }

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailView
        
        init(_ parent: MailView) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            defer {
                parent.dismiss()
            }
            if let error = error {
                parent.result = .failure(error)
            } else {
                parent.result = .success(result)
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        var msg:String = ""
        var recipients:[String] = []
        var subject: String = ""
        
        //App Info
        let appName:String = (Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String) ?? "n/a"
        let version:String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "n/a"
        let build:String = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? "n/a"
        //Database Info
        let dbMigrations = dbFunctions().getMigrationRecords()
        let dbVersion = dbMigrations.last?.substringFromStart(4).trim(.ends) ?? "n/a (Shipped Ver)"
        //Device Info
        let osVersion = UIDevice.current.systemVersion
        let family = UIDevice.Family().typeIs()
        let model = UIDevice.modelName
        //Email Recipients Info
        let UD = UserDefaults.standard
        let email_contact = UD.string(forKey: KeyNames.Company.email_Contact) ?? ""
        let email_support = UD.string(forKey: KeyNames.Company.email_Support) ?? ""
        //App Store Recipients Info
        let appStoreURL = UD.string(forKey: KeyNames.Company.appStoreURL) ?? "n/a"
        
        var note = ""
        
        switch data.type {
            case .suggestion:
                subject = "Suggestion for \(appName)..."
                recipients = [email_contact]
                note =
                """
                ‼️ NOTE: If you have a suggestion for changing an existing feature, please attach a screenshot if applicable. If its a
                new feature please, please write New Feature. In either case, please try and explain (long descriptions are better) so
                that we can best understand the suggestion.<br>
                """
            case .support:
                subject = "Support for \(appName)..."
                recipients = [email_support]
                note =
                """
                ‼️ NOTE: If you are having a technical issue, please attach screen shots that would be helpful explaining your issue.<br>
                """
            case .supportSendData:
                subject = "Support and Data for \(appName)..."
                recipients = [email_support]
                note =
                """
                ‼️ NOTE: If you are having a technical issue, please attach screen shots that would be helpful explaining your issue.<br><br>
                Remember that you are sending text of your data to our Support Team, some of which my be considered private information.<br>br>
                Please know that we will treat your data with respect to your privacy, will not distribute, copy or sell to anyone.<br><br>
                Your data will be deleted upon completion of your support request or sooner if requested in writing to our Support Team. 
                """
            case .contact:
                subject = "Contact from \(appName)..."
                recipients = [email_contact]
                note = ""
            case .tellAFriend:
                subject = "I am recommending the app '\(appName)' for you..."
                recipients = []
                msg = "Check out \( appName ) in the AppStore:<br><br>\( appStoreURL )<br><br>I think you will like it.<br><br>"
            case .other: ()
        }
        
        if data.type != .tellAFriend {
            msg =
            """
            TECHNICAL INFO:<br>
            ----------------------<br>
            App Name: \(appName) v\(version).\(build)<br>
            Database Version: \(dbVersion)<br>
            Device OS Version: \(osVersion)<br>
            Device Type: \(family)<br>
            Device Model: \(model)<br>
            ----------------------<br>
            \(note)<br><br>
            ======================<br><br>
            Comments:<br><br>
            """
        }

        let vc = MFMailComposeViewController()
            vc.mailComposeDelegate = context.coordinator
            vc.setToRecipients(recipients)
            vc.setSubject(subject)
            vc.setMessageBody(msg, isHTML: true)
            
        if (data.attachments != nil) {
            for data in data.attachments! {
                vc.addAttachmentData(data.data, mimeType: data.mimeType, fileName: data.fileName)
            }
        }

        return vc
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) { }
    
    static func canSendMail() -> Bool {
        return MFMailComposeViewController.canSendMail()
    }
}
