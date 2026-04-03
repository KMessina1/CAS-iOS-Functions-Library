/*--------------------------------------------------------------------------------------------------------------------------
    File: TabBarHelper.swift
  Author: Kevin Messina
 Created: Sep 28, 2020
Modified:
 
©2020-2021 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
Notes:

2020_10_21 - Added custom TabBar view
--------------------------------------------------------------------------------------------------------------------------*/

import SwiftUI
import Observation

struct TabBarHelper {
    /// tabView
    /// ---
    /// - Parameters
    ///   - title:String = The title on the tab screen centered.
    ///   - imgName:String = system image name from SF Symbols
    ///   - tabText:String = OPTIONAL text under image. Defaults to title.
    ///   - _tag:Int = OPTIONAL tag. Defaults to 0.
    /// - requires: SwiftUI
    /// - returns: View with centered title text.
    struct tabView: View {
        var title:String = ""
        var imgName:String = ""
        var tabText:String = ""
        var tag:Int = 0
        
        var body: some View {
            Text(title)
                .font(.title)
                .tabItem {
                    Image(systemName: imgName)
                    Text(tabText.isEmpty ?title :tabText)
                }
                .tag(tag < 1 ?0 :tag)
        }
    }
    
    struct TabInfoStruct {
        var id: Int
        var title: String
        var imgName: String
    }
    
    struct TabBarButton : View {
        @Binding var selected: Int
        @Binding var centerX: CGFloat
        
        var title: String
        var img: String
        var rect: CGRect
        var titleColor: Color = .white
        var selectedColor: Color = .white
        var inactiveColor: Color = .gray
        var disabledColor: Color = .gray
        var tag: Int = 0
        
        var body: some View {
            let isSelected = (selected == tag)
            
            return Button(
                action: {
                    withAnimation(.spring()) {
                        selected = tag
                        centerX = rect.midX
                    }
                },
                label: {
                    VStack {
                        Image(systemName: img)
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 26, height: 26)
                            .foregroundColor(isSelected ?selectedColor :inactiveColor)
                            .padding(.bottom,-4)

                        Text(title)
                            .font(.caption)
                            .bold()
                            .minimumScaleFactor(0.9)
                            .foregroundColor(selected == tag
                                ? titleColor
                                : inactiveColor
                            )
                            .padding(3)
                            .padding(.horizontal,2)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundColor(isSelected ?selectedColor :.clear )
                            )
                    }
                    .padding(.top)
                    .frame(width:70,height:50)
                    .offset(y: isSelected ? -15 :0)
                    .padding(.top,1)
                }
            )
        }
    }

    struct TabBarLayout: View {
        @Binding var selectedTab:Int
        
        var backColor:Color = .accentColor
        var titleColor:Color = .white
        var selectedColor:Color = .white
        var inactiveColor:Color = .gray
        var tabNames:[TabBarHelper.TabInfoStruct]

        @State var centerX: CGFloat = 0

        var body: some View {
            HStack(spacing: 0) {
                ForEach(0..<tabNames.count, id: \.self) { tabNum in
                    GeometryReader { GR in
                        TabBarHelper.TabBarButton(
                            selected: $selectedTab,
                            centerX: $centerX,
                            title: tabNames[tabNum].title,
                            img: tabNames[tabNum].imgName,
                            rect: GR.frame(in: .global),
                            titleColor: titleColor,
                            selectedColor: selectedColor,
                            inactiveColor: inactiveColor,
                            tag: tabNames[tabNum].id
                        )
                        .onAppear(perform: {
                            if tabNum == 0 {
                                centerX = GR.frame(in: .global).midX
                            }
                        })
                    }
                    .frame(width: 70, height: 60)

                    if tabNum != (tabNames.count - 1) {
                        Spacer(minLength: 0)
                    }
                }
            }
            .padding(.horizontal,25)
            .padding(.top)
            .ignoresSafeArea()
            .padding(.bottom,20)
            .background(backColor.clipShape(TabBarHelper.AnimatedShape(centerX: centerX)))
            .padding(.top,-30)
            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 0)
        }
    }
    
    struct AnimatedShape: Shape {
        var centerX: CGFloat
        var animatableData: CGFloat {
            get { return centerX }
            set { centerX = newValue }
        }
        
        func path(in rect: CGRect) -> Path {
            return Path { path in
                path.move(to: CGPoint(x: 0, y: 15))
                path.addLine(to: CGPoint(x: 0, y: rect.height))
                path.addLine(to: CGPoint(x: rect.width, y: rect.height))
                path.addLine(to: CGPoint(x: rect.width, y: 15))
                
                path.move(to: CGPoint(x: centerX - 35, y: 15))
                path.addQuadCurve(to: CGPoint(x: centerX + 35, y: 15), control: CGPoint(x: centerX, y: -25))
            }
        }
    }
}
