import SwiftUI
import PDFKit


class Dele: NSObject, PDFDocumentDelegate, ObservableObject {
    @Published var pdfSelections: [PDFSelection] = []
    @Published var count: Int = 0
    
    func didMatchString(_ instance: PDFSelection) {
        pdfSelections.append(instance)
//        print(instance)
    }
}
