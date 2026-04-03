/*--------------------------------------------------------------------------------------------------------------------------
    File: PDF_Viewer.swift
  Author: Kevin Messina
 Created: Jun 19, 2022
Modified:

©2022-2026 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:

--------------------------------------------------------------------------------------------------------------------------*/

import SwiftUI
import PDFKit

struct PDFDetailView: UIViewRepresentable {
    let url: URL
    let isRemoteFile: Bool
    let pdfData: Data?
    
    private let pdfView = PDFView()
    
    init(_ url: URL, isRemoteFile: Bool, pdfData: Data?) {
        self.url = url
        self.isRemoteFile = isRemoteFile
        self.pdfData = pdfData
    }
    
    func makeUIView(context: Context) -> PDFView {
        // Configure document
        if isRemoteFile {
            guard url.startAccessingSecurityScopedResource() else {
                return PDFView()
            }
            defer { url.stopAccessingSecurityScopedResource() }
            pdfView.document = PDFDocument(url: url)
        } else if let pdfData {
            pdfView.document = PDFDocument(data: pdfData)
        } else {
            pdfView.document = PDFDocument(url: url)
        }

        // Configure appearance and layout
        pdfView.backgroundColor = .clear
        pdfView.displayDirection = .vertical
        pdfView.displaysPageBreaks = true
        pdfView.autoScales = true

        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        // Nothing to update for now. If needed, reassign the document or adjust settings here.
    }
}

/// Usage:
///
///     let name = UserDefaults.standard.string(forKey: KeyNames.App.selectedPDF) ?? "n/a"
///     let url = Files().getPathForFilename(name, in: .docsDir).url
///     PDFViewer(pdfURL: url, pdfName: name)
///
///     Params:
///         pdfURL: URL of the path + filename
///         pdfName: STRING of the filename to be displayed.
///
struct PDFViewer: View {
    @Environment(\.dismiss) private var dismiss
    let CT = CurrentTheme().getThemeFromUserStds()

    @State var pdfURL: URL
    @State var pdfName:String
    @State var showShareSheet: Bool = false
    @State var isRemoteFile: Bool = false
    @State var pdfData: Data? = nil

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
        if pdfName.count > 15 {
            let dateTxt = pdfName
                .substring(fromTo: 0...8)
                .toConvertedDate(from: .yyyyMMdd, to: .MMM_d_yyyy)
            let timeTxt = pdfName
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
            }
        }else{
            EmptyView()
        }
    }
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            ZStack {
                gradientBackgroundView()
                
                PDFDetailView(pdfURL, isRemoteFile: isRemoteFile, pdfData: pdfData)
                    .ignoresSafeArea(edges: .bottom)

                fileInfo()
                
                LoadingView()
                    .opacity(showProgress ?1 :0)
            }//End ZStack
            .toolbar {
                TB().title("DOCUMENT VIEWER")
                TB().subtitle(pdfName)

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
                ActivityViewController(itemsToShare: [pdfURL])
            })
            .onAppear {
                if isRemoteFile {
                    DispatchQueue.main.async {
                        showProgress = true
                        progress = 0.0
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        showProgress = false
                        progress = 1.0
                    }
                }else{
                    showProgress = false
                    progress = 1.0
                }//end If
            }
        }//End NavigationStack
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Document Viewer")
    }//End Body
}

#Preview {
    @Previewable var filename: String = "20251101@085127_123-inv.pdf"
    
    PDFViewer(
        pdfURL: Files().getPathForFilename(filename, in: .inventoryDir).url,
        pdfName: filename
    )
}
