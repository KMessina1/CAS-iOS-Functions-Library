/*--------------------------------------------------------------------------------------------------------------------------
    File: List_Multiselect.swift
  Author: Kevin Messina
 Created: 6/27/24
Modified:
 
©2024 Creative App Solutions, LLC. - All Rights Reserved.
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
///            Image(systemName: "\($multi_selectedItems.count).circle")
///               .foregroundStyle(currentTheme.info.accentColor)
///               .font(.title2)
///        }
///    }
///    )//End NavLink
///    .tint(colorsForMode.darkest)
///
///    Text(multi_selectedItems.joined(separator: "\n"))
///        .foregroundStyle(currentTheme.info.textColor_Fair.opacity(0.5))
///        .padding(.leading,20)
///
///     -or-
///
///     let temp:String = multi_selectedItems.joined(separator: ",")
///     let tempItems = temp.components(separatedBy: ",")
///
///     ForEach(0..<tempItems.count, id: \.self) { indx in
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
    @Environment(CurrentTheme.self) var currentTheme
    
    @State var title: String
    @State var allItems: [String]
    @Binding var selectedItems: [String]
    
    var body: some View {
        let colorsForMode = currentTheme.colorsForMode()
        
        ZStack {
            Rectangle()
                .foregroundStyle(Color.Lead.gradient)
                .ignoresSafeArea()

            VStack(alignment: .leading) {
                Text(selectedItems.count > 0 ?"\( title ) (\( selectedItems.count ))" :"\( title )")
                    .font(.largeTitle)
                    .padding(.bottom,10)
                    .foregroundStyle(currentTheme.Colors.accent)

                ScrollView {
                    ForEach(allItems, id: \.self) { item in
                        Button(action: {
                            withAnimation {
                                if self.selectedItems.contains(item) {
                                    self.selectedItems.removeAll(where: { $0 == item })
                                } else {
                                    self.selectedItems.append(item)
                                }
                            }
                        }) {
                            HStack {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(currentTheme.Colors.accent)
                                    .opacity(self.selectedItems.contains(item) ? 1.0 : 0.0)
                                
                                Text(item)
                                    .multilineTextAlignment(.leading)
                                
                                Spacer()
                            }
                            .font(.body)
                            .bold()
                        }
                        .foregroundStyle(colorsForMode.darkest)
                        
                        Divider().frame(height: 1.5).overlay(currentTheme.Colors.fair.opacity(0.2))
                            .padding(.top,-5)
                    }//End ForEach
                }//End Scrollview
                Spacer()
            }//End VStack
            .preferredColorScheme(currentTheme.Colors.mode)
            .tint(colorsForMode.darkest)
            .padding(.vertical,20)
            .padding(.horizontal,20)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Clear All") {
                        withAnimation {
                            selectedItems = []
                        }
                    }
                    .foregroundStyle(colorsForMode.darkest)
                }
            }//End Toolbar
            .onAppear {
                UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(.white)]
                UITableView.appearance().backgroundColor = .clear
                UITableViewCell.appearance().backgroundColor = .clear
            }
        }//End ZStack
    }
}

