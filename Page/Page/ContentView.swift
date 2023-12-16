//import SwiftUI
//import PDFKit
//
//struct ContentView: View {
//    @State private var pickurl: URL?
//    @State private var filename: String?
//    
//    @State private var currentPage: Int = 0
//    @State var textinput: String = ""
//    @State var searchText: String = "blank"
//    @State var selArray: [PDFSelection]?
//    @State var foundnum: Int = 0
//    @State var pagenum: Int = 0
//    @State var compareOptions: [NSString.CompareOptions] = [
//        .caseInsensitive,
//        .literal,
//        .numeric,
//        .diacriticInsensitive,
//        .widthInsensitive,
//        .forcedOrdering
//    ]
//    var selectedCompareOption: NSString.CompareOptions {
//        compareOptions[index]
//    }
//    @State private var index: Int = 0
//    var colors = [0, 1, 2, 3, 4, 5]
//    @State var observeend: NSObjectProtocol?
//    @State var observematch: NSObjectProtocol?
//    @State var document: PDFDocument?
//    @State var selection: PDFSelection?
//    
//    @StateObject var dele = Dele()
//    
//    @State var deleactive: Bool = false
//    @State var pdfselect: PDFSelection?
//    @State var currentIndex: Int?
//    
//    var body: some View {
//        VStack {
//            if dele.pdfSelections.count > 2 {
//                var arraypdfsel = dele.pdfSelections
//                var pdfcount = arraypdfsel.count
//                HStack(spacing: 20) {
//                    Button("prev") {
//                        if currentIndex! == 1 {
//                            pdfselect = arraypdfsel[pdfcount-1]
//                            currentIndex = pdfcount-1
//                        } else {
//                            pdfselect = arraypdfsel[currentIndex!-1]
//                            currentIndex! -= 1
//                        }
//                    }
//                    Text("now select\(currentIndex ?? 0) of \(pdfcount) matches searching page \(pagenum)")
//                    Button("forw") {
//                        if currentIndex! > pdfcount-2 {
//                            pdfselect = arraypdfsel[1]
//                            currentIndex = 1
//                        } else {
//                            pdfselect = arraypdfsel[currentIndex!+1]
//                            currentIndex! += 1
//                        }
//                    }
//                }
//                .padding()
//                ScrollView(.horizontal) {
//                    HStack {
//                        ForEach(0..<arraypdfsel.count, id: \.self) { index in
//                            Button("\(index)") {
//                                pdfselect = arraypdfsel[index]
//                                currentIndex = index
//                                pdfselect?.draw(for: pdfselect?.pages.first ?? PDFPage(), active: true)
//                                pdfselect?.color = UIColor.brown
//                            }
//                        }
//                    }
//                }
//            }
//            FilePicker(url: $pickurl, filename: $filename)
//            if let pickurl = pickurl {
//                var control = PDFViewController(pdfURL: pickurl, currentPage: $currentPage, searchText: $searchText, selection: $selArray, pdfselect: $pdfselect, document: $document)
//                control
//                HStack(spacing: 5) {
//                    TextField("Search", text: $textinput)
//                    Button("Search") {
//                        foundnum = 0
//                        pagenum = 0
//                        searchInPDF()
//                    }
//                    Button("reset") {
//                        document?.cancelFindString()
//                    }
//                    Button("delegate") {
//                        document?.delegate = dele
//                    }
//                }
//            }
//            
//            Slider(value: .convert(from: $currentPage), in: 1...500, step: 1)
//        }
//    }
//    @State private var searchResults: [PDFSelection] = []
//    func searchInPDF() {
//        NotificationCenter.default.removeObserver(observeend, name: NSNotification.Name.PDFDocumentDidEndPageFind, object: nil)
//        NotificationCenter.default.removeObserver(observematch, name: NSNotification.Name.PDFDocumentDidFindMatch, object: nil)
//        print(selectedCompareOption)
//        
//        guard let pickurl = pickurl else {
//            return
//        }
//        do {
//            document = PDFDocument(url: pickurl)
//            document?.delegate = dele
//            guard let searchResults = document?.beginFindString(textinput, withOptions: selectedCompareOption) else {
//                throw NSError(domain: "YourErrorDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to find searched text"])
//            }
//            
//            var matchName: NSNotification.Name?
//            matchName = NSNotification.Name.PDFDocumentDidFindMatch
//            observematch = NotificationCenter.default.addObserver(forName: matchName, object: nil, queue: nil) { (notification) in
//                foundnum += 1
//                print(foundnum)
//                
//            }
//            var endName: NSNotification.Name?
//            endName = NSNotification.Name.PDFDocumentDidEndPageFind
//            observeend = NotificationCenter.default.addObserver(forName: endName, object: nil, queue: nil) { (notification) in
//                pagenum += 1
//            }
//            
//        } catch {
//            print("Error: \(error.localizedDescription)")
//        }
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
