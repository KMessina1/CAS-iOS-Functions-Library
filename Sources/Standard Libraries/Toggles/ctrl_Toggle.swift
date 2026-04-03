/*--------------------------------------------------------------------------------------------------------------------------
    File: ctrl_Toggle.swift
  Author: Kevin Messina
 Created: 5/24/24
Modified:
 
©2024-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import SwiftUI

/// Checkbox ToggleStyle
///
/// Usage:                         
///     Toggle("Don't show this tip again", isOn: $changeDisplaySetting)
///         .toggleStyle(CheckboxToggleStyle(size:30))
///         .onChange(of: changeDisplaySetting) { _, _ in
///             UserDefaults.standard.set(false, forKey: KeyNames.App.Calc.tips)
///             UserDefaults.standard.synchronize()
///         }
///
/// - Parameters:
///     size: Size of checkbox
///
struct CheckboxToggleStyle: ToggleStyle {
    var size:CGFloat = 22.0
    var showXForOff: Bool = false
    var textColor: Color = .orange
    var onColor: Color = .green
    var offColor: Color = .red

    func makeBody(configuration: Configuration) -> some View {
        return HStack {
            configuration.label
                .foregroundStyle(textColor)
            
            ZStack {
                Image.getResizable("square")
                    .foregroundStyle(textColor)
                    .frame(width: size, height: size)
                    .onTapGesture { configuration.isOn.toggle() }

                Image.getResizable(configuration.isOn ? "checkmark" : showXForOff ?"xmark" :"")
                    .foregroundStyle(configuration.isOn ? .appGreen : .red)
                    .bold()
                    .frame(width: size - 10, height: size - 10)
                    .onTapGesture { configuration.isOn.toggle() }
            }
        }
    }
}


struct ctrl_ToggleStyle: ToggleStyle {
    let onColor: Color
    let offColor: Color
    let thumbColor: Color
    let thumbImgColor: Color
    let thumbImgShow: Bool
    let showTitle: Bool

    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            if showTitle {
                configuration.label
                    .font(.body)
                Spacer()
            }
            
            RoundedRectangle(cornerRadius: 16, style: .circular)
                .fill(configuration.isOn ? onColor : offColor)
                .frame(width: 46, height: 26)
                .overlay(
                    Circle()
                        .fill(thumbColor)
                        .shadow(radius: 1, x: 0, y: 1)
                        .padding(4)
                        .overlay(
                            Image(systemName: configuration.isOn
                                  ? thumbImgShow ?"checkmark.circle" :""
                                  : thumbImgShow ?"xmark.circle" :"")
                                .foregroundStyle(thumbImgColor)
                        )
                        .offset(x: configuration.isOn ? 10 : -10)
                )
                .onTapGesture {
                    withAnimation {
                        configuration.isOn.toggle()
                    }
                }
        }
    }
}

struct CustomizedToggleView: View {
    @State var isOn: Bool = false
    var body: some View {
        VStack {
            Toggle("Example Toggle", isOn: $isOn)
                .toggleStyle(ctrl_ToggleStyle(
                    onColor: .green ,
                    offColor: .red,
                    thumbColor: .orange,
                    thumbImgColor: .white,
                    thumbImgShow: true,
                    showTitle: true))

            Toggle("Default Toggle with Tint", isOn: $isOn)
                .tint(.yellow)

            Toggle("Don't show this tip again.", isOn: $isOn)
                .toggleStyle(CheckboxToggleStyle(size:30))
                .font(.system(size: 20.0, weight: .regular))
                .foregroundStyle(.red)
        }
        .padding()
    }
}

#Preview {
    CustomizedToggleView()
}

