/*--------------------------------------------------------------------------------------------------------------------------
    File: CAS_Alert.swift
  Author: Kevin Messina
 Created: Dec 29, 2019
Modified: May 28, 2022

©2019-2022 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:

05/28/2022 - Stripped out constants, functions and data models to separate files for clarity and easier maintenace as this
             custom control expands into a fully-functional Swift package.
04/01/2022 - Added ability to handle action buttons from new datamodel and display function.
03/31/2022 - Added a new display method to use the new datamodel.
03/30/2022 - Added a new datamodel to make automating messages easier for common db tasks.
03/07/2022 - Refined button press documentation and usage instructions.
07/28/2021 - Added logic to not pad spacing vertically if notation or message is empty.
             Added second button option with callback binding.
01/25/2021 - Added flexibility of forced value to constrian width.
             Added iPad specifoc functionality.
             Fixed vertical centering issue on iPad.
             Added new .custom alert style setting.
             Moved Color assets to CAS_Alert assets.
--------------------------------------------------------------------------------------------------------------------------*/

import Foundation
import Swift
import SwiftUI

/* USAGE DIRECTIONS:

------------------
PREDEFINED ALERTS:
------------------
 
    @State var showConfirmAlert:Bool = false

    CAS_Alert.show(
        predefinedType: .confirmDelete,
        showAlert: $showConfirmAlert,
        actionTitle: "Delete",
        cancelTitle: "Cancel",
        replacementTxt: "\(selectedEmployee.firstName) \(selectedEmployee.lastName)"
    )
    .onDisappear { alertData.resetData() }

-----------------
DATAMODEL ALERTS:
-----------------
 
// Ok to use @StateObject to reset on each page view of alert data.
@StateObject var alertData: CAS_AlertDataModel = CAS_AlertDataModel.init()
 
if alertData.show {
    CAS_Alert.displayFromDataModel(alertData: alertData, showAlert: $alertData.show)
        .onDisappear { alertData.resetData() }
}

// in the body of functionality like a button press, var changing or gesture...
alertData.operation = .delete
alertData.tagName = .delete
alertData.type = .confirmDelete
alertData.replacementText = name
alertData.actionButtonTitle = "Delete"
alertData.cancelButtonTitle = "Cancel"
alertData.show = true
 
-----------------------------
Reading which button pressed:
-----------------------------
 
The callback is by observing the alertData.buttonPressed param for change. It's Cancel_OK by default. Note that there is
a secondary alert fired with the results of the destructive action by setting the activeAlert and alertMsg. Otherwise just
display a regular CAS_Alert or Alert or even nothing at all if not needed. In the example below, this is a Confirm Delete
and the results are cancel and delete actions and for the next step to report back whether the delete was succesful or not.

 .onChange(of: alertData.buttonPressed) { oldValue, newValue in
    if let buttonPressed = CAS_Alert.buttonPressed(rawValue: newValue.rawValue ) {
    switch buttonPressed {
        case .action:
            let name = "\(selectedEmployee.firstName) \(selectedEmployee.lastName)"
            modelContext.delete(selectedEmployee)
            do {
                try modelContext.save()
                alertMsg = "Employee \(name) successfully deleted."
                simPrint(type: .info, msg: alertMsg)
                activeAlert = .deleted
            }catch{
                alertMsg = error.localizedDescription
                simPrint(type: .error, msg: alertMsg)
                activeAlert = .errorOccured
            }

            showAlert.toggle()
        case .cancel_OK: break
     }
 }

*/


/// buttonPressed is a bool returned representing the action button was pressed otherwise the cancel button pressed.
/// When bound, is an enum that represents a bool for true/false whether to take the action. It is presumed that cancel_OK
/// was NOT pressed. This opens up the possibility for other enums representing other buttons can also be added down the
/// road.
///
/// In the calling view, add an .onChange of the passed binding to get the change and then do a test to see if action was
/// pressed. Although not necessary with only 2 buttons as they act more like a Bool, it will be when adding future buttons.
public class CAS_Alert {
    struct displayFromDataModel : View {
        @ObservedObject var alertData:CAS_AlertDataModel
        @Binding var showAlert:Bool

        var body: some View {
            CAS_Alert.show(
                predefinedType: CAS_AlertDataModel.returnValueForPredefinedType().styleTypeForOperation(alertData.operation),
                showAlert:      $showAlert,
                actionTitle:    alertData.actionButtonTitle,
                cancelTitle:    alertData.cancelButtonTitle,
                title:          alertData.title,
                msg:            alertData.msg,
                notation:       alertData.notation,
                buttonPressed:  $alertData.buttonPressed,
                replacementTxt: alertData.replacementText
            )
        }
    }
    
    struct show: View {
        var predefinedType:styleTypePredefined
        @Binding var showAlert:Bool
        var actionTitle:String = ""
        var cancelTitle:String = ""
        var width:CGFloat = UIDevice.Family.isPad ?400 :UIScreen.width - 50
        var title:String = ""
        var msg:String = ""
        var color:Color = Color.Midnight
        var notation:String = ""
        var align_Notation:TextAlignment = .leading
        var buttonPressed:Binding<CAS_Alert.buttonPressed>?
        var replacementTxt:String = ""

        var body: some View {
            let type = String(reflecting: predefinedType).components(separatedBy: ".").last ?? ""

            CAS_Alert.view(
                showAlert: $showAlert,
                title: CAS_AlertDataModel.returnValueForPredefinedType().title(predefinedType,title:title),
                style: CAS_AlertDataModel.returnValueForPredefinedType().styleType(predefinedType),
                message: msg.isEmpty ? CASAlertData.Predefined_Messages().getMessageNamed(type,replacementText: replacementTxt) :msg,
                notation: notation.isEmpty ? CASAlertData.Predefined_Messages().getNotationNamed(type,replacementText: replacementTxt) :notation,
                backgroundColor: CAS_AlertDataModel.returnValueForPredefinedType().backColor(predefinedType),
                buttonTitle: cancelTitle.isEmpty ?"OK" :cancelTitle,
                imageName: CAS_AlertDataModel.returnValueForPredefinedType().imgName(predefinedType),
                iconColor: CAS_AlertDataModel.returnValueForPredefinedType().iconColor(predefinedType),
                width: width,
                align_Title: TextAlignment.center,
                align_Message: TextAlignment.center,
                align_Notation: TextAlignment.leading,
                actionTitle: actionTitle,
                buttonPressed: buttonPressed ?? .constant(.cancel_OK),
                notationIsAttributed: true
            )
            .zIndex(99)
        }
    }
    
    struct view: View {
        @Binding var showAlert:Bool
        
        // Required Params
        var title:String
        var style:styleTypes

        // Optional Params with defaults
        var message:String = ""
        var notation:String = ""
        var backgroundColor:Color = .white
        var buttonTitle:String = "OK"
        var borderColor:Color = .black
        var textColor:Color = .black
        var notationColor:Color = .Steel
        var imageName:String = ""
        var iconSize:CGFloat = 50.0
        var iconColor:Color = .white
        var width:CGFloat = UIDevice.Family.isPad ?700.0 :350.0
        var align_Title:TextAlignment = .center
        var align_Message:TextAlignment = .center
        var align_Notation:TextAlignment = .center
        var titleSize:CGFloat =  UIDevice.Family.isPad ?36 :28.0
        var messageSize:CGFloat = UIDevice.Family.isPad ?24 :18.0
        var notationSize:CGFloat = UIDevice.Family.isPad ?20 :14.0
        var safeAreaInset:CGFloat = 300
        var actionTitle:String = ""
        @Binding var buttonPressed:CAS_Alert.buttonPressed
        var notationIsAttributed:Bool = false

        init(
            showAlert:Binding<Bool>,
            title:String,
            style:CAS_Alert.styleTypes,
            message:String = "",
            notation:String = "",
            backgroundColor:Color = .white,
            buttonTitle:String = "OK",
            imageName:String = "",
            iconSize:CGFloat = 50.0,
            iconColor:Color = .white,
            width:CGFloat = UIDevice.Family.isPad ?UIScreen.width - 100 :UIScreen.width - 50,
            align_Title:TextAlignment = .center,
            align_Message:TextAlignment = .center,
            align_Notation:TextAlignment = .center,
            titleSize:CGFloat = UIDevice.Family.isPad ?36 :28.0,
            messageSize:CGFloat = UIDevice.Family.isPad ?24 :18.0,
            notationSize:CGFloat = UIDevice.Family.isPad ?20 :14.0,
            safeAreaInset:CGFloat = 300,
            actionTitle:String = "",
            buttonPressed:Binding<CAS_Alert.buttonPressed> = .constant(.cancel_OK),
            notationIsAttributed:Bool = false
        ) {
            self._showAlert = showAlert
            self.title = title
            self.style = style
            self.message = message
            self.notation = notation
            self.buttonTitle = buttonTitle
            self.iconSize = iconSize
            self.width = width
            self.align_Title = align_Title
            self.align_Message = align_Message
            self.align_Notation = notationIsAttributed ?.leading :.center
            self.titleSize = titleSize
            self.messageSize = messageSize
            self.notationSize = notationSize
            self.safeAreaInset = safeAreaInset
            self.actionTitle = actionTitle
            self._buttonPressed = buttonPressed
            self.notationIsAttributed = notationIsAttributed

            if style == .custom {
                self.backgroundColor = backgroundColor
                self.imageName = imageName
                self.iconColor = iconColor
            }else{
                self.backgroundColor = CAS_AlertDataModel.returnValueForType().backColor(self.style)
                self.imageName = CAS_AlertDataModel.returnValueForType().imgName(self.style)
                self.iconColor = CAS_AlertDataModel.returnValueForType().iconColor(self.style)
            }
        }
        
        struct modTitle: ViewModifier {
            var titleSize:CGFloat
            var align_Title:TextAlignment
            var textColor:Color
            var paddingH:CGFloat = 5

            func body(content: Content) -> some View {
                content
                    .font(.system(size: titleSize))
                    .multilineTextAlignment(align_Title)
                    .foregroundColor(textColor)
                    .bold()
                    .underline()
                    .allowsTightening(true)
                    .minimumScaleFactor(0.5)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal,paddingH)
            }
        }

        struct modBody: ViewModifier {
            var bodySize:CGFloat
            var align_Body:TextAlignment
            var textColor:Color
            var paddingH:CGFloat = 5
            
            func body(content: Content) -> some View {
                content
                    .font(.system(size: bodySize))
                    .multilineTextAlignment(align_Body)
                    .foregroundColor(textColor)
                    .bold()
                    .minimumScaleFactor(0.5)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal,paddingH)
            }
        }

        func scrollArrowView() -> some View {
            return VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    Image(systemName: "arrow.up.arrow.down.square.fill")
                        .resizable()
                        .foregroundColor(.gray)
                        .frame(width: 40, height: 30)
                        .background(Color.white)
                }//End HStack
                .padding(.trailing,10)
            }
        }

// MARK: - *** VIEW ***
        var body: some View {
            GeometryReader { geometry in
                ZStack {
                    Rectangle()
                        .fill(Color.black.opacity(0.33))
                        .edgesIgnoringSafeArea(.all)
                        .background(.thinMaterial)
                    
                    VStack {
                        Spacer().frame(height: iconSize * 2)

                        VStack {
                            VStack(alignment: .center) {
                                let textContentHeight = CAS_Alert().textHeight(
                                    screenHeight: geometry.size.height,
                                    containerWidth: width - 20,
                                    message: message,
                                    notation: notation,
                                    messageSize: messageSize,
                                    notationSize: notationIsAttributed ?notationSize - 1.75 :notationSize,
                                    safeArea: safeAreaInset
                                )
                                
                                Spacer().frame(height: iconSize)

                                Text(title)
                                    .modifier(modTitle(titleSize:titleSize,align_Title:align_Title,textColor:textColor))

                                Spacer().frame(height: 10.0)

                                ZStack {
                                    ScrollView(.vertical, showsIndicators: true) {
                                        Text(message)
                                            .modifier(modBody(bodySize:messageSize,align_Body:align_Message,textColor:textColor,paddingH: 10))

                                        if !notation.isEmpty {
                                            if notationIsAttributed {
                                                Text(notation.markdownToAttributed())
                                                    .modifier(modBody(bodySize:notationSize,align_Body:align_Notation,textColor:notationColor))
                                            }else{
                                                Text(notation)
                                                    .modifier(modBody(bodySize:notationSize,align_Body:align_Notation,textColor:notationColor))
                                            }
                                        }
                                    }
                                    .frame(height: textContentHeight.height, alignment: .topLeading)
                                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .circular))
                                    .background(
                                        textContentHeight.scrolls
                                            ? Color.black.opacity(0.05)
                                            : Color.clear
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(
                                                textContentHeight.scrolls
                                                    ?Color.black.opacity(0.25)
                                                    :Color.clear,
                                                lineWidth: 2
                                            )
                                    )
                                    .zIndex(90)

                                    // Add scrollable arrow if text height is larger than displaable area.
                                    if textContentHeight.scrolls {
                                        scrollArrowView()
                                    }//End If
                                }//End ZStack

                                Spacer().frame(height: 10.0)

                                HStack {
                                    if !actionTitle.isEmpty {
                                        Button(action: {
                                            buttonPressed = .action
                                            showAlert.toggle()
                                            simPrint(type: .info, msg: "Action button pressed, hiding CAS_Alert Modal View...", log: logFileFunctionLine())
                                        }) {
                                            HStack {
                                                Spacer()
                                                Text(actionTitle)
                                                    .font(.title)
                                                    .bold()
                                                    .foregroundColor(iconColor)
                                                Spacer()
                                            }
                                        }
                                        .padding(.vertical,10)
                                        .background(backgroundColor)
                                        .cornerRadius(15.0)

                                        Spacer()
                                    }
                                    
                                    Button(action: {
                                        buttonPressed = .cancel_OK
                                        showAlert.toggle()
                                        simPrint(type: .info, msg: "Cancel pressed, hiding CAS_Alert Modal View...", log: logFileFunctionLine())
                                    }) {
                                        HStack {
                                            Spacer()
                                            Text(buttonTitle)
                                                .font(.title)
                                                .bold()
                                                .foregroundColor(iconColor)
                                            Spacer()
                                        }
                                    }
                                    .padding(.vertical,10)
                                    .background(actionTitle.isEmpty ?backgroundColor :backgroundColor.opacity(0.75))
                                    .cornerRadius(15.0)
                                }
                                .padding(.all,10)
                                .padding(.bottom,10)
                            }// Title, Message & Button
                        }
                        .padding(.horizontal,10)
                        .background(
                            RoundedRectangle(cornerRadius: 20.0)
                                .stroke(backgroundColor, lineWidth: 8.0)
                                .background(Color.white.opacity(0.9))
                                .cornerRadius(10.0)
                        )
                        .cornerRadius(20.0)
                        .padding(.horizontal,10)
                        .padding(.top, -iconSize)
                        .overlay(
                            CAS_Alert().iconBackground(
                                iconSize: iconSize,
                                imageName: imageName,
                                iconColor: iconColor,
                                backgroundColor: backgroundColor
                            )
                            .padding(.top, -(iconSize * 2))
                            ,alignment: .top
                        )
                    }
                    .frame(width: width, alignment: .center)
                    .offset(y: -iconSize/2)
                    .zIndex(2)
                }
            }
            .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.2)))
            .zIndex(.greatestFiniteMagnitude)
            .preferredColorScheme(.light)
        }
    }
}

// MARK: - *** PREVIEW ***
#Preview {
    CAS_Alert.view(
        showAlert: .constant(true),
        title: "This is a test\n",
        style: .construction,
        message: ("Age\n is\n blank\n and\n required\n to\n continue."),
        notation: ("Notation lines go here\n in\n real\n test.")
    )
}


