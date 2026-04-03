/*--------------------------------------------------------------------------------------------------------------------------
    File: DocScanView.swift
  Author: Kevin Messina
 Created: 6/29/24
Modified:
 
©2024-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import SwiftUI
import PDFKit
import VisionKit

/// DocScanView
///     Table: determines the suffix of the image (Inventory, Provenance, Session
///     ScannedImages: holder for NEW images to pass back to caller.
///     SavedImgFilenames: holder for NEW image filenames to pass back to caller.
///     AllImgs: The images array passed in and appended to pass back to caller.
///     DocTypes: Images or PDF's
///     SaveIn: App local directory to store new scans in.
///
/// Useage:     DocScanView(
///                 table: .provenance,
///                 scannedImages: $scannedImages,
///                 savedImgFilenames: $savedImgFilenames,
///                 allImgs: $scannedImages_All,
///                 docTypes: .images,
///                 saveIn: .provenanceDir
///             )
public struct DocScanView: View {
    @Environment(\.dismiss) var dismiss
    let CT = CurrentTheme().getThemeFromUserStds()
    
    enum TableTypes { case inventory, provenance, session }
    enum DocTypes { case images, pdfs, all }

    //Input Params
    var table: TableTypes
    @Binding var scannedImages: [UIImage]
    @Binding var savedImgFilenames: String
    @Binding var allImgs: [UIImage]

    //View Params
    @State var showScan: Bool = false
    @State var docTypes:DocTypes
    @State var saveIn:Files.directories
    @State var bypassSave: Bool = false

    var scannerAvailable: Bool {
        DataScannerViewController.isSupported &&
        DataScannerViewController.isAvailable
    }

    var body: some View {
        NavigationView {
            ZStack {
                gradientBackgroundView()

                VStack {
                    VStack(spacing: 0) {
                        HStack {
                            Image.getResizable("ProperScanning")
                                .frame(height: 65)
                            
                            Spacer()
                            
                            scanBtn
                        }
                        
                        Text("ALWAYS SCAN ITEMS FACING YOU!")
                            .font(.title2)
                            .foregroundStyle(.pink)
                            .fontWidth(.expanded)
                        Text("ROTATE DEVICE BY ITEM SIZE (WIDE = HORIZONTAL, TALL = VERTICAL)")
                            .font(.headline)
                            .fontWidth(.condensed)
                    }
                    .lineLimit(1)
                    .minimumScaleFactor(0.70)
                    .bold()
                    .foregroundStyle(CT.lightest)
                    .frame(height: 90)
                    .padding(.top,10)
                    .padding(.horizontal,20)

                    myDivider()

                    if !scannerAvailable {
                        Spacer()
                        
                        ContentUnavailableView {
                            Label("Scanner Unavailable", systemImage: AppImages.photo_Issue)
                                .foregroundStyle(CT.lightest)
                        } description: {
                            Text("Camera services are not avaialble.")
                                .italic()
                                .foregroundStyle(CT.light)
                                .padding(.top,10)
                        }//End ContentUnavail
                    }else if scannedImages.count < 1 {
                        Spacer()

                        ContentUnavailableView {
                            Label("No Scanned Items", systemImage: AppImages.doc_Scan)
                                .foregroundStyle(CT.lightest)
                        } description: {
                            Text("Scanned items will appear here as they are scanned.")
                                .italic()
                                .foregroundStyle(CT.light)
                                .padding(.top,10)
                        }//End ContentUnavail
                    } else {
                        ScrollView {
                            ForEach(scannedImages, id: \.self) { image in
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 300, height: 300)
                            }//End ForEach
                        }//End ScrollView
                        .modifier(scrollViewModifier())
                    }

                    Spacer()
                }//End VStack
            }//End ZStack
            .sheet(isPresented: $showScan) {
                VNDocumentCameraViewControllerRepresentable(scanResult: $scannedImages)
            }
            .toolbarBackground(.hidden, for: .bottomBar)
            .toolbarBackground(Color.black, for: .bottomBar)
            .toolbarColorScheme(.dark, for: .bottomBar)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    VStack(alignment: .leading) {
                        HStack(spacing: 0){
                            if docTypes == .images {
                                resetBtn
                                Spacer()
                                saveImage
                            }else if docTypes == .pdfs {
                                resetBtn
                                Spacer()
                                savePDF
                            }else{
                                resetBtn
                                Spacer()
                                saveImage
                                Spacer()
                                savePDF
                            }
                        }
                    }
                }
            }
        }
        .task {
            scannedImages = []
        }
    }
    
    @ViewBuilder
    var resetBtn: some View {
        let isDisabled = (scannedImages.count < 1) || !scannerAvailable
        
        Button {
            withAnimation {
                scannedImages = []
                savedImgFilenames = ""
            }
        } label: { cardButtonTitle(title: "Clear", icon: AppImages.trash, isDisabled: isDisabled) }
            .modifier(Card_ButtonStyle(color: .red, isDisabled: isDisabled))
    }
    
    @ViewBuilder
    var saveImage: some View {
        let isDisabled = (scannedImages.count < 1) || !scannerAvailable
        var tableSuffix: String = ""
        
        Button {
            DispatchQueue.main.async {
                for indx in 0..<scannedImages.count {
                    let image:UIImage = scannedImages[indx]
                    simPrint("image size is \(image.size.width), \(image.size.height)", action: .info, log: LFFL())
                    
                    // Save new image
                    switch table {
                        case .inventory: tableSuffix = "inv"
                        case .provenance: tableSuffix = "prov"
                        case .session: tableSuffix = "sess"
                    }
                    
                    let filename = "\( Date.now.formattedAs(fileDateFormat) )-\( tableSuffix ).jpg"

                    if bypassSave {
                        savedImgFilenames.append(savedImgFilenames.isEmpty ?"\(filename)" :",\(filename)")
                    }else{
                        var url = URL(fileURLWithPath: "")
                        
                        switch table {
                            case .inventory: url = Files().returnPathForFilename(filename, in: .inventoryDir).url
                            case .provenance: url = Files().returnPathForFilename(filename, in: .provenanceDir).url
                            case .session: url = Files().returnPathForFilename(filename, in: .sessionsDir).url
                        }

                        do {
                            try image.jpegData(compressionQuality: 1.0)?.write(to: url, options: .atomic)
                            
                            savedImgFilenames.append(savedImgFilenames.isEmpty ?"\(filename)" :",\(filename)")
                            
                            simPrint("Scanned file: \(filename) saved.", action: .success,file: filename,log: LFFL(),  forceShow: true)
                        } catch(let error) {
                            print("Scanned file: \(filename) was not saved at path with error : \(error)");
                        }//End Do
                    }//End If
                }//End For
                
                allImgs.append(contentsOf: scannedImages)
                
                dismiss()
            }
        } label: { cardButtonTitle(title: "Save", icon: AppImages.photos, isDisabled: isDisabled) }
            .modifier(Card_ButtonStyle(color: .green, isDisabled: isDisabled))
    }
    
    @ViewBuilder
    var savePDF: some View {
        let isDisabled = (scannedImages.count < 1) || !scannerAvailable
        var tableSuffix: String = ""

        Button {
            DispatchQueue.main.async {
                let pdfDocument = PDFDocument()

                for indx in 0..<scannedImages.count {
                    let image:UIImage = scannedImages[indx]
                    simPrint("image size is \(image.size.width), \(image.size.height)", action: .info, log: LFFL())
                    let pdfPage = PDFPage(image: image)
                    pdfDocument.insert(pdfPage!, at: indx)
                }
        
                // Get the raw data of your PDF document
                let data = pdfDocument.dataRepresentation()
                
                // Delete all but first page of .pdf as saved image...
                if scannedImages.count > 1 {
                    let firstImage = scannedImages[0]
                    scannedImages.removeAll()
                    scannedImages = [firstImage]
                }
                
                allImgs.append(scannedImages[0])

                // Save new document
                switch table {
                    case .inventory: tableSuffix = "inv"
                    case .provenance: tableSuffix = "prov"
                    case .session: tableSuffix = "sess"
                }
                
                let filename = "\( Date.now.formattedAs(fileDateFormat) )-\( tableSuffix ).pdf"
                var url = URL(fileURLWithPath: "")
                
                do {
                    switch table {
                        case .inventory: url = Files().returnPathForFilename(filename, in: .inventoryDir).url
                        case .provenance: url = Files().returnPathForFilename(filename, in: .provenanceDir).url
                        case .session: url = Files().returnPathForFilename(filename, in: .sessionsDir).url
                    }

                    try data?.write(to: url, options: .atomic)

                    simPrint("Scanned file: \(filename)", action: .success,file: filename,log: LFFL(), forceShow: true)
                    savedImgFilenames.append(savedImgFilenames.isEmpty ?"\(filename)" :",\(filename)")
                } catch(let error) {
                    print("\(filename) was not saved, with error : \(error)")
                }//End Do...Loop

                dismiss()
            }
        } label: { cardButtonTitle(title: "Save", icon: AppImages.doc_Text, isDisabled: isDisabled) }
            .modifier(Card_ButtonStyle(color: .green, isDisabled: isDisabled))
    }
    
    var scanBtn: some View {
        Button{
            showScan.toggle()
        } label: {
            var title: String = ""
            switch docTypes {
                case .all: title = "Scan Item"
                case .images: title = "Scan Photo"
                case .pdfs: title = "Scan Doc"
            }
            
            return Label(title, systemImage: AppImages.scanner)
        }
        .modifier(button_Std(buttonType: .theme, padding: 0, corner: 8))
        .disabled(!scannerAvailable)
    }
}

#Preview {
    @Previewable @State var imgName: String = ""
    @Previewable @State var imgs: [UIImage] = []
    @Previewable @State var AllImgs: [UIImage] = []
    
    DocScanView(
        table: .provenance,
        scannedImages: $imgs,
        savedImgFilenames: $imgName,
        allImgs: $AllImgs,
        docTypes: .all,
        saveIn: .docsDir
    )
}
