/*--------------------------------------------------------------------------------------------------------------------------
    File: WhatsNewView.swift
  Author: Kevin Messina
 Created: Mar 19, 2021
Modified: Jul 15, 2021
 
©2021-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:

2025_05_31 - Added limit to number of versions user can see in drop down list. ('limitVersionsTo')
2025_04_30 - Separated items into versions. App always shows current version, but prior versions can be displayed.
2021_07_15 - Added version to title for what's new.
--------------------------------------------------------------------------------------------------------------------------*/

import SwiftUI
import GRDB

public struct WhatsNewView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.dismiss) private var dismiss

    let CT = CurrentTheme().getThemeFromUserStds()

    @State var WhatsNewItems:[WhatsNewItem] = []
    @State var filteredItems:[WhatsNewItem] = []
    @State var versions:[String] = []
    @State var adjustAlignment: Bool = false
    @State var currentVersion: Double = 0.0
    @State var limitVersionsTo: Int = 3
    @State var selectedVersion: Int = 3

    let gridItem: GridItem = GridItem(.flexible(), spacing: 16, alignment: .leading)

    func noContentView(title: String, icon: String) -> some View {
        VStack {
            Spacer()
            ContentUnavailableView { Label(title, systemImage: icon) }
            Spacer()
        }
        .foregroundStyle(CT.fair)
    }
    
    func loadBasicData() -> Void {
        let table: String = WhatsNewItem.databaseTableName
        
        WhatsNewItems.removeAll()
        
        do {
            try dbQueue_WhatsNew.read { dbTable in
                WhatsNewItems = try WhatsNewItem.fetchAll(dbTable,
                    WhatsNewItem.order(Column("version"), Column("sortOrder"))
                )
                
                versions.removeAll()
                for item in WhatsNewItems {
                    if versions.count > limitVersionsTo {
                        break
                    }else{
                        if !versions.contains(String(item.version)) {
                            versions.append(String(item.version))
                        }
                    }
                }
                
                versions = versions.sorted().reversed()

                currentVersion = Double(versions[0]) ?? -1.0

                filterVersions()
                
                simPrintDB(type: .success, action:.fetchAll, found: WhatsNewItems.count, table: table)
            }
        } catch {
            simPrintDB(type: .error, action:.fetchAll, table: table, msg: "\(error.localizedDescription)")
            print("\(error)")
        }
    }
    
    func filterVersions() {
        filteredItems = WhatsNewItems.filter{ $0.version == currentVersion }
    }
    
    var toolbarView: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image.get(AppImages.Disclosure_Lt)
            }
            .padding(.all,13)
            .glassEffect(.clear)
            .clipShape(Circle())
            .foregroundStyle(.white)

            Spacer()
            
            VStack {
                Text("What's New".uppercased())
                    .fontWeight(.regular)

                Text("current v\(AppInfo.version)")
                    .fontWeight(.light)
            }
            .font(.headline)
            .fontWidth(.condensed)
            .foregroundStyle(.white)

            Spacer()
            
            Menu {
                ForEach(versions, id: \.self) { item in
                    Button("v\(item)\(Double(item) == currentVersion ?" (Current)" :"")") {
                        currentVersion = Double(item) ?? -1.0
                        filterVersions()
                    }
                }
            } label: {
                Image.get("books.vertical")
            }//End Menu
            .foregroundStyle(.white)
            .padding(.all,13)
            .glassEffect(.clear)
            .clipShape(Circle())
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            // This inset ensures content doesn't go under the status bar
            Color.clear.frame(height: 0)
        }
        .padding(.leading,10)
        .padding(.trailing,5)
    }

    var body: some View {
        let isCompact = (horizontalSizeClass == .compact)
        let iconSize: CGFloat = deviceIs.Pad ?90 :60
        let columns_1 =  [gridItem]
        let columns_2 =  [gridItem,gridItem]
        let columns_3 =  [gridItem,gridItem,gridItem]

        return ZStack {
            gradientBackgroundView()

            VStack(alignment: .leading) {
                if UserDefaults.standard.bool(forKey: KeyNames.App.showWhatsNew) {
                    toolbarView
                }
                
                ScrollView(showsIndicators: false) {
                    LazyVGrid(
                        columns: isCompact ?columns_1 :deviceIs().PadLandscape ?columns_3 :columns_2,
                        alignment: .center,
                        spacing: isCompact ?5 :deviceIs().PadLandscape ?25 :50,
                        pinnedViews: [.sectionHeaders, .sectionFooters]
                    ) {
                        if filteredItems.count < 1 {
                            noContentView(title: "No items found for this version.", icon: AppImages.txtFld_list)
                        }else{
                            ForEach(filteredItems, id: \.id) { WNItem in
                                HStack(alignment: .top) {
                                    Image.getResizable(WNItem.iconName)
                                        .foregroundStyle(CT.title)
                                        .frame(width: iconSize, height: iconSize, alignment: .topLeading)

                                    VStack(alignment: .leading, spacing: 0) {
                                        Text(WNItem.title)
                                            .font(.title2)
                                            .fontWeight(deviceIs.Pad ?.bold :.regular)
                                            .lineLimit(2)
                                            .minimumScaleFactor(0.75)
                                            .padding(.bottom,1)
                                            .foregroundStyle(CT.medium)

                                        Text(WNItem.detail)
                                            .font(deviceIs.Pad ?.headline :.callout)
                                            .italic()
                                            .multilineTextAlignment(.leading)
                                            .foregroundStyle(CT.fair)

                                        Spacer()
                                    }//End VStack
                                    .padding(.leading,20)

                                    Spacer()
                                }//End HStack
                                .frame(minWidth: 200, maxWidth: 500, minHeight: 75, maxHeight: 150, alignment: .leading)
                                .font(.title3)
                            }
                        }
                    }
                    .padding(.bottom,30)
                    .padding(.top,15)
                }
                .padding(.horizontal,10)

                Spacer()
            }
            .padding(.horizontal,10)
            .edgesIgnoringSafeArea(.bottom)
            .toolbar {
                TB().title("What's New")
                TB().subtitle("current v\(AppInfo.version)")
                
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        ForEach(versions, id: \.self) { item in
                            Button("v\(item)\(Double(item) == currentVersion ?" (Current)" :"")") {
                                currentVersion = Double(item) ?? -1.0
                                filterVersions()
                            }
                        }
                    } label: {
                        Label("", systemImage: "books.vertical")
                    }//End Menu
                }
            }
        }
        .task(priority: .high) {
            loadBasicData()
        }
    }
}

#Preview {
    WhatsNewView()
}
