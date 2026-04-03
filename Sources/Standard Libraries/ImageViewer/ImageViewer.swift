/*--------------------------------------------------------------------------------------------------------------------------
    File: ImageViewer.swift
  Author: Kevin Messina
 Created: 6/21/24
Modified:
 
©2024-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
 
2025_07_07: Removed private from uiImage so it can be set from Photos Picker and view enlarged as UIImage.
--------------------------------------------------------------------------------------------------------------------------*/

import SwiftUI
import PDFKit

struct ImageDetailView: UIViewRepresentable {
    let uiImage: UIImage
    
    func makeUIView(context: Context) -> PDFView {
        let imgView = PDFView()
        imgView.document = PDFDocument()

        guard
            let page = PDFPage(image: uiImage)
        else {
            return imgView
        }
        
        // Configure appearance and layout
        imgView.document?.insert(page, at: 0)
        imgView.backgroundColor = .clear
        imgView.displayDirection = .vertical
        imgView.autoScales = true

        return imgView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {
        // Nothing to update for now. If needed, reassign the document or adjust settings here.
    }
}

struct ImageViewer: View {
    @Environment(\.dismiss) private var dismiss
    let CT = CurrentTheme().getThemeFromUserStds()
    @Environment(\.displayScale) var displayScale

    // ShareSheet
    @State var showShareSheet: Bool = false
    @State var showDeleteConfirm: Bool = false
    @State var showAlert: Bool = false
    @State var uiImage: UIImage?

    @State private var imgURL: URL = URL(fileURLWithPath: "")
    @State private var imgPath: String = ""
    @State private var imgName: String = "n/a"
    @State private var rotationDegrees: Double = 0.0
    @State var convasImg: String = ""

    // Progress selections
    @State var showProgress: Bool = false
    @State var progress: Double = 0.0

    func LoadingView() -> some View {
        VStack {
            Spacer()
            ProgressView(value: progress, total: 1.0, label: {
                Text("Loading...")
                    .font(.headline)
                    .foregroundStyle(.yellow)
            })
            .progressViewStyle(.circular)
            .tint(.yellow)
            .scaleEffect(2)
            Spacer()
        }
    }

    @ViewBuilder
    func fileInfo() -> some View {
        if imgName.count > 15 {
            let dateTxt = imgName
                .substring(fromTo: 0...8)
                .toConvertedDate(from: .yyyyMMdd, to: .MMM_d_yyyy)
            let timeTxt = imgName
                .substring(fromTo: 9...15)
                .toConvertedDate(from: .hhmmss, to: .h_m_a)
            
            VStack(alignment: .center){
                Spacer()
                
                HStack(spacing: 3){
                    Image(systemName: AppImages.calendar)
                        .font(.title)
                    Text("\(dateTxt) @ \(timeTxt)")
                        .font(.headline)
                }
                .foregroundStyle(CT.lightest)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .padding(.vertical,8)
                .padding(.horizontal,12)
                .glassEffect(.regular.tint(.black.opacity(0.6)))
            }//End VStack
        }else{
            EmptyView()
        }
    }
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            ZStack {
                gradientBackgroundView()
                
                VStack {
                    if uiImage != nil {
                        ImageDetailView(uiImage: uiImage!)
                    } else {
                        Spacer()
                        ContentUnavailableView("Image Not Found", systemImage: AppImages.photo)
                            .foregroundStyle(CT.lightest)
                        Spacer()
                    }
                }//End VStack
                
                fileInfo()
                
                LoadingView()
                    .opacity(showProgress ?1 :0)
            }//End ZStack
            .toolbar {
                TB().title("PHOTO VIEWER")
                TB().subtitle(imgName)

                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        TB().buttonImg(.cancel)
                    }
                    .modifier(TB.buttonColor(color: .clear))
                }//End ToolbarItem

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showShareSheet.toggle()
                    } label: {
                        TB().buttonImg(.share)
                    }
                    .modifier(TB.buttonColor(color: .orange))
                }//End ToolbarItem
            }//End Toolbar
            .sheet(isPresented: $showShareSheet, content: {
                ActivityViewController(itemsToShare: [imgURL])
            })
            .onAppear {
                DispatchQueue.main.async {
                    showProgress = true
                    progress = 0.0
                }

                if deviceIs.CanvasPreview {
                    imgName = convasImg
                }else{
                    imgName = UserDefaults.standard.string(forKey: KeyNames.App.selectedIMG) ?? "n/a"
                }//End If

                if uiImage == nil {
                    imgURL = URL(fileURLWithPath: "")
                    imgPath = ""
                    
                    if imgName.contains("-prov.jpg") {
                        let filePath = Files().getPathForFilename(imgName, in: .provenanceDir)
                        imgURL = filePath.url
                        imgPath = filePath.path
                    }else if imgName.contains("-inv.jpg") {
                        let filePath = Files().getPathForFilename(imgName, in: .inventoryDir)
                        imgURL = filePath.url
                        imgPath = filePath.path
                    }else if imgName.contains("-range.jpg") {
                        let filePath = Files().getPathForFilename(imgName, in: .sessionsDir)
                        imgURL = filePath.url
                        imgPath = filePath.path
                    }else{
                        let filePath = Files().getPathForFilename(imgName, in: .docsDir)
                        imgURL = filePath.url
                        imgPath = filePath.path
                    }//End If

                    if !imgName.isEmpty {
                        if let image = UIImage(contentsOfFile: imgPath) {
                            uiImage = image
                        }//End If
                    }//End If
                }//End If

                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    showProgress = false
                    progress = 1.0
                }
            }//End OnAppear
        }//End NavStack
    }
}

#Preview {
    ImageViewer(convasImg: "20250929@122424_789-inv.jpg")
}


