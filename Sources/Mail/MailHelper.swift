/*--------------------------------------------------------------------------------------------------------------------------
    File: MailHelper.swift
  Author: Kevin Messina
 Created: Sep 29, 2020
Modified:

©2020-2022 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
Notes:

--------------------------------------------------------------------------------------------------------------------------*/

import SwiftUI
import MessageUI

/* USAGE DIRECTIONS:
 
 @State var showMail:Bool = false

 // Placed in functionality....
 Button {
    mailData = ComposeMailData(type: .contact, recipients:[employee.email])
    showMail.toggle()
 } label: {
    Label("Send Email to \"\(name)\"", systemImage: appImages.email.rawValue)
 }//End Button
 .disabled(employee.email.isEmpty || !EmailHelper.shared.canSendMail())
 .sheet(isPresented: $showMail) {
    EmailHelper.MailView(data: $mailData) { result in
    switch result {
        case .success(_): showMailSent.toggle()
        case .failure(_): showMailFailed.toggle()
    }
 
    simPrint(type: .info, msg: result, log: logFileFunctionLine())
 }

*/


typealias MailViewCallback = ((Result<MFMailComposeResult, Error>) -> Void)?

struct ComposeMailData {
    var type: mailSubjectType
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

enum mailSubjectType: String { case suggestion,support,contact,tellAFriend,other }

/// MailHelper
/// ---
/// ie: @State private var mailData = ComposeMailData(subject: .contact)
///     @State private var mailData = ComposeMailData(
///         subject: .other,
///         recipients: ["a@yahoo.com"],
///         message:"Hello",
///         attachments:[AttachmentData(data: "Some text".data(using: .utf8)!,mimeType: "text/plain",fileName: "text.txt")]
///     )
///
///     MailHelper.shared.canSendMail() ? showMailView.toggle() : showAlertNoMail.toggle()
///
public class MailHelper: NSObject, MFMailComposeViewControllerDelegate {
    public static let shared = EmailHelper()
    private override init() { }
    
    struct MailView: UIViewControllerRepresentable {
        @Environment(\.presentationMode) var presentation
        @Binding var data: ComposeMailData
        
        let callback: MailViewCallback

        class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
            @Binding var presentation: PresentationMode
            @Binding var data: ComposeMailData
            let callback: MailViewCallback
            
            init(
                presentation: Binding<PresentationMode>,
                data: Binding<ComposeMailData>,
                callback: MailViewCallback)
            {
                _presentation = presentation
                _data = data
                self.callback = callback
            }
            
            func mailComposeController(_ controller: MFMailComposeViewController,didFinishWith result: MFMailComposeResult,
                error: Error?)
            {
                if let error = error {
                    callback?(.failure(error))
                } else {
                    callback?(.success(result))
                }

                $presentation.wrappedValue.dismiss()
            }
        }
        
        func makeCoordinator() -> Coordinator {
            Coordinator(presentation: presentation, data: $data, callback: callback)
        }
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
            var title = data.subject ?? ""
            var to:[String] = data.recipients ?? []
            var message:String = data.message ?? ""
            
            let appName:String = (Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String) ?? "n/a"
            let version:String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "n/a"
            let build:String = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? "n/a"
            let UD = UserDefaults.standard
            let email_info = UD.string(forKey: "appInfo.Company.Info") ?? "n/a"
            let email_support = UD.string(forKey: "appInfo.Company.Support") ?? "n/a"
            let appStoreURL = UD.string(forKey: "app.appStoreURL") ?? "n/a"

            switch data.type {
                case .suggestion:
                    title = "Suggestion for \(appName) \(version).\(build)..."
                    to = [email_info]
                    message = ""
                case .support:
                    title = "Technical Support for \(appName) \(version).\(build)..."
                    to = [email_support]
                    message = ""
                case .contact:
                    title = "Contact from \(appName) \(version).\(build)..."
                    to = [email_info]
                    message = ""
                case .tellAFriend:
                    title = "\(appName) has been recommended for you to check out..."
                    to = [email_info]
                    message = "Check out \( appName ) in the Apple App Store:\n\n\( URL(string: appStoreURL)! ) "
                case .other: ()
            }

            let vc = MFMailComposeViewController()
                vc.mailComposeDelegate = context.coordinator
                vc.setSubject(title)
                vc.setToRecipients(to)
                vc.setMessageBody(message, isHTML: true)
            
                data.attachments?.forEach {
                    vc.addAttachmentData($0.data, mimeType: $0.mimeType, fileName: $0.fileName)
                }
            
                vc.accessibilityElementDidLoseFocus()

            return vc
        }
        
        func updateUIViewController(_ uiViewController: MFMailComposeViewController,context: UIViewControllerRepresentableContext<MailView>){ }
    }

    func canSendMail() -> Bool {
        return MFMailComposeViewController.canSendMail()
    }
}


