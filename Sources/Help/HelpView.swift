/*--------------------------------------------------------------------------------------------------------------------------
    File: HelpView.swift
  Author: Kevin Messina
 Created: 6/10/24
Modified:
 
©2024-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import SwiftUI

struct HelpView: View {
    @Environment(\.dismiss) private var dismiss
    let CT = CurrentTheme().getThemeFromUserStds()
    
    // Records
    @State var helpItems:[HelpItem] = []
    @State var headerItems:[HelpItem] = []
    @State var bodyItems:[HelpItem] = []
    @State var footerItems:[HelpItem] = []
    @State var sections:[String] = []

    @State private var scrollTarget: String = ""
    @State private var textSize: CGFloat = 18.0
    @State private var isShowingPopover = false

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    CT.Colors.backgroundArr[0],
                    CT.Colors.backgroundArr[0],
                    .black
                ]),
                startPoint: .top,endPoint: .bottom
            )
            .ignoresSafeArea()
            
            //titleView
            VStack {
                ScrollViewReader { SR in
                    ScrollView(showsIndicators: false) {
                        VStack(spacing:textSize) {
                            headerView

                            bodyView

                            footerView
                                .padding(.top,-30)
                        }//End VStack
                        .padding(.horizontal,10)
                    }//End ScrollView
                    .onChange(of: scrollTarget) {
                        withAnimation {
                            SR.scrollTo(scrollTarget,anchor: .top)
                        }
                    }
                }//End Scrollview Reader
            }//End ZStack
            .padding(.horizontal,10)
            .zIndex(1)
        }//End Body
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("App Help".uppercased())
                    .foregroundStyle(CT.lightest)
            }
            
            ToolbarItem(placement: .subtitle) {
                Text("v\(AppInfo.version)")
                    .fontWeight(.light)
                    .italic()
                    .foregroundStyle(CT.lightest)
            }

            ToolbarItemGroup(placement: .topBarTrailing) {
                Button(action: {
                    isShowingPopover = true
                }) {
                    Image(systemName: "textformat.size")
                        .foregroundStyle(CT.accent)
                }
                .popover(isPresented: $isShowingPopover) {
                    sharedPopovers.textSize(textSize: $textSize)
                        .presentationCompactAdaptation(.popover) // Optional: Force popover on compact sizes
                }
                .onChange(of: textSize) {
                    UserDefaults.standard.set(textSize, forKey: KeyNames.App.Settings.helpTextSize)
                    UserDefaults.standard.synchronize()
                }

                Menu {
                    Text("Jump To Subject")
                    
                    Button {
                        scrollTarget = "Header"
                    } label: {
                        Label("Top", systemImage: AppImages.arrow_Up)
                    }
                    
                    ForEach(sections, id: \.self) { section in
                        Button {
                            scrollTarget = "\( section )"
                        } label: {
                            Label("\( section )", systemImage: "arrow.turn.down.right")
                        }
                    }
                    
                    Button {
                        scrollTarget = "Footer"
                    } label: {
                        Label("Bottom", systemImage: AppImages.arrow_Down)
                    }
                } label: {
                    Label("", systemImage: AppImages.menu)
                }//End Menu
            }
        }
        .onAppear {
            textSize = UserDefaults.standard.double(forKey: KeyNames.App.Settings.helpTextSize)
            
            loadBasicData()
        }
    }
    
    func loadBasicData() -> Void {
        helpItems.removeAll()
        headerItems.removeAll()
        bodyItems.removeAll()
        footerItems.removeAll()
        sections.removeAll()

        do {
            try dbQueue_Help.read { dbTable in
                helpItems = try HelpItem.fetchAll(dbTable)
                
                //filter sections
                headerItems = helpItems.filter({ $0.section == "Header" })
                bodyItems = helpItems.filter({ $0.section == "Body" }).sorted(by: { $0.title < $1.title })
                footerItems = helpItems.filter({ $0.section == "Footer" })
                
                //filter section titles
                for item in bodyItems {
                   if !sections.contains(item.title) {
                       sections.append(item.title)
                   }
                }
            }
        } catch {
            print("\(error)")
        }
    }
}

#Preview {
    HelpView()
}

// MARK: - *** Extension ***
extension HelpView {
    var headerView: some View {
        VStack {
            ForEach(headerItems, id: \.id) { item in
                VStack {
                    Text(item.subTitle).font(.system(size: textSize, weight: .regular))
                        .id("Header")
                        .foregroundStyle(CT.title)
                    Text(item.detail).font(.system(size: textSize + 10, weight: .semibold))
                        .foregroundStyle(CT.fair)
                    Text(item.notes).font(.system(size: textSize - 3, weight: .light)).italic()
                        .foregroundStyle(CT.medium)
                }
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            }
        }//End VStack
        .font(.system(size: textSize))
    }
    
    var regularDivider: some View {
        HStack {
            Rectangle().fill(CT.accent)
                .frame(height: 1.5)
        }
        .frame(height: 25)
        .padding(.vertical,10)
        .padding(.horizontal,50)
    }
    
    var fancyDivider: some View {
        HStack {
            Rectangle().fill(CT.accent)
                .frame(height: 1.5)
            
            Image(systemName: "fleuron")
                .resizable()
                .imageScale(.small)
                .scaledToFit()
                .foregroundStyle(CT.fair)
            
            Rectangle().fill(CT.accent)
                .frame(height: 1.5)
        }
        .frame(height: 25)
        .padding(.vertical,10)
    }

    var bodyView: some View {
        VStack(alignment: .leading, spacing:0) {
            ForEach(sections, id: \.self) { sectionTitle in
                Section(header:
                    HStack {
                        Text(sectionTitle)
                        .font(.system(size: textSize + 10, weight: .medium))
                        .foregroundStyle(CT.title)
                        .id(sectionTitle)
                        Spacer()
                    }
                ) {
                    let sectionItems = bodyItems.filter({ $0.title == sectionTitle  })

                    ForEach(sectionItems, id: \.id) { item in
                        VStack(alignment: .leading) {
                            Text(item.subTitle).font(.system(size: textSize + 7, weight: .regular))
                                .foregroundStyle(CT.light)
                            Text(item.detail).font(.system(size: textSize, weight: .regular))
                                .foregroundStyle(CT.lightest)
                            if !item.notes.isEmpty {
                                Text("Notes: ").font(.system(size: textSize - 3, weight: .medium))
                                    .foregroundStyle(CT.title)
                                    .padding(.top,8)
                                Text(item.notes).font(.system(size: textSize - 3, weight: .regular)).italic()
                                    .foregroundStyle(CT.fair)
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
        .foregroundStyle(CT.lightest)
        .padding(.vertical,20)
    }
    
    var footerView: some View {
        VStack {
            ForEach(footerItems, id: \.id) { item in
                VStack(alignment: .leading, spacing:textSize) {
                    Text(item.subTitle)
                        .id("Footer")
                    Text(item.detail)
                    //MARK: - 📝TODO: ⚠️(Warning) Change to actual webssite for production.
                    Text("Visit our website: [click here](https://ballistictracker.godaddysites.com)")
                        .tint(CT.isLight ?.indigo :.cyan)
                }
            }
        }//End VStack
        .font(.system(size: textSize, weight: .regular))
        .foregroundStyle(CT.lightest)
        .padding(.vertical,20)
    }
}

