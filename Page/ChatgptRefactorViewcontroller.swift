import SwiftUI
import PDFKit

struct PDFViewController: UIViewRepresentable {
    var pdfURL: URL
    @Binding var currentPage: Int
    @Binding var searchText: String
    @Binding var selection: [PDFSelection]?
    @Binding var pdfselect: PDFSelection?
    @Binding var document: PDFDocument?
    @Binding var index: Int?

    class Coordinator: NSObject, PDFViewDelegate {
        var parent: PDFViewController

        init(parent: PDFViewController) {
            self.parent = parent
        }

        func pdfViewDidLayoutSubviews(_ pdfView: PDFView) {
            // Additional setup if needed after layout
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = document
        pdfView.autoScales = true
        pdfView.backgroundColor = UIColor.secondarySystemBackground
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        pdfView.delegate = context.coordinator
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        let scaleFactorBeforeUpdate = uiView.scaleFactor
        // Update PDF document
        uiView.document = PDFDocument(url: pdfURL)
        
        uiView.minScaleFactor = 0.1
  
        
        print("\(scaleFactorBeforeUpdate) before")
        
//        // Function to create a highlight annotation
//        func highlightAnnotation() -> PDFAnnotation {
//            let bounds = CGRect(x: 30, y: 80, width: 230, height: 50)
//            let annotation = PDFAnnotation(bounds: bounds, forType: .highlight, withProperties: nil)
//            annotation.color = .blue
//            return annotation
//        }
        
        // Set current selection and customize its appearance
        uiView.setCurrentSelection(pdfselect, animate: true)
//        uiView.currentSelection?.color = UIColor.green
        
        
//        // Get the current page and create a highlight annotation for the selection
//        guard let curPage = uiView.currentSelection?.pages.first else { return }
//        let curAnnotationBounds = uiView.currentSelection?.bounds(for: curPage) ?? CGRect(x: 0, y: 0, width: 500, height: 500)
//        let curHighlightAnnotation = PDFAnnotation(bounds: curAnnotationBounds, forType: .highlight, withProperties: nil)
//        curHighlightAnnotation.color = .cyan
//        curPage.addAnnotation(curHighlightAnnotation)
//        
//        // Add a general highlight annotation
//        curPage.addAnnotation(highlightAnnotation())
//        
//        // Check and handle user selections for highlighting
//        if let selections = uiView.currentSelection?.selectionsByLine() {
//            for selection in selections {
//                let bounds = selection.bounds(for: curPage)
//                
//                // Create and customize the highlight annotation
//                let highlight = PDFAnnotation(bounds: bounds, forType: .highlight, withProperties: nil)
//                highlight.color = UIColor.orange.withAlphaComponent(0.5)
//                highlight.endLineStyle = .square
//                
//                // Create and customize another annotation for the same bounds
//                let annotation = PDFAnnotation(bounds: bounds, forType: .highlight, withProperties: nil)
//                annotation.color = .red
//                
//                // Add both annotations to the page
//                curPage.addAnnotation(highlight)
//                curPage.addAnnotation(annotation)
//            }
//        }
//        
//        // Customize selections appearance
//        if let selections = uiView.currentSelection?.selectionsByLine(), let page = selections.first?.pages.first {
//            for selection in selections {
//                let bounds = selection.bounds(for: page)
//                
//                // Create and customize the highlight annotation
//                let highlight = PDFAnnotation(bounds: bounds, forType: .highlight, withProperties: nil)
//                highlight.color = UIColor(red: 0.49, green: 0.99, blue: 0.00, alpha: 1.0).withAlphaComponent(0.5)
//                
//                // Add the annotation to the page
//                page.addAnnotation(highlight)
//            }
//        }
//        
//        // Additional functionality (commented out for now)
//    //    let a: [PDFSelection] = uiView.document?.findString(searchText) ?? []
//    //    storee.selection = a
//    //    uiView.go(to: a.first!)
        
        // Draw the PDF selection and set its color
//        pdfselect?.draw(for: pdfselect?.pages.first ?? PDFPage(), active: true)
//        pdfselect?.color = UIColor.systemPink
        
        // Restore the original scale factor and navigate to the PDF selection
//        if let pdfselect = pdfselect {
//            uiView.go(to: pdfselect)
//            print("go to \(pdfselect.pages)")
//        }
        
        if let pdfselect = pdfselect {
//            uiView.go(to: uiView.currentSelection ?? (pdfselect ?? PDFSelection()))
            var a = selection?[index!] ?? PDFSelection()
//            uiView.go(to: a)
//            var rect = selection?[index!].bounds(for: selection?[index!].pages.first ?? PDFPage()) ?? CGRect(x: 100, y: 100, width: 100, height: 100)
            var page = selection?[index!].pages.first ?? PDFPage()
            
            var getIndex = document?.index(for: page) ?? 0
            
            guard var reallypage = uiView.document?.page(at: getIndex)  else { return }
            var rect = a.bounds(for: reallypage)
            
//            uiView.go(to: page)
            uiView.go(to: reallypage)
//            uiView.go(to: rect, on: reallypage)
            
            
            
            var currentbound = uiView.currentSelection?.bounds(for: uiView.currentSelection?.pages.first! ?? PDFPage())
            currentbound?.origin.y += 300
            currentbound?.origin.x -= 200
            uiView.go(to: currentbound!, on: uiView.currentSelection?.pages.first! ?? PDFPage())
//            uiView.go(to: rect, on: page)
            
//            uiView.go(to: uiView.currentSelection ?? (pdfselect ?? PDFSelection()))
            uiView.scaleFactor = scaleFactorBeforeUpdate
//            print("\(scaleFactorBeforeUpdate) after")
            
        } else {
            print("error go")
        }
        
    }

}
