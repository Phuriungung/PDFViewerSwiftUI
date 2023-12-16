//import SwiftUI
//import PDFKit
//
//struct PDFViewController: UIViewRepresentable {
//    var pdfURL: URL
//    @Binding var currentPage: Int
//    @Binding var searchText: String
//    @Binding var selection: [PDFSelection]?
//    @Binding var pdfselect: PDFSelection?
//    @Binding var document: PDFDocument?
// 
//    class Coordinator: NSObject, PDFViewDelegate {
//        var parent: PDFViewController
//        
//        init(parent: PDFViewController) {
//            self.parent = parent
//        }
//        
//        func pdfViewDidLayoutSubviews(_ pdfView: PDFView) {
//            // Additional setup if needed after layout
//        }
//        
//    }
//    func makeCoordinator() -> Coordinator {
//        Coordinator(parent: self)
//    }
//    
//    func makeUIView(context: Context) -> PDFView {
//        let pdfView = PDFView()
////        pdfView.document = PDFDocument(url: pdfURL)
//        pdfView.document = document
//        pdfView.autoScales = true
//        pdfView.backgroundColor = UIColor.secondarySystemBackground
//        pdfView.displayMode = .singlePageContinuous
//        pdfView.displayDirection = .vertical
//        print("scale \(pdfView.scaleFactorForSizeToFit)")
//        print("overall \(pdfView.document?.pageCount)")
//        
//        //        print("string \(pdfView.document?.findString("dorsal"))")
//        
//        //        print("string \(pdfView.document?.beginFindString("capsule"))")
//        //        print("make \(pdfView.document?.findString(searchText))")
//        //        pdfView.go(to: (pdfView.document?.page(at: currentPage))!)
//        pdfView.delegate = context.coordinator
//        //        let page = pdfView.document?.page(at: 10)
//        //        pdfView.go(to: PDFDestination(page: page!, at: CGPoint(x: 0, y: 0)))
//        //        print("select \(pdfView.document?.findString(searchText))")
//        
//        return pdfView
//    }
//    
//    func updateUIView(_ uiView: PDFView, context: Context) {
//        uiView.minScaleFactor = 0.5
//        var nowscale = uiView.scaleFactor
//        
//        uiView.document = PDFDocument(url: pdfURL)
//        func highlightAnnotation() -> PDFAnnotation {
//            let annotation = PDFAnnotation(bounds: CGRect(x: 30, y: 80, width: 230, height: 50),
//                                           forType: .highlight, withProperties: nil)
//            let annotationselect = PDFAnnotation(bounds: pdfselect?.bounds(for: pdfselect?.pages.first ?? PDFPage()) ?? CGRect(x: 100, y: 100, width: 1000, height: 1000), forType: .highlight, withProperties: nil)
//            annotationselect.color = .blue
//            annotation.color = .blue
//            print("Highlighta")
////            return annotationselect
//            return annotation
//        }
//        uiView.setCurrentSelection(pdfselect, animate: true)
//        uiView.currentSelection?.color = UIColor.green
//        var curpage = uiView.currentSelection?.pages.first ?? PDFPage()
//        print("curpage \(curpage)")
//        var curanno = PDFAnnotation(bounds: uiView.currentSelection?.bounds(for: curpage) ?? CGRect(x: 0, y: 0, width: 500, height: 500), forType: .highlight, withProperties: nil)
//        curanno.color = .cyan
//        curpage.addAnnotation(curanno)
//        
//
//        curpage.addAnnotation(highlightAnnotation())
//        
//        // if user select to highlight
//        let select = uiView.currentSelection?.selectionsByLine()
//        print(select)
//        guard let selfirst = select?.first else {return}
//        //assuming for single-page pdf.
//        guard let page = select?.first?.pages.first else { return }
//        
//        
//        select?.forEach({ selection in
//            let highlight = PDFAnnotation(bounds: selfirst.bounds(for: page), forType: .highlight, withProperties: nil)
//            highlight.endLineStyle = .square
//            highlight.color = UIColor.orange.withAlphaComponent(0.5)
//            
//            let anno = PDFAnnotation(bounds: selfirst.bounds(for: page), forType: .highlight, withProperties: nil)
//            anno.color = .red
//            
//            page.addAnnotation(anno)
//        })
//        
//        let selections = uiView.currentSelection?.selectionsByLine()
//        // Simple scenario, assuming your pdf is single-page.
//        guard let page = selections?.first?.pages.first else { return }
//
//        if selections == nil {
//
//        }else {
//
//            selections?.forEach({ selection in
//
//                let highlight = PDFAnnotation(bounds: selection.bounds(for: page), forType: .highlight, withProperties: nil)
//                //            highlight.endLineStyle = .square
//
//                highlight.color = UIColor(red:0.49, green:0.99, blue:0.00, alpha:1.0).withAlphaComponent(0.5)
//                    page.addAnnotation(highlight)
//            })
//        }
//        
//        
//        
//        //        var a: [PDFSelection] = uiView.document?.findString(searchText) ?? []
//        //        storee.selection = a
//        //        uiView.go(to: a.first!)
//        
////                let page = uiView.document?.page(at: currentPage)
////                uiView.go(to: PDFDestination(page: page!, at: CGPoint(x: 0, y: 0)))
//        pdfselect?.draw(for: pdfselect?.pages.first ?? PDFPage(), active: true)
//        pdfselect?.color = UIColor.systemPink
//        
//        uiView.scaleFactor = nowscale
//        if let pdfselect = pdfselect {
//            uiView.go(to: pdfselect)
//        }
//        
////        print("page \(uiView.currentPage)")
//        //        selection = uiView.document?.findString(searchText)
//        
////        print("search \(searchText)")
//        //        print("string \(uiView.document?.findString("dorsal"))")
//    }
//    
//
//    typealias UIViewType = PDFView
//    
//}
