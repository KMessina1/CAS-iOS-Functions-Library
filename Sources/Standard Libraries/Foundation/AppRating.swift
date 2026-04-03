/*--------------------------------------------------------------------------------------------------------------------------
    File: AppRating.swift
  Author: Kevin Messina
 Created: Jan 7, 2020
Modified: May 14, 2024

©2020-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:

2024/05/14 - Converted to SwiftUI 5.9/iOS 17
2020/11/02 - Converted to SwiftUI
--------------------------------------------------------------------------------------------------------------------------*/

import Foundation
import SwiftUI
import StoreKit

/// Functions relating to StoreKit App Rating functionality.
struct AppRating {
    var minimumMilestoneCount_Event1:Int = 10
    var minimumMilestoneCount_Event2:Int = 5

    @AppStorage(KeyNames.App.Rating.MilestoneCount.event1) var eventCount_1: Int = 0
    @AppStorage(KeyNames.App.Rating.MilestoneCount.event2) var eventCount_2: Int = 0
    @AppStorage(KeyNames.App.Rating.lastBuildVersion) var ratingLastBuildVersion: String = "1.0"

    @MainActor
    func displayReview() -> Void {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            AppStore.requestReview(in: scene)
//            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    @ViewBuilder func buttonForTestingView() -> some View {
        Button(action: {
            AppRating().showReviewIfMilestoneReached(forceShowForTest: true)
        }, label: {
            Text("Show App Store Review")
        })
        .bold()
        .foregroundStyle(.white)
        .buttonStyle(.borderedProminent)
        .tint(.red)
    }
    
    @MainActor
    func showReviewIfMilestoneReached(forceShowForTest:Bool) -> Void {
        simPrint("AppRating: Show review", action: .detail, log: LFFL())

        if (forceShowForTest && !runtimeIs().Release) {
            displayReview()
            simPrint("AppRating: Forced Review from AppDelegate requested from AppStore", action: .detail_1, log: LFFL())

            return
        }

        let currentVersion = AppInfo.version
        let isNewVersion: Bool = currentVersion != ratingLastBuildVersion
        let hasReachedEventLimit_1: Bool = eventCount_1.isMultiple(of: minimumMilestoneCount_Event1)
        let hasReachedEventLimit_2: Bool = eventCount_2.isMultiple(of: minimumMilestoneCount_Event2)
        let hasReachedTotalEventsLimit: Bool = hasReachedEventLimit_1 && hasReachedEventLimit_2
        let okToShowRatingRequest: Bool = isNewVersion && hasReachedTotalEventsLimit

        if okToShowRatingRequest {
            simPrint("AppRating: Review requested from AppStore", action: .detail, log: LFFL())
            displayReview()
            eventCount_1 = 0
            eventCount_2 = 0
            ratingLastBuildVersion = currentVersion
            simPrint("AppRating: Milestone count reset to 0", action: .detail_1, log: LFFL())
        } else {
            eventCount_1 += 1
            eventCount_2 += 1
            simPrint("AppRating: Milestone counts incremented.",action: .detail_2, log: LFFL())
            simPrint("AppRating: Milestone counts are not enough for App Store Review.",action: .detail_2, log: LFFL())
        }
    }
}

