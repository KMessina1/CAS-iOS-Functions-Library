/*--------------------------------------------------------------------------------------------------------------------------
    File: SheetList_Functions.swift
  Author: Kevin Messina
 Created: 7/30/24
Modified:
 
©2024-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import SwiftUI

struct SheetList {
    let CT = CurrentTheme().getThemeFromUserStds()

    func titleBar(
        title: String,
        icon: String = "",
        showDeleteTitle: Bool = false,
        msg: String = "",
        showDefaultMsg: Bool = false,
        backColor: Color = .white
    ) -> some View {
        let defaultMsg: String = "Select an 'already entered' item from the list below. As you add or delete items, this list will reflect those changes. To enter a new item not shown, select [Cancel] to hide this sheet and type new entry in related text field."
        
        var msgTxt: String { showDefaultMsg ?defaultMsg :msg }
        
        var deleteTitle: some View {
            HStack(alignment:.center, spacing:1) {
                Text("Swipe ")
                
                Image(systemName: AppImages.arrow_Left)
                    .symbolVariant(.fill)
                    .font(.caption)
                    .foregroundStyle(.red)
                
                Text(" to DELETE")
            }
            .bold()
            .foregroundStyle(.red)
            .lineLimit(1)
            .minimumScaleFactor(0.66)
            .padding(.horizontal,15)
            .padding(.vertical,5)
            .background(
                Capsule().fill(CT.lightest)
            )
            .padding(.bottom,-5)
            .padding(.top,10)
        }
        
        return VStack(alignment: icon.isEmpty ? .center : .leading,  spacing:8){
            if icon.isEmpty {
                HStack {
                    Text(title.trim(.ends))
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                        .font(.title)
                        .bold()
                        .fontWidth(deviceIs.Pad ?.expanded :.standard)
                        .foregroundStyle(CT.lightest)
                    Spacer()
                }
                .frame(width: .infinity)

                if !msgTxt.isEmpty {
                    HStack {
                        Text(msgTxt.trim(.ends))
                            .lineLimit(2)
                            .font(.subheadline)
                            .bold()
                            .fontWidth(deviceIs.Pad ?.expanded :.standard)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(CT.fair)
                        Spacer()
                    }
                    .frame(width: .infinity)
                }
            }else{
                HStack {
                    Image.getResizable(icon)
                        .frame(width: 50, height: 50)
                        .foregroundStyle(CT.title)

                    VStack(alignment: .leading) {
                        HStack {
                            Text(title.trim(.ends))
                                .lineLimit(1)
                                .minimumScaleFactor(0.75)
                                .font(.title)
                                .bold()
                                .fontWidth(deviceIs.Pad ?.expanded :.standard)
                                .foregroundStyle(CT.lightest)
                            Spacer()
                        }
                        .frame(width: .infinity)

                        HStack {
                            Text(msgTxt.trim(.ends))
                                .lineLimit(2)
                                .font(.subheadline)
                                .bold()
                                .italic()
                                .fontWidth(deviceIs.Pad ?.expanded :.standard)
                                .multilineTextAlignment(.leading)
                                .foregroundStyle(CT.fair)
                                Spacer()
                        }
                        .frame(width: .infinity)
                    }
                    
                    Spacer()
                }
            }
            
            if showDeleteTitle {
                deleteTitle
            }
        }
        .padding(.top,20)
        .padding(.leading, 10)
    }
    
    var backgroundColor: some View {
        Rectangle()
            .foregroundStyle(Color.Lead.gradient)
            .ignoresSafeArea()
    }
}


