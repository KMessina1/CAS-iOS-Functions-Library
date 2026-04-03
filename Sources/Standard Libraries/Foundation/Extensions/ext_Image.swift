/*--------------------------------------------------------------------------------------------------------------------------
    File: ext_Image.swift
  Author: Kevin Messina
 Created: 6/8/24
Modified:
 
©2024-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
 
2024_11_03  Added Image Modifier capability
--------------------------------------------------------------------------------------------------------------------------*/

import Foundation
import SwiftUI

extension Image {
    init(resource name: String, ofType type: String) {
        guard let path = Bundle.main.path(forResource: name, ofType: type),
              let image = UIImage(contentsOfFile: path) else {
            self.init(name)
            return
        }
        self.init(uiImage: image)
    }
    
    func modifier<M>(_ modifier: M) -> some View where M: ImageModifier {
        modifier.body(image: self)
    }
    
    struct resize: ImageModifier {
        var size: CGFloat = deviceIs.Pad ? 60 : 30
        var render: Image.TemplateRenderingMode = .template
        var align: Alignment = .center
        var color: Color = .white
        
        func body(image: Image) -> some View {
            image
                .renderingMode(render)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size, alignment: align)
                .foregroundStyle(render != .original ?color :.clear)
        }
    }
    
    func isImageLandscape(_ image: UIImage) -> Bool {
        return image.size.width > image.size.height
    }
    
    struct resizableAndScaledToFit: ImageModifier {
        func body(image: Image) -> some View {
            image
                .resizable()
                .scaledToFit()
        }
    }
    
    struct resizableAndScaledToFill: ImageModifier {
        func body(image: Image) -> some View {
            image
                .resizable()
                .scaledToFill()
        }
    }
    
    @ViewBuilder
    static func getResizable(_ name:String) -> some View {
        if let _ = (UIImage(systemName: name)) {
            Image(systemName: name).resizable().scaledToFit()
        } else if let _ = (UIImage(named: name)) {
            Image(name).resizable().scaledToFit()
        } else {
            EmptyView()
        }
    }

    @ViewBuilder
    static func getResizableNoAspect(_ name:String) -> some View {
        if let _ = (UIImage(systemName: name)) {
            Image(systemName: name).resizable()
        } else if let _ = (UIImage(named: name)) {
            Image(name).resizable()
        } else {
            EmptyView()
        }
    }

    static func get(_ name:String) -> Image {
        if (UIImage(systemName: name)) != nil {
            return Image(systemName: name)
        }else if (UIImage(named: name)) != nil {
            return Image(name).resizable()
        }else{
            return Image("")
        }
    }

    static func getUIImageFromDir(_ imgName: String, dir: Files.directories) -> UIImage {
        if let img = UIImage(contentsOfFile: Files().returnPathForFilename(imgName, in: dir).path) {
            return img
        }else{
            return UIImage(named: "NoPhotoText")!
        }
    }

    static func getImageFromDir(_ imgName: String, dir: Files.directories) -> some View {
        let imgURL:URL = Files().returnPathForFilename(imgName, in: dir).url
        
        var placeholder: some View {
            ZStack {
                Color.white.opacity(0.35).border(Color.gray)
    
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.black)
            }
        }

        var imgNotAvailalble: some View {
            ZStack {
                Color.white.opacity(0.35).border(Color.gray)
                
                VStack(spacing: 0){
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .padding(.top,5)
                        .padding(.bottom,1)

                    Text("Not Available")
                        .font(.body)
                        .fontWidth(.condensed)
                        .bold()
                }
                .foregroundStyle(.black)
            }
        }

        return AsyncImage(url: imgURL) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFit()
            } else if phase.error != nil {
                AsyncImage(url: imgURL) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                    } else if phase.error != nil {
                        imgNotAvailalble
                    } else {
                        placeholder
                    }
                }
            } else {
                placeholder
            }
        }
    }
}

protocol ImageModifier {
    /// `Body` is derived from `View`
    associatedtype Body : View
    
    /// Modify an image by applying any modifications into `some View`
    func body(image: Image) -> Self.Body
}
