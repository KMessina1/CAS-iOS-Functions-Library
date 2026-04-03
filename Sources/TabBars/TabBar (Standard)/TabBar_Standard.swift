/*--------------------------------------------------------------------------------------------------------------------------
    File: TabBar_Standard.swift
  Author: Kevin Messina
 Created: Dec 29, 2020
Modified: Jan 22, 2021
 
©2020-2024 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
Notes:

01/23/21 - Added fontsize for all tabs.
--------------------------------------------------------------------------------------------------------------------------*/

import SwiftUI
import Foundation

extension Image {
    func tabBarIconModifier(width:CGFloat,height: CGFloat,color:Color) -> some View {
        self
            .resizable()
            .renderingMode(.template)
            .foregroundColor(color)
            .aspectRatio(contentMode: .fit)
            .frame(width: width, height: height)
            .padding(.top, 10)
    }

    func tabBarSystemIconModifier(width:CGFloat,height: CGFloat) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: width, height: height)
            .padding(.top, 10)
    }
}


//struct TabBar_Standard: View {
//    var iconIsSFSymbol: Bool = true
//    var assignedPage: Int
//    var width, height: CGFloat
//    var fontSize: CGFloat = deviceIs.Pad ?22 : 14
//    var icon, title: String
//    var colorActive: Color
//    var colorInactive: Color
//
//    var body: some View {
//        let isCurrentPage = (viewRouter.currentPage == assignedPage)
//        let fontSizeZoomed = UIDevice.isZoomed ?fontSize - 5 :fontSize
//        
//        VStack {
//            if iconIsSFSymbol {
//                Image(systemName: icon)
//                    .tabBarSystemIconModifier(width: width, height: height)
//            }else{
//                Image(icon)
//                    .tabBarIconModifier(width: width, height: height,color:isCurrentPage ?colorActive : colorInactive)
//            }
//            
//            Text(title)
//                .font(Font.custom(FontName.AvenirNextCondensed.regular, size: fontSizeZoomed))
//                .fontWeight(.light)
//                .bold()
//                .lineLimit(1)
//                .padding(.horizontal,deviceIs.Pad ?8 :5)
//                .padding(.vertical,deviceIs.Pad ?4 :2)
//                .background(
//                    Capsule().fill(isCurrentPage ?colorActive.opacity(0.33) :Color.clear)
//                        .overlay(
//                            Capsule().strokeBorder(isCurrentPage ?colorActive.opacity(0.5) :Color.clear,lineWidth: deviceIs.Pad ?2 :1)
//                        )
//                )
//            
//            Spacer()
//        }
//        .foregroundColor(isCurrentPage ? colorActive : colorInactive)
//        .onTapGesture { viewRouter.currentPage = assignedPage }
//    }
//}

