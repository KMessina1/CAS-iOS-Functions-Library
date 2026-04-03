/*--------------------------------------------------------------------------------------------------------------------------
    File: ctrl_TextFields.swift
  Author: Kevin Messina
 Created: 3/23/24
Modified:
 
©2024-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import SwiftUI

struct OutlinedTextFieldStyle_Preview: View {
    var body: some View {
        TextField("Type something...", text: .constant(""))
            .textFieldStyle(OutlinedTextFieldStyle(borderColor: .white, corner: 8.0, lineWidth: 2.0))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

struct OutlinedTextFieldStyle: TextFieldStyle {
    let borderColor: Color
    let corner: CGFloat
    let lineWidth: CGFloat

    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.all,7)
            
            .cornerRadius(corner)
            .overlay {
                RoundedRectangle(cornerRadius: corner, style: .continuous)
                    .stroke(borderColor, lineWidth: lineWidth, antialiased: true)
            }
    }
}

struct ClearButton: ViewModifier {
    @Binding var text: String
    
    func body(content: Content) -> some View {
        
        HStack {
            content
            if !text.isEmpty {
                Button {
                    text = ""
                }label: {
                    Image(systemName: "multiply.circle.fill")
                        .foregroundStyle(.gray)
                }
                .padding(.trailing, 10)
            }
        }
    }
}

extension View {
    func clearButton(text: Binding<String>) -> some View {
        modifier(ClearButton(text: text))
    }
}

/// ex: NumberTextField(text: $name, limitChars: 4, showCharCount: true)
struct NumberTextField: View {
    @Binding var text: String
    var limitChars: Int = 0
    var showCharCount: Bool = true
    var prompt:String = ""
    var secure:Bool = false

    var body: some View {
        HStack {
            if limitChars > 0 {
                if secure {
                    SecureField(prompt, text: $text, prompt: Text(prompt))
                        .limitText($text,to: limitChars)
                }else{
                    TextField(prompt, text: $text, prompt: Text(prompt))
                        .limitText($text,to: limitChars)
                }
            }else{
                if secure {
                    SecureField(prompt, text: $text, prompt: Text(prompt))
                }else{
                    TextField("Name", text: $text, prompt: Text(prompt))
                }
            }
            
            if showCharCount {
                Text("\(text.count)/\(4)")
                    .padding(.leading,10)
            }
        }
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .keyboardType(.numberPad)
        .numericOnly($text)
    }
}

#Preview {
    OutlinedTextFieldStyle_Preview()
}
