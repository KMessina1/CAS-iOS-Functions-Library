/*--------------------------------------------------------------------------------------------------------------------------
    File: CutomeImagePicker.swift
  Author: Kevin Messina
 Created: 6/21/24
Modified:
 
©2024-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import SwiftUI
import PhotosUI

class ProfilePhoto: ObservableObject {
    @Published var myPhoto: Image?
    
    init ( myPhoto: Image? ) {
        self.myPhoto = myPhoto
    }
}

extension View {
    @ViewBuilder
    func cropImagePicker(
        options: [Crop],
        show: Binding<Bool>,
        croppedImage: Binding<UIImage?>,
        directory: Files.directories
    ) -> some View {
        CustomImagePicker(options: options, show: show, croppedImage: croppedImage, directory: directory) {
            self
        }
    }
    
    @ViewBuilder func frame(_ size:CGSize)-> some View{
        self
        .frame(width: size.width, height: size.height)
    }
    
    func haptics(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
}

fileprivate struct CustomImagePicker<Content: View>: View {
    var content: Content
    var options: [Crop]
    @Binding var show: Bool
    @Binding var croppedImage: UIImage?
    var directory: Files.directories
    
    init (options: [Crop], show: Binding<Bool>,croppedImage: Binding<UIImage?>,directory: Files.directories,@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        self._show = show
        self._croppedImage = croppedImage
        self.options = options
        self.directory = directory
    }
    
    @State private var photosItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var showDialog: Bool = false
    @State private var selectedCropType: Crop = .circle 
    @State private var showCropView: Bool = false
    
    var body: some View {
        content
            .photosPicker(isPresented: $show, selection: $photosItem, matching: .images)
            .onChange(of: photosItem) { _, newValue in
                if let newValue {
                    Task {
                        if let imageData = try? await newValue.loadTransferable(type: Data.self),
                           let image = UIImage(data: imageData) {
                            await MainActor.run { 
                                selectedImage = image
                                showDialog.toggle()
                            }
                        }
                    }
                }
            }
            .confirmationDialog("Replace Image", isPresented: $showDialog) {
                Button("Edit selected Image?") {
                    selectedCropType = options.count > 0 ? options[0] : .circle
                    showCropView.toggle()
                }
            }
            .fullScreenCover(isPresented: $showCropView, onDismiss: {
                selectedImage = nil
            }, content: {
                CropView(crop: selectedCropType, image: selectedImage) { croppedImg, status in
                    if let croppedImg {
                        self.croppedImage = croppedImg

                        let filePathURL = Files().getPathForFilename(profilePic, in: directory).url

                        // Copy and rename file for backup
                        if Files().exists(filename: profilePic, in: directory) {
                            Files().moveOrRename(fromName: profilePic, fromDir: directory, toName: profilePicBackup, in: directory)
                        }

                        // Save new image
                        do {
                            try croppedImg.jpegData(compressionQuality: 1.0)?.write(to: filePathURL, options: .atomic)
                        } catch {
                            print("file was not saved at path \(filePathURL), with error : \(error)");
                        }
                    }
                }
            })
    }
}

struct CropView: View {
    @Environment(\.dismiss) private var dismiss
    let CT = CurrentTheme().getThemeFromUserStds()
    
    var crop: Crop
    var image: UIImage? 
    var onCrop: (UIImage?,Bool)->()
    
    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 0 
    @State private var offset: CGSize = .zero 
    @State private var lastStoredOffset: CGSize = .zero 
    @GestureState private var isInteracting: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack {
                ImageView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
            }//End VStack
            .navigationTitle("Resize Image")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { 
                    Button(action: {
                        dismiss()
                    }, label: {
                        HStack(spacing:5) {
                            Image(systemName: AppImages.Disclosure_Lt)
                                .resizable()
                                .scaledToFit()
                                .bold()
                            
                            Text("Cancel")
                                .foregroundStyle(CT.lightest)
                        }
                    })
                    .tint(CT.lightest)
                }//End ToolbarItem
                
                ToolbarItem(placement: .topBarTrailing) { 
                    Button(action: {
                        let renderer = ImageRenderer(content: ImageView(true))
                        renderer.proposedSize = .init(crop.size())
                        
                        if let image = renderer.uiImage{
                            onCrop(image,true)
                        }else{
                            onCrop(nil,false)
                        }
                        
                        dismiss()
                    }, label: {
                        HStack(spacing:5) {
                            Image(systemName: AppImages.checkmark)
                                .resizable()
                                .scaledToFit()
                                .bold()
                                .foregroundStyle(CT.accent)
                            
                            Text("Save")
                                .foregroundStyle(CT.lightest)
                        }
                    })
                    .tint(CT.lightest)
                }//End ToolbarItem
            }//End Toolbar
        }//End NavStack
    }//End Body
    
    @ViewBuilder
    func ImageView(_ hideGrids:Bool=false)-> some View {
        let cropSize = crop.size()
        
        GeometryReader {
            let size = $0.size
            
            if let image {
                Image(uiImage: image)
                    .resizable() 
                    .aspectRatio(contentMode: .fill)
                    .overlay(
                        GeometryReader { proxy in 
                            let rect = proxy.frame(in: .named("CROPVIEW"))
                            
                            Color.clear
                                .onChange(of: isInteracting) { _,newValue in
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        if rect.minX > 0 {
                                            offset.width = offset.width - rect.minX
                                            haptics(.medium)
                                        }
                                        
                                        if rect.minY > 0 {
                                            offset.height = offset.height - rect.minY
                                            haptics(.medium)
                                        }   

                                        if rect.maxX < size.width {
                                            offset.width =  rect.minX - offset.width
                                            haptics(.medium)
                                        }
                                        
                                        if rect.maxY < size.height {
                                            offset.height =  rect.minY - offset.height
                                            haptics(.medium)
                                        }   
                                    }                                    

                                    if !newValue {
                                        lastStoredOffset = offset
                                    }
                                }
                        }//End Geometry Reader
                    )//End Overlay
                    .frame(size)
                    .onChange(of: isInteracting) { _, newValue in
                        if !newValue {
                            lastStoredOffset = offset
                        }
                    }//End OnChange
            } //End If
        }
        .scaleEffect(scale)
        .offset(offset)
        .overlay{
            if !hideGrids {
                Grids()
            }
        }
        .frame(cropSize)
        .cornerRadius(crop == .circle ?cropSize.height/2 :0)
        .coordinateSpace(name: "CROPVIEW")
        .gesture(
            DragGesture()
                .updating($isInteracting, body: { _, out, _ in
                    out = true
                })
                .onChanged({ value in
                    let translation = value.translation
                    offset = CGSize(
                        width: translation.width + lastStoredOffset.width,
                        height: translation.height + lastStoredOffset.height
                    )
                })
                .onEnded({ value in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        if scale < 1 {
                            scale = 1
                            lastScale = 0
                        }else{
                            lastScale = scale - 1
                        }
                    }
                })
        )
        .gesture(
            MagnificationGesture()
                .updating($isInteracting, body: { _, out, _ in
                    out = true
                })
                .onChanged({ value in
                    let updatedScale = value + lastScale    
                    scale = (updatedScale < 1) ?1 :updatedScale
                })
        )
    }
    
    @ViewBuilder 
    func Grids()-> some View{
        ZStack {
            HStack{
                ForEach(0...5, id: \.self) { index in
                    Rectangle()
                        .fill(.white.opacity(0.7))
                        .frame(width:1)
                        .frame(maxWidth: .infinity)
                }
            }

            VStack{
                ForEach(0...8, id: \.self) { index in
                    Rectangle()
                        .fill(.white.opacity(0.7))
                        .frame(height:1)
                        .frame(maxHeight: .infinity)
                }
            }
        }
    }
}
