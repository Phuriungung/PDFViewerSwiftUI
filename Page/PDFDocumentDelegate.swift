import SwiftUI
import PDFKit

class Dele: NSObject, PDFDocumentDelegate, ObservableObject {
    @Published var pdfSelections: [PDFSelection] = []
    
    func didMatchString(_ instance: PDFSelection) {
        pdfSelections.append(instance)
//        print(instance)
    }
}
