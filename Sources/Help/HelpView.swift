/*--------------------------------------------------------------------------------------------------------------------------
    File: HelpView.swift
  Author: Kevin Messina
 Created: 6/10/24
Modified:
 
©2024 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import SwiftUI

struct HelpView: View {
    @Environment(\.dismiss) private var dismiss
    //Theme
    @Environment(CurrentTheme.self) var currentTheme: CurrentTheme
    
    var hideDoneButton: Bool
    
    // Records
    @State var helpItems:[HelpItem] = []
    @State var headerItems:[HelpItem] = []
    @State var bodyItems:[HelpItem] = []
    @State var footerItems:[HelpItem] = []

    @State private var textSize: CGFloat = 18.0
    
    var body: some View {
        let colorsForMode = currentTheme.colorsForMode()
        
        ZStack {
            currentTheme.info.backgroundColors.first
                .ignoresSafeArea()
            
            //titleView
            VStack {
                titleView
                
                .padding()
                
                Divider().frame(height:1.5).overlay(colorsForMode.light)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing:textSize) {
                        headerView
                        
                        bodyView
                        
                        footerView
                    }//End VStack
                    .padding(.horizontal,10)
                }//End ScrollView

                Divider().frame(height:1.5).overlay(colorsForMode.light)
                
                sliderView
            }//End ZStack
            .padding(.horizontal,10)
            .zIndex(1)
        }//End Body
        .onAppear(perform: {
            textSize = UserDefaults.standard.double(forKey: KeyNames.App.Settings.helpTextSize)
            
            loadBasicData()
        })
    }
    
    func loadBasicData() -> Void {
        do {
            try dbQueue.read { db in
                helpItems = try HelpItem.fetchAll(db)
                
                //filter sections
                headerItems = helpItems.filter({ $0.section == "Header"  })
                bodyItems = helpItems.filter({ $0.section == "Body"  })
                footerItems = helpItems.filter({ $0.section == "Footer"  })
            }
        } catch {
            print("\(error)")
        }
    }
}

#Preview {
    let currentTheme = CurrentTheme()
    currentTheme.info = Theme.Names.arr[Theme.Names.basic.id]
    //    currentTheme.info = Theme.Names.arr[Theme.Names.dark.id]
    //    currentTheme.info = Theme.Names.arr[Theme.Names.light.id]
    //    currentTheme.info = Theme.Names.arr[Theme.Names.midnight.id]
    //    currentTheme.info = Theme.Names.arr[Theme.Names.military.id]

    return HelpView(hideDoneButton: true)
        .environment(currentTheme)
}

// MARK: - *** Extension ***
extension HelpView {
    var sliderView: some View {
        HStack{
            Label("size: \( Int(textSize) )", systemImage: "textformat.size")
                .padding(.trailing,40)

            Spacer()

            Slider(value: $textSize, in: 10...36, step: 1) {
                
            } minimumValueLabel: {
                Image(systemName: "textformat.size.smaller")
            } maximumValueLabel: {
                Image(systemName: "textformat.size.larger")
            }
        }
        .padding(.horizontal,20)
        .onChange(of: textSize) {
            UserDefaults.standard.set(textSize, forKey: KeyNames.App.Settings.helpTextSize)
            UserDefaults.standard.synchronize()
        }
    }
    
    var titleView: some View {
        let colorsForMode = currentTheme.colorsForMode()
        
        return HStack(alignment: .center) {
            VStack(alignment: hideDoneButton ?.center :.leading, spacing:0){
                Text("App Help")
                    .font(.largeTitle)
                    .fontWeight(.light)
                    .minimumScaleFactor(0.75)
                    .foregroundStyle(currentTheme.info.titleColor)
                
                Text("Version \( AppInfo.version ) (\( AppInfo.build ))")
                    .font(.title3)
                    .fontWeight(.light)
                    .minimumScaleFactor(0.75)
                    .foregroundStyle(colorsForMode.medium)
            }//End VStack
            
            if !hideDoneButton {
                Spacer()
                
                Button(action: {
                    withAnimation { dismiss() }
                }, label: {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(CGSize(width: 35, height: 35))
                        .foregroundStyle(colorsForMode.dark)
                })
            }//End If
        }//End HStack
        .padding(.horizontal,10)
        .font(.body)
    }
    
    var headerView: some View {
        VStack {
            ForEach(headerItems, id: \.id) { item in
                VStack {
                    Text(item.subTitle).font(.system(size: textSize, weight: .regular))
                    Text(item.detail).font(.system(size: textSize + 10, weight: .semibold))
                    Text(item.notes).font(.system(size: textSize - 2, weight: .light)).italic()
                }
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            }
        }//End VStack
        .font(.system(size: textSize))
    }
    
    var regularDivider: some View {
        HStack {
            Rectangle().fill(currentTheme.info.accentColor)
                .frame(height: 1.5)
        }
        .frame(height: 25)
        .padding(.vertical,10)
        .padding(.horizontal,50)
    }
    
    var fancyDivider: some View {
        HStack {
            Rectangle().fill(currentTheme.info.accentColor)
                .frame(height: 1.5)
            
            Image(systemName: "fleuron")
                .resizable()
                .imageScale(.small)
                .scaledToFit()
            
            Rectangle().fill(currentTheme.info.accentColor)
                .frame(height: 1.5)
        }
        .frame(height: 25)
        .padding(.vertical,10)
    }

    var bodyView: some View {
        VStack(alignment: .leading, spacing:0) {
            ForEach(bodyItems, id: \.id) { section in
                Section(header:
                    HStack {
                        Text(section.title).font(.system(size: textSize + 10, weight: .medium))
                        Spacer()
                    }
                ) {
                    let sectionItems = bodyItems.filter({ $0.title == section.title  })
                    
                    ForEach(sectionItems, id: \.id) { item in
                        VStack(alignment: .leading) {
                            Text(item.subTitle).font(.system(size: textSize + 7, weight: .regular))
                            Text(item.detail).font(.system(size: textSize, weight: .thin))
                            if !item.notes.isEmpty {
                                Text("Notes: ").font(.system(size: textSize - 2, weight: .bold))
                                    .padding(.top,8)
                                Text(item.notes).font(.system(size: textSize - 2, weight: .thin)).italic()
                            }
                            
                            if sectionItems.last!.subTitle == item.subTitle {
                                fancyDivider
                            }else{
                                regularDivider
                            }
                        }//End VStack
                    }//End ForEach
                }//End Section
            }//End ForEach
        }//End VStack
    }
    
    var footerView: some View {
        VStack {
            ForEach(footerItems, id: \.id) { item in
                VStack(alignment: .leading, spacing:textSize) {
                    Text(item.subTitle)
                    Text(item.detail)
                    //MARK: - 📝TODO: ⚠️(Warning) Change to actual webssite for production.
                    Text("Visit our website: [click here](https://ballistictracker.godaddysites.com)")
                        .tint(currentTheme.isLight ?.indigo :.cyan)
                }
            }
        }//End VStack
        .font(.system(size: textSize, weight: .regular))
        .padding(.vertical,20)
    }
}

