/*--------------------------------------------------------------------------------------------------------------------------
    File: ShareSheet.sswift
  Author: Kevin Messina
 Created: Jun 19, 2022
Modified:

©2022-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:

--------------------------------------------------------------------------------------------------------------------------*/

import UIKit
import SwiftUI

///
/// Usage:
///
///     @State var showShareSheet: Bool = false
///
///     ...
///
///      .toolbar{
///        ToolbarItem(placement: .topBarLeading) {
///            Button(action: {
///                showShareSheet.toggle()
///            }, label: {
///                Image(systemName: "square.and.arrow.up")
///                    .font(.callout)
///                    .fontWeight(.semibold)
///                HStack {
///                    Text("Share")
///                }
///            })
///            .tint(CT.lightest)
///        }//End ToolbarItem
///    }//End Toolbar
///    .sheet(isPresented: $showShareSheet, content: {
///        ActivityViewController(itemsToShare: [URL(string: "https://developer.apple.com/xcode/swiftui/")!])
///    })
///
struct ActivityViewController: UIViewControllerRepresentable {
    var itemsToShare: [Any]
    var servicesToShareItem: [UIActivity]? = nil
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: itemsToShare, applicationActivities: servicesToShareItem)
        return controller
    }
    
    func updateUIViewController(
        _ uiViewController: UIActivityViewController,
        context: UIViewControllerRepresentableContext<ActivityViewController>) {
    }

}

