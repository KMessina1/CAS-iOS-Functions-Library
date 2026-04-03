/*--------------------------------------------------------------------------------------------------------------------------
    File: TabBar_PopupMenu.swift
  Author: Kevin Messina
 Created: Dec 28, 2020
Modified:
 
©2020-2022 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import SwiftUI

// MARK: - *** CONTENT ***
struct TabBar_PopupMenu: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

// MARK: - *** SUBVIEWS ***
struct TabBarIcon: View {
    @ObservedObject var viewRouter: ViewRouter
    @Binding var showPopUp: Bool
    
    let assignedPage: Page
    let width, height: CGFloat
    let icon, title: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width, height: height)
                .padding(.top, 10)
            
            Text(title)
                .font(.footnote)
            
            Spacer()
        }
        .foregroundColor(viewRouter.currentPage == assignedPage
                            ? showPopUp ?Color.yellow.opacity(0.4) :.yellow
                            : showPopUp ?Color.gray.opacity(0.5) :.gray
        )
        .padding(.horizontal, -2)
        .onTapGesture {
            viewRouter.currentPage = assignedPage
        }
    }
}

struct TabBarCircleIcon: View {
    @Binding var showPopUp: Bool
    let icon: String
    let circleWidth, iconWidth, offset: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(showPopUp ?.yellow :.white)
                .frame(width: circleWidth, height: circleWidth)
                .shadow(radius: 4)
            
            Image(systemName: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: iconWidth, height: iconWidth)
                .foregroundColor(.black)
                .rotationEffect(Angle(degrees: showPopUp ? 90 : 0))
        }
        .offset(y: -(offset/2))
        .onTapGesture {
            withAnimation {
                showPopUp.toggle()
            }
        }
    }
}

struct PlusMenu: View {
    let widthAndHeight: CGFloat
    
    var body: some View {
        HStack(spacing: 40) {
            circleView(widthAndHeight: widthAndHeight,iconName:"record.circle")
            circleView(widthAndHeight: widthAndHeight,iconName:"folder")
        }
        .padding(.all,8)
        .background(Color.black.opacity(0.33))
        .cornerRadius(25.0)
        .transition(.scale)
    }
}

struct circleView: View {
    let widthAndHeight: CGFloat
    let iconName: String
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.black)
                .frame(width: widthAndHeight, height: widthAndHeight)
            
            Image(systemName: iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(15)
                .frame(width: widthAndHeight, height: widthAndHeight)
                .foregroundColor(.white)
        }
    }
}


// MARK: - *** FUNCTIONS ***


// MARK: - *** PREVIEW ***
struct TabBar_PopupMenu_Previews: PreviewProvider {
    static var previews: some View {
        TabBar_PopupMenu()
    }
}

