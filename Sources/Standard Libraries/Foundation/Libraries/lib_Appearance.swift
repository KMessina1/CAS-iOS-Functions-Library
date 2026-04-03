/*--------------------------------------------------------------------------------------------------------------------------
    File: lib_Appearance.swift
  Author: Kevin Messina
 Created: 07/14/23
Modified: 07/14/2023
 
©2023-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
 
2023_07_14  Changed Table setBackgroundColor to accept param as Color and convert to UIColor in function.
 
--------------------------------------------------------------------------------------------------------------------------*/

import Foundation
import UIKit
import SwiftUI

// MARK: - *** APPEARANCE CONFIGURATIONS ***
struct AppearanceConfiguration {
    struct Alert {
        func setColors(tintColor:UIColor,backgroundColor:UIColor? = nil) {
            let appearance = UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self])
            appearance.tintColor = tintColor
            
            if (backgroundColor != nil) {
                appearance.backgroundColor = backgroundColor
            }
        }
    }
    
    struct DatePicker {
        func setTextColor(_ titleColor:UIColor) {
            UIDatePicker.appearance().tintColor = titleColor
        }
    }
    
    struct NavigationView {
        func setNavigationViewTitleColor(_ titleColor:UIColor) {
            let appearance = UINavigationBar.appearance()
            appearance.largeTitleTextAttributes = [.foregroundColor: titleColor]
            appearance.titleTextAttributes = [.foregroundColor: titleColor]
        }
        
        func setNavigationViewBackgroundColor(_ backgroundColor:UIColor) {
            let appearance = UINavigationBar.appearance()
            appearance.backgroundColor = backgroundColor
            appearance.isOpaque = false
        }
    }
    
    struct ScrollView {
        func setHandleColor(_ indicatorStyle:UIScrollView.IndicatorStyle) {
            UIScrollView.appearance().indicatorStyle = indicatorStyle
        }
        
        func setBackgroundColor(_ backgroundColor:Color) {
            let appearance = UIScrollView.appearance()
            appearance.backgroundColor = UIColor(backgroundColor)
            appearance.isOpaque = false
        }
    }
    
    struct SegmentedControl {
        func setWidthByContent(on:Bool) {
            let appearance = UISegmentedControl.appearance()
            appearance.apportionsSegmentWidthsByContent = true
        }
        
        func setColors(background:UIColor,selectedBackground:UIColor,text:UIColor,selectedText:UIColor) {
            let appearance = UISegmentedControl.appearance()
            appearance.selectedSegmentTintColor = selectedBackground
            appearance.backgroundColor = background
            appearance.setTitleTextAttributes([.font : UIFont.preferredFont(forTextStyle: deviceIs.Pad ? .headline : .body)], for: .normal)
            appearance.setTitleTextAttributes([.foregroundColor : selectedText], for: .selected)
            appearance.setTitleTextAttributes([.foregroundColor : text], for: .normal)
        }
    }
    
    struct Stepper {
        func setPlusMinusSigns() {
            UIStepper.appearance().setDecrementImage(UIImage(systemName: "minus"), for: .normal)
            UIStepper.appearance().setIncrementImage(UIImage(systemName: "plus"), for: .normal)
        }
    }
    
    struct TabBar {
        func setColors(unSelected:Color,badge:Color = .red) {
            UITabBar.appearance().unselectedItemTintColor = UIColor(unSelected)
            UITabBarItem.appearance().badgeColor = UIColor(badge)
        }
    }
    
    struct Table {
        func setCellSelectionStyle(_ style:UITableViewCell.SelectionStyle) {
            let cellAppearance = UITableViewCell.appearance()
            cellAppearance.selectionStyle = style
        }
        
        func setCellBackgroundColor(_ color:Color) {
            let cellAppearance = UITableViewCell.appearance()
            cellAppearance.backgroundColor = UIColor(color)
        }
        
        func setSeparatorStyle(_ style:UITableViewCell.SeparatorStyle,color:Color) {
            let appearance = UITableView.appearance()
            appearance.separatorStyle = style
            appearance.separatorColor = UIColor(color)
            appearance.separatorInset = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        }
        
        func setAccessoryType(_ type:UITableViewCell.AccessoryType) {
            let cellAppearance = UITableViewCell.appearance()
            cellAppearance.accessoryType = type
        }
        
        func setBackgroundColor(_ backgroundColor:UIColor) {
            let appearance = UITableView.appearance()
            appearance.backgroundColor = backgroundColor
            appearance.isOpaque = false
            
            let cellAppearance = UITableViewCell.appearance()
            cellAppearance.backgroundColor = backgroundColor
        }
        
        func setHeaderViewToNil() {
            let appearance = UITableView.appearance()
            appearance.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            appearance.sectionFooterHeight = .zero
        }
        
        func setFooterViewToNil() {
            let appearance = UITableView.appearance()
            appearance.tableFooterView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            appearance.sectionFooterHeight = .zero
        }
    }
    
    struct textField {
        func setClearButton_Off() {
            let appearance = UITextField.appearance()
            appearance.clearButtonMode = .never
        }
        func setClearButton_ON() {
            let appearance = UITextField.appearance()
            appearance.clearButtonMode = .always
        }
    }
    
    struct toggle {
        func setTintColor(_ tintColor: Color) {
            let appearance = UISwitch.appearance()
            appearance.tintColor = UIColor(tintColor)
        }
        
        func setOnColor(_ onColor: Color) {
            let appearance = UISwitch.appearance()
            appearance.onTintColor = UIColor(onColor)
        }
    }
}


