/*--------------------------------------------------------------------------------------------------------------------------
    File: List_Multiselect.swift
  Author: Kevin Messina
 Created: 6/27/24
Modified:
 
©2024-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import SwiftUI

/// Usage:
///
///    NavigationLink(
///        destination: {
///            MultiSelectPickerView(
///                title: "Inventory Items",
///                allItems: multi_allItems,
///                selectedItems: $multi_selectedItems
///            )
///            .navigationTitle("Choose Your Related Items")
///    }, label: {
///        HStack {
///            Text("Select Related Inventory Items:")
///            Spacer()
///            Image(systemName: "\(multi_selectedItems.count).circle")
///               .foregroundStyle(CT.info.accentColor)
///               .font(.title2)
///        }
///    }
///    )//End NavLink
///    .tint(CT.lightest)
///
///    Text(multi_selectedItems.joined(separator: "\n"))
///        .foregroundStyle(CT.info.textColor_Fair.opacity(0.5))
///        .padding(.leading,20)
///
///     -or-
///
///     let temp:String = multi_selectedItems.joined(separator: ",")
///     let tempItems = temp.components(separatedBy: ",")
///
///     ForEach(0...tempItems.count - 1, id: \.self) { indx in
///     ...
///     }
///
/// Params:
///
///     title = Title shown atop screen for what picker items are a list of.
///     allItems = The entire list of Strings of each item.
///     selectedItems = An array of \n seperated Strings
///     
struct MultiSelectPickerView: View {
    let CT = CurrentTheme().getThemeFromUserStds()
    
    @State var isSearching: Bool = false

    enum ClrBtnPos { case pos_bottomCenter,pos_topTrailing }
    enum StatusVals { case deselected,nothingChanged,changes }

    @State var title: String
    @State var allItems: [String]
    @Binding var selectedItems: [String]
    @Binding var selectedStatus: StatusVals
    @State var showClearButton: Bool = true
    @State var ClearButtonPosition: ClrBtnPos = .pos_bottomCenter
    @State var isInsetView: Bool = false
    @State var containsIDs: Bool = false

    @State private var searchText: String = ""
    @State private var originalSelectedItems: [String] = []
    var searchResults: [String] {
        searchText.isEmpty
        ? allItems
        : allItems.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }

    func linetItemView(item: String) -> some View {
        let isSelected = self.selectedItems.contains(item)

        return HStack(spacing: 5) {
            Image(systemName: "checkmark")
                .foregroundStyle(CT.accent)
                .opacity(isSelected ? 1.0 : 0.0)
                .padding(.leading,5)
            
            if containsIDs {
                let val = item.beforeChar(":")
                let txt = item.afterChar(":").trim(.ends)
                DL().recordID(title: txt, id: Int64(val).orInvalidDbId, padLeading: false)
                    .padding(.vertical,10)
                    .padding(.trailing,-7)
            }else{
                Text(item)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(CT.lightest)
            }
            
            Spacer()
        }
        .font(.body)
        .bold()
        .padding(.vertical,isSelected ?10 :5)
        .background(
            CT.accent
                .opacity(isSelected ?0.3 :0.0)
                .cornerRadius(isSelected ?10 :0)
        )
    }
    
    var body: some View {
        let searchingFor = searchText.isEmpty
            ?"Showing all items (\(allItems.count) of \(allItems.count))"
            :"Showing items Filtered by '\(searchText)' (\(searchResults.count) of \(allItems.count))"

        ZStack(alignment: .top) {
            if !isInsetView {
                gradientBackgroundView()
            }

            VStack(alignment: .leading) {
                Text(selectedItems.count > 0 ?"\( title ) (\( selectedItems.count ))" :"\( title )")
                    .font(isInsetView ?.title2 :.largeTitle)
                    .bold()
                    .foregroundStyle(CT.accent)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                
                Text(searchingFor)
                    .font(isInsetView ?.callout :.title2)
                    .italic()
                    .padding(.bottom, 10)
                    .foregroundStyle(CT.fair)

                if searchResults.count > 0 {
                    ScrollViewReader { scrollViewer in
                        ScrollView {
                            ForEach(searchResults, id: \.self) { item in
                                let isSelected = self.selectedItems.contains(item)
                                
                                Button(action: {
                                    withAnimation {
                                        if isSelected {
                                            self.selectedItems.removeAll(where: { $0 == item })
                                        } else {
                                            self.selectedItems.append(item)
                                        }
                                    }
                                }) {
                                    linetItemView(item: item)
                                }
                                .foregroundStyle(CT.lightest)
                                
                                Divider().frame(height: 1.5).overlay(CT.fair.opacity(0.2))
                            }//End ForEach
                        }//End Scrollview
                        .frame(height: .infinity)
                        .padding(.bottom, isInsetView ? -20 : 0)
                        .scrollContentBackground(.hidden)
                        .onChange(of: isSearching) {
                            if selectedItems.count > 0 {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    scrollViewer.scrollTo(selectedItems[0], anchor: .center)
                                }
                            }
                        }
                        .onAppear {
                            if selectedItems.count > 0 {
                                scrollViewer.scrollTo(selectedItems[0], anchor: .center)
                            }
                        }
                    }//End ScrollView Reader
                }else{
                    VStack{
                        Spacer()
                        ContentUnavailableView("No Items Found.", systemImage: AppImages.txtFld_list)
                            .scaleEffect(deviceIs.Pad ?1.25 :1)
                            .frame(height: deviceIs.Pad ?210 :175)
                        Spacer()
                    }
                    .foregroundStyle(CT.lightest)
                }
                
                Spacer()
            }//End VStack
            .searchable(text: $searchText, prompt: "Search For...")
            .textInputAutocapitalization(.never)
            .tint(CT.lightest)
            .preferredColorScheme(CT.colorsForMode().mode)
            .padding(.vertical, isInsetView
                     ?0
                     :containsIDs ?0 :20)
            .padding(.horizontal, isInsetView
                     ?10
                     :containsIDs ?5 :20)
            .onChange(of: selectedItems){
                if selectedItems.count < 1 {
                    selectedStatus = .deselected
                }else if selectedItems == originalSelectedItems {
                    selectedStatus = .nothingChanged
                }else if selectedItems != originalSelectedItems {
                    selectedStatus = .changes
                }
            }
            .toolbar {
                if showClearButton && searchResults.count > 0 {
                    ToolbarItem(placement: ClearButtonPosition == .pos_bottomCenter ?.bottomBar :.topBarTrailing) {
                        Button {
                            withAnimation {
                                selectedItems = []
                            }
                        } label: {
                            if ClearButtonPosition == .pos_bottomCenter {
                                HStack {
                                    Image.get(AppImages.clearAll).scaledToFit()
                                    Text("Unselect all items")
                                }
                            }else{
                                Image.get(AppImages.clearAll).scaledToFit().frame(width:20,height:20)
                            }
                        }
                        .modifier(button_Std(buttonType: .destructive,padding: 0))
                    }
                }//End If
            }//End Toolbar
            .foregroundStyle(CT.lightest)
            .onAppear {
                UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(CT.lightest)]
                UITableView.appearance().backgroundColor = .clear
                UITableViewCell.appearance().backgroundColor = .clear
                
                selectedStatus = .nothingChanged
                originalSelectedItems = selectedItems
            }
        }//End ZStack
    }
}

