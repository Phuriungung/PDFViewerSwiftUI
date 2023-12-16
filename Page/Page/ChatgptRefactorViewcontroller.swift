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
//    let pdfDrawer = PDFDrawer()
//    let pdfDrawingGestureRecognizer = DrawingGestureRecognizer()

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
        
        
        // comment temporary
//
//        // from PDFKitDemo
//        
//        pdfView.addGestureRecognizer(pdfDrawingGestureRecognizer)
//        pdfDrawingGestureRecognizer.drawingDelegate = pdfDrawer
//        pdfDrawer.pdfView = pdfView
//        
//        // Create a line for the ink annotation.
//        let path = UIBezierPath()
//        path.move(to: CGPoint(x: 300, y: 300))
//        path.addLine(to: CGPoint(x: 300, y: 400))
//        path.addLine(to: CGPoint(x: 350, y: 500))
//
//        // To change the line width/thickness of an ink annotation, we need to create a border for it
//        // and set the `lineWidth` property there.
//        let border = PDFBorder()
//        border.lineWidth = 5.0
//
//        let inkAnnotation = PDFAnnotation(bounds: CGRect(origin: CGPoint(x: 100, y: 100), size: CGSize(width: 200, height: 300)), forType: .ink, withProperties: nil)
//        inkAnnotation.border = border
//        inkAnnotation.color = .blue
//        inkAnnotation.add(path)
//
//        pdfView.currentPage?.addAnnotation(inkAnnotation)
//
//                            
//        print(pdfView.subviews)
//        for view in pdfView.subviews {
//            var a = type(of: view)
//            print(a)
//            var b =  view as? UIScrollView
//            print("delegate \(b?.delegate)")
//                        b?.bounces = false
//            //            b?.isScrollEnabled = false
//            let shapeLayer = CALayer()
//            shapeLayer.bounds = CGRect(x: 0, y: 0, width: 50, height: 300) // Set the bounds of the layer
//            shapeLayer.position = CGPoint(x: 100, y: 100)
//            shapeLayer.backgroundColor = UIColor.red.cgColor
//            
//            var greenshape = CALayer()
//            greenshape.bounds = CGRect(x: 0, y: 0, width: 300, height: 50)
//            greenshape.backgroundColor = UIColor.green.cgColor
//            greenshape.position = CGPoint(x: 100, y: 100)
//            
//            let mainlay = b?.layer
//            var suplay = b?.layer.superlayer
//            
//            print("suplay \(suplay)")
//            
//            
//            mainlay?.insertSublayer(shapeLayer, above: suplay)
//            mainlay?.insertSublayer(greenshape, above: suplay)
//            var sublay = mainlay?.sublayers
//            print("sublay \(sublay?.count)")
//            print("suplay \(suplay)")
//         
//            
//        }
        
        
//        pdfView.isFindInteractionEnabled = true
//        print(pdfView.findInteraction)
//        
//        var findInteractionNew = UIFindInteraction(sessionDelegate: pdfView)
//        print("\(findInteractionNew.view) view")
//        pdfView.addSubview(findInteractionNew.view ?? UIView())
//        
//        
//        var scrollView = pdfView.subviews.first as? UIScrollView
        
        pdfView.document = document
        pdfView.autoScales = false
        var scale:CGFloat = 10
        pdfView.scaleFactor = scale
        pdfView.maxScaleFactor = scale
        pdfView.minScaleFactor = scale
        pdfView.contentScaleFactor = scale
        
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
        
        //comment temporary, you have to uncomment this
//        
//        // Create a line for the ink annotation.
//        let path = UIBezierPath()
//        path.move(to: CGPoint(x: 0, y: 0))
////        path.addLine(to: CGPoint(x: 300, y: 400))
////        path.addLine(to: CGPoint(x: 350, y: 500))
////        path.addLine(to: CGPoint(x: 500, y: 600))
//        path.addCurve(to: CGPoint(x: 900, y: 100), controlPoint1: CGPoint(x: 200, y: 500), controlPoint2: CGPoint(x: 100, y: 400))
//
//        // To change the line width/thickness of an ink annotation, we need to create a border for it
//        // and set the `lineWidth` property there.
//        let border = PDFBorder()
//        border.lineWidth = 5
//
//        let inkAnnotation = PDFAnnotation(bounds: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 300, height: 300)), forType: .ink, withProperties: nil)
//        inkAnnotation.border = border
//        inkAnnotation.color = .blue
//        inkAnnotation.add(path)
//
//        uiView.document?.page(at: 1)?.addAnnotation(inkAnnotation)
//        
//        uiView.addGestureRecognizer(pdfDrawingGestureRecognizer)
//        pdfDrawingGestureRecognizer.drawingDelegate = pdfDrawer
//        pdfDrawer.pdfView = uiView
//        
//        uiView.autoScales = false
//        uiView.scaleFactor = 1
//        uiView.maxScaleFactor = 100
//        uiView.minScaleFactor = 0.01
//        uiView.contentScaleFactor = 0.01
    }

}

//extension PDFView {
//    public var scrollView: UIScrollView {
//        for eachUIView in self.subviews {
//            var a = eachUIView as? UIScrollView
//        }
//        return nil
//    }
//}
//
//extension PDFView {
//    public var scrollView: UIScrollView? {
//        for view in self.subviews {
//            if let scrollView = view as? UIScrollView {
//                return scrollView
//            }
//        }
//        return nil
//    }
//}


//doesn't work
class PDFDrawView: PDFView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("began \(touches)")
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("move \(String(describing: touches.first?.location(in: self)))")
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("end \(String(describing: touches.first?.location(in: self)))")
    }
}
