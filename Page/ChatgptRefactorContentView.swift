import SwiftUI
import PDFKit

struct ContentView: View {
    // State variables
    @State private var pickurl: URL?
    @State private var filename: String?
    @State private var currentPage: Int = 0
    @State private var textinput: String = ""
    @State private var searchText: String = "blank"
    @State private var selArray: [PDFSelection]?
    @State private var foundnum: Int = 0
    @State private var pagenum: Int = 0
    @State private var compareOptions: [NSString.CompareOptions] = [
        .caseInsensitive, .literal, .numeric,
        .diacriticInsensitive, .widthInsensitive, .forcedOrdering, .anchored, .backwards, .regularExpression
    ]
    @State private var index: Int = 0
    @State private var colors = [0, 1, 2, 3, 4, 5, 6, 7, 8]
    @State private var observeend: NSObjectProtocol?
    @State private var observematch: NSObjectProtocol?
    @State private var observepagechange: NSObjectProtocol?
    @State private var document: PDFDocument?
    @State private var selection: PDFSelection?
    @StateObject private var dele = Dele()
    @State private var deleactive: Bool = false
    @State private var pdfselect: PDFSelection?
    @State private var currentIndex: Int?

    var selectedCompareOption: NSString.CompareOptions {
        compareOptions[index]
    }

    var body: some View {
        VStack {
            // Display navigation controls if there are more than 2 selections
            if dele.pdfSelections.count > 2 {
                let arraypdfsel = dele.pdfSelections
                let pdfcount = arraypdfsel.count

                HStack(spacing: 20) {
                    Button("prev") {
                        handlePrevButtonTap(arraypdfsel: arraypdfsel, pdfcount: pdfcount)
                    }
                    Text("now select \(currentIndex ?? 0) of \(pdfcount) matches searching page \(pagenum) but \(foundnum) matches real")
                    Picker("Search methods", selection: $index) {
                        ForEach(colors, id: \.self) { color in
                            Text("\(color)")
                        }
                    }
                    Button("forw") {
                        handleForwButtonTap(arraypdfsel: arraypdfsel, pdfcount: pdfcount)
                    }
                }
                .padding()

                // Display selection buttons horizontally
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(0..<arraypdfsel.count, id: \.self) { index in
                            Button("\(index)") {
                                selArray = dele.pdfSelections
                                handleSelectionButtonTap(arraypdfsel: arraypdfsel, index: index)
                            }
                        }
                    }
                }
            }

            // File picker
            FilePicker(url: $pickurl, filename: $filename)

            // Display PDF controls if a file is selected
            if let pickurl = pickurl {
                let pdfController = PDFViewController(
                    pdfURL: pickurl,
                    currentPage: $currentPage,
                    searchText: $searchText,
                    selection: $selArray,
                    pdfselect: $pdfselect,
                    document: $document, index: $currentIndex
                )
                pdfController

                // Search controls
                HStack(spacing: 5) {
                    TextField("Search", text: $textinput)
                    Button("Search") {

                        foundnum = 0
                        pagenum = 0
                        searchInPDF()
                        
                    }
                    Button("reset") {
                        document?.cancelFindString()
                    }
                    Button("delegate") {
                        document?.delegate = dele
                    }
                }
            }

            // Slider for current page
            Slider(value: .convert(from: $currentPage), in: 1...500, step: 1)
        }
    }

    // Search function
    private func searchInPDF() {
        dele.pdfSelections.removeAll()
        NotificationCenter.default.removeObserver(observeend, name: NSNotification.Name.PDFDocumentDidEndPageFind, object: nil)
        NotificationCenter.default.removeObserver(observematch, name: NSNotification.Name.PDFDocumentDidFindMatch, object: nil)
        print(selectedCompareOption)

        guard let pickurl = pickurl else {
            return
        }

        do {
            document = PDFDocument(url: pickurl)
            document?.delegate = dele

            guard let searchResults = document?.beginFindString(textinput, withOptions: selectedCompareOption) else {
                throw NSError(domain: "YourErrorDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to find searched text"])
            }

            observeNotifications()
            var matchName: NSNotification.Name?
            matchName = NSNotification.Name.PDFDocumentDidFindMatch
            observematch = NotificationCenter.default.addObserver(forName: matchName, object: nil, queue: nil) { (notification) in
                foundnum += 1
                print("found \(foundnum)")
            }
            
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

    // Observe notifications for search results
    private func observeNotifications() {
        var matchName: NSNotification.Name?
        matchName = NSNotification.Name.PDFDocumentDidFindMatch
        observematch = NotificationCenter.default.addObserver(forName: matchName, object: nil, queue: nil) { (notification) in
            foundnum += 1
        }

        var endName: NSNotification.Name?
        endName = NSNotification.Name.PDFDocumentDidEndPageFind
        observeend = NotificationCenter.default.addObserver(forName: endName, object: nil, queue: nil) { (notification) in
            pagenum += 1
        }
        
        var currentPagechange: NSNotification.Name?
        currentPagechange = NSNotification.Name.PDFViewPageChanged
        observepagechange = NotificationCenter.default.addObserver(forName: currentPagechange, object: nil, queue: nil) { (notification) in
//            pagenum += 1
        }
    }

    // Handlers for navigation buttons
    private func handlePrevButtonTap(arraypdfsel: [PDFSelection], pdfcount: Int) {
        selArray = dele.pdfSelections
        if currentIndex! == 1 {
            pdfselect = arraypdfsel[pdfcount - 1]
            currentIndex = pdfcount - 1
        } else {
            pdfselect = arraypdfsel[currentIndex! - 1]
            currentIndex! -= 1
        }
    }

    private func handleForwButtonTap(arraypdfsel: [PDFSelection], pdfcount: Int) {
        selArray = dele.pdfSelections
        if currentIndex! > pdfcount - 2 {
            pdfselect = arraypdfsel[1]
            currentIndex = 1
        } else {
            pdfselect = arraypdfsel[currentIndex! + 1]
            currentIndex! += 1
        }
    }

    private func handleSelectionButtonTap(arraypdfsel: [PDFSelection], index: Int) {
        pdfselect = arraypdfsel[index]
        currentIndex = index
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
