/*--------------------------------------------------------------------------------------------------------------------------
    File: ContentView2.swift
  Author: Kevin Messina
 Created: 6/21/24
Modified:
 
©2024-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/


import SwiftUI

struct ContentView2: View {
    @State private var showPicker: Bool = false
    @State private var croppedImage: UIImage?
    
    var body: some View {
        VStack {
            if let croppedImage {
                Image(uiImage: croppedImage)   
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 400)
            }else{
                VStack(spacing: 0) {
                    ZStack {
                        Circle()
                            .foregroundStyle(.gray)
                            .frame(width: 300, height: 400)
                        
                        Text("No image is selected")
                            .font(.caption)
                            .foregroundStyle(.black)
                    }//End ZStack
                }//End VStack
            }//End If
            
            Text("Tap to Edit")
                .font(.callout)
                .padding(.top,-50)
        }//End VStack
        .onTapGesture(perform: {
            showPicker.toggle()  
        })
        .cropImagePicker(options: [.circle], show: $showPicker, croppedImage: $croppedImage, directory: .docsDir)
    }
}
