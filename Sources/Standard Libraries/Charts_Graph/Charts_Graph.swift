/*--------------------------------------------------------------------------------------------------------------------------
    File: DocScanView.swift
  Author: Kevin Messina
 Created: 6/29/24
Modified:
 
©2024 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import SwiftUI
import PDFKit
import VisionKit

public struct DocScanView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(CurrentTheme.self) var CT: CurrentTheme?

    enum TableTypes { case inventory, provenance }
    
    //Scanner Params
    var table: TableTypes
    @Binding var scannedImages: [UIImage]
    @Binding var savedImgFilenames:String
    @Binding var allImgs: [UIImage]

    //View Params
    @State var showScan = false
    var scannerAvailable: Bool {
        DataScannerViewController.isSupported &&
        DataScannerViewController.isAvailable
    }

    var body: some View {
        NavigationView {
            ZStack {
                gradientBackgroundView()

                VStack {
                    if !scannerAvailable {
                        Spacer()
                        
                        ContentUnavailableView {
                            Label("Scanner Unavailable", systemImage: AppImages.photo_Issue)
                                .foregroundStyle(CT.lightest)
                        } description: {
                            Text("Camera services are not avaialble.")
                                .italic()
                                .foregroundStyle(CT.Colors.light)
                                .padding(.top,10)
                        }//End ContentUnavail
                    }else if scannedImages.count < 1 {
                        Spacer()
                        
                        ContentUnavailableView {
                            Label("No Items", systemImage: AppImages.doc_Scan)
                                .foregroundStyle(CT.lightest)
                        } description: {
                            Text("Scanned items will appear here as they are scanned.")
                                .italic()
                                .foregroundStyle(CT.Colors.light)
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
                        HStack{
                            saveImage
                            Spacer()
                            resetBtn
                            Spacer()
                            savePDF
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) { scanBtn }
        }
        .onAppear {
            scannedImages = []
        }
    }
    
    // MARK: |-> ScanButton
    @ViewBuilder
    var resetBtn: some View {
        let isDisabled = (scannedImages.count < 1)
        
        Button {
            withAnimation {
                scannedImages = []
                savedImgFilenames = ""
            }
        } label: {
            Label("Reset", systemImage: AppImages.trash)
        }
        .disabled(isDisabled)
        .opacity(isDisabled ?0.5 :1.0)
        .background(
            RoundedRectangle(cornerRadius: 8.0)
                .fill(.white.opacity(0.20))
        )
    }
    
    @ViewBuilder
    var saveImage: some View {
        let isDisabled = (scannedImages.count < 1)
        var tableSuffix: String = ""
        
        Button(action: {
            DispatchQueue.main.async {
                for indx in 0..<scannedImages.count {
                    let image:UIImage = scannedImages[indx]
                    simPrint("image size is \(image.size.width), \(image.size.height)", action: .info, log: logFileFunctionLine())
                    
                    // Save new image
                    switch table {
                        case .inventory: tableSuffix = "inv"
                        case .provenance: tableSuffix = "prov"
                    }
                    let filename = "\( Date.now.formattedAs(fileDateFormat) )-\( tableSuffix ).jpg"
                    let filePathURL = Files().returnPathForFilename(filename, in: .docsDir).url
                    
                    do {
                        try image.jpegData(compressionQuality: 1.0)?.write(to: filePathURL, options: .atomic)
                        if (savedImgFilenames.count > 0) { savedImgFilenames.append(",") }
                        savedImgFilenames.append(filename)
                        simPrint("Scanned file: \(filename) saved.", action: .success,file: filename,log: logFileFunctionLine())
                    } catch(let error) {
                        print("file was not saved at path \(filePathURL), with error : \(error)");
                    }//End Do...Loop
                }
                
                allImgs.append(contentsOf: scannedImages)

                dismiss()
            }
        }, label: {
            HStack(spacing:5) {
                Text("Save")
                    .foregroundStyle(.white)

                Image(systemName: AppImages.person_Rectangle)
                    .resizable()
                    .scaledToFit()
                    .bold()
                    .foregroundStyle(isDisabled ?.gray :CT.Colors.accent)
                    .padding(.bottom,-2)
                
                Text("JPG")
                    .foregroundStyle(.white)
            }
            .font(.headline)
        })
        .tint(.white)
        .disabled(isDisabled)
        .opacity(isDisabled ?0.5 :1.0)
        .background(
            RoundedRectangle(cornerRadius: 8.0)
                .fill(.white.opacity(0.20))
        )
    }
    
    @ViewBuilder
    var savePDF: some View {
        let isDisabled = (scannedImages.count < 1)
        
        Button(action: {
            DispatchQueue.main.async {
                let pdfDocument = PDFDocument()

                for indx in 0..<scannedImages.count {
                    let image:UIImage = scannedImages[indx]
                    simPrint("image size is \(image.size.width), \(image.size.height)", action: .info, log: logFileFunctionLine())
                    let pdfPage = PDFPage(image: image)
                    pdfDocument.insert(pdfPage!, at: indx)
                }
        
                // Get the raw data of your PDF document
                let data = pdfDocument.dataRepresentation()
                
                // Save new PDF
                let filename = "\( Date.now.formattedAs(fileDateFormat) )-prov.pdf"
                let filePathURL = Files().returnPathForFilename(filename, in: .docsDir).url

                // Delete all but first page of .pdf as saved image...
                if scannedImages.count > 1 {
                    let firstImage = scannedImages[0]
                    scannedImages.removeAll()
                    scannedImages = [firstImage]
                }
                
                allImgs.append(scannedImages[0])

                do {
                    try data?.write(to: filePathURL, options: .atomic)
                    simPrint("Scanned file: \(filename) @ \(filePathURL)", action: .success,file: filename,log: logFileFunctionLine(), forceShow: true)
                    if (savedImgFilenames.count > 0) { savedImgFilenames.append(",") }
                    savedImgFilenames.append(filename)
                } catch(let error) {
                    print("file was not saved at path \(filePathURL), with error : \(error)")
                }//End Do...Loop

                dismiss()
            }
        }, label: {
            HStack(spacing:5) {
                Text("Save")
                    .foregroundStyle(.white)

                Image(systemName: AppImages.doc_Text)
                    .resizable()
                    .scaledToFit()
                    .bold()
                    .foregroundStyle(isDisabled ?.gray :CT.Colors.accent)

                Text("PDF")
                    .foregroundStyle(.white)
            }
        })
        .font(.headline)
        .tint(.white)
        .disabled(isDisabled)
        .opacity(isDisabled ?0.5 :1.0)
        .background(
            RoundedRectangle(cornerRadius: 8.0)
                .fill(.white.opacity(0.20))
        )
    }
    
    var scanBtn: some View {
        Button(action: {
            showScan.toggle()
        }, label: {
            HStack(spacing:5) {
                Image(systemName: AppImages.scanner)
                    .resizable()
                    .scaledToFit()
                    .bold()
                    .foregroundStyle(scannerAvailable ?CT.Colors.title :.gray)

                Text("Scan")
                    .foregroundStyle(.white)
            }
            .font(.headline)
        })
        .tint(.white)
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
        allImgs: $AllImgs
    )
        .environment(CurrentTheme().get(.basic))
}
