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
    @State private var foundSelections: [PDFSelection] = []
    @State private var foundin: Int = 0
    @State private var foundinPage: Int = 0
    @State private var fromTotal: Int = 0
    @State private var percent: Int = 0
    @State private var isFirstTimeTouched = true
    
    var selectedCompareOption: NSString.CompareOptions {
        compareOptions[index]
    }
    
    var body: some View {
        Text("found \(foundin) matches, now searching page \(foundinPage) from total \(fromTotal) (\(percent)%) ")
        VStack {
            // Display navigation controls if there are more than 2 selections
            if dele.pdfSelections.count > 2 {
//                let arraypdfsel = dele.pdfSelections
//                let pdfcount = arraypdfsel.count
                
                HStack(spacing: 20) {
                    Button("prev") {
                        handlePrevButtonTap(arraypdfsel: dele.pdfSelections, pdfcount: dele.pdfSelections.count)
                    }
//                    Text("now select \(currentIndex ?? 0) of \(pdfcount) matches searching page \(pagenum) but \(foundnum) matches real shortcut")
                    Picker("Search methods", selection: $index) {
                        ForEach(colors, id: \.self) { color in
                            Text("\(color)")
                        }
                    }
                    Button("forw") {
                        handleForwButtonTap(arraypdfsel: dele.pdfSelections, pdfcount: dele.pdfSelections.count)
                    }
                }
                .padding()
                
                // Display selection buttons horizontally
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(0..<dele.pdfSelections.count, id: \.self) { index in
                            Button("\(index)") {
                                
                                if isFirstTimeTouched {
                                    selArray = dele.pdfSelections
                                    isFirstTimeTouched = false
                                }
                                handleSelectionButtonTap(arraypdfsel: dele.pdfSelections, index: index)
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
        //comment temporary
        //        dele.pdfSelections.removeAll()
        //        NotificationCenter.default.removeObserver(observeend, name: NSNotification.Name.PDFDocumentDidEndPageFind, object: nil)
        //        NotificationCenter.default.removeObserver(observematch, name: NSNotification.Name.PDFDocumentDidFindMatch, object: nil)
        //        print(selectedCompareOption)
        
        guard let pickurl = pickurl else {
            return
        }
        
        do {
            print(1)
            document = PDFDocument(url: pickurl)
            document?.delegate = dele
            
            //            guard let searchResults = document?.beginFindString(textinput, withOptions: selectedCompareOption) else {
            //                throw NSError(domain: "YourErrorDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to find searched text"])
            //            }
//            var docstring = document?.string
            
            func buildLPSArray(pattern: String) -> [Int] {
                let patternLength = pattern.count
                var lps = Array(repeating: 0, count: patternLength)
                var len = 0
                var i = 1
                
                while i < patternLength {
                    if pattern[pattern.index(pattern.startIndex, offsetBy: i)] == pattern[pattern.index(pattern.startIndex, offsetBy: len)] {
                        len += 1
                        lps[i] = len
                        i += 1
                    } else {
                        if len != 0 {
                            len = lps[len - 1]
                        } else {
                            lps[i] = 0
                            i += 1
                        }
                    }
                }
                
                return lps
            }
            
            func countOccurrences(text: String, pattern: String) -> Int {
                let textLength = text.count
                let patternLength = pattern.count
                var count = 0
                
                // Build the LPS (Longest Proper Prefix which is also Suffix) array
                let lps = buildLPSArray(pattern: pattern)
                
                var i = 0
                var j = 0
                
                while i < textLength {
                    if pattern[pattern.index(pattern.startIndex, offsetBy: j)] == text[text.index(text.startIndex, offsetBy: i)] {
                        i += 1
                        j += 1
                    }
                    
                    if j == patternLength {
                        // Pattern found in the text
                        count += 1
                        j = lps[j - 1]
                    } else if i < textLength && pattern[pattern.index(pattern.startIndex, offsetBy: j)] != text[text.index(text.startIndex, offsetBy: i)] {
                        if j != 0 {
                            j = lps[j - 1]
                        } else {
                            i += 1
                        }
                    }
                }
                
                return count
            }
            
            // Example usage:
            //            let text = "ababcababcabcabcfsjkdlg;aasddgabc"
            //            let pattern = "abc"
            //            let occurrences = countOccurrences(text: text, pattern: pattern)
            //            print("Number of occurrences of '\(pattern)' in '\(text)': \(occurrences)")
            
//            let texttest = docstring ?? ""
            let patterntest = textinput
            print(1.2)
            //            let counts = countOccurrences(text: texttest, pattern: patterntest)
            //            print("Number of occurrences of '\(patterntest)' in '\(texttest)': \(counts)")
            //            print(counts)
            //            var count = texttest.indexesOf(pattern: patterntest)
            //            print(count?.count)
            
            let options: [NSRegularExpression.Options] = [.allowCommentsAndWhitespace, .anchorsMatchLines, .caseInsensitive, .dotMatchesLineSeparators, .ignoreMetacharacters, .useUnicodeWordBoundaries, .useUnixLineSeparators]
            
            //            for op in options {
            let regex = try! NSRegularExpression(pattern: textinput, options: .caseInsensitive)
            
            let numPages = document?.pageCount
            print(2)



            foundin = 0
            foundinPage = 0
            fromTotal = numPages ?? 1
            
            // Assuming you have a function like this where you want to perform asynchronous processing.
            func processPagesAsynchronously(numPages: Int?, document: PDFDocument?, regex: NSRegularExpression) {
                let dispatchGroup = DispatchGroup()

                for i in 0..<(numPages ?? 10) {
                    dispatchGroup.enter()

                    DispatchQueue.global().async {
                        defer {
                            dispatchGroup.leave()
                        }
                        foundinPage = i

                        guard let page = document?.page(at: i), let text = page.string else { return }

                        let results = regex.matches(in: text, range: NSRange(0..<text.utf16.count))
                        print("each \(results.count)")
                        foundin += results.count
                        print(foundinPage)
                        print(fromTotal)
                        percent = (foundinPage * 100 / fromTotal)
                        print(percent)
                        
//                        var tempselection: [PDFSelection] = []
//                        
//                        for result in results {
//                            let startIndex = result.range.location
//                            let endIndex = result.range.location + result.range.length - 1
//                            let selection = document?.selection(from: page, atCharacterIndex: startIndex,
//                                                                to: page, atCharacterIndex: endIndex)!
//                            
//                            tempselection.append(selection ?? PDFSelection())
//                        }
//                        dele.pdfSelections += tempselection
                        
                        DispatchQueue.main.async {
//                            dele.pdfSelections += tempselection
                        }
                    }
                }

                dispatchGroup.notify(queue: .main) {
                    // This block will be executed when all the asynchronous tasks are completed.
                    print("All pages processed. Total found in: \(foundin)")
                }
            }

            // Call the function
            processPagesAsynchronously(numPages: numPages, document: document, regex: regex)

//            for i in 0..<(numPages ?? 10) {
//                guard let page = document?.page(at: i), let text = page.string else {continue}
//                
//                let results = regex.matches(in: text, range: NSRange(0..<text.utf16.count))
//                print("each \(results.count)")
//                foundin += results.count
//            }
            
            
            //temporary comment
//                            for i in 0..<(numPages ?? 10) {
//                                guard let page = document?.page(at: i), let text = page.string else {continue}
//            
//                                let results = regex.matches(in: text, range: NSRange(0..<text.utf16.count))
//                                print("each \(results.count)")
//                                foundin += results.count
//            
//                                //temporary comment
//                                for result in results {
//                                    let startIndex = result.range.location
//                                    let endIndex = result.range.location + result.range.length - 1
//                                    let selection = document?.selection(from: page, atCharacterIndex: startIndex,
//                                                                        to: page, atCharacterIndex: endIndex)!
//            
//                                    foundSelections.append(selection ?? PDFSelection())
//            
//                                    dele.pdfSelections.append(selection ?? PDFSelection())
//                                }
//                            }
//                        }
            
            
            
            
            
            //            var countstring = (docstring?.components(separatedBy: textinput).count ?? 1) - 1
            //            print(countstring)
            
            
            //need to be uncommented
            //            observeNotifications()
            //            var matchName: NSNotification.Name?
            //            matchName = NSNotification.Name.PDFDocumentDidFindMatch
            //            observematch = NotificationCenter.default.addObserver(forName: matchName, object: nil, queue: nil) { (notification) in
            //                foundnum += 1
            //                print("found \(foundnum)")
            //            }
            print(3)
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
        if currentIndex! == 1 {
            pdfselect = arraypdfsel[pdfcount - 1]
            currentIndex = pdfcount - 1
        } else {
            pdfselect = arraypdfsel[currentIndex! - 1]
            currentIndex! -= 1
        }
    }
    
    private func handleForwButtonTap(arraypdfsel: [PDFSelection], pdfcount: Int) {
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

func ZetaAlgorithm(ptrn: String) -> [Int]? {
    
    let pattern = Array(ptrn)
    let patternLength: Int = pattern.count
    
    guard patternLength > 0 else {
        return nil
    }
    
    var zeta: [Int] = [Int](repeating: 0, count: patternLength)
    
    var left: Int = 0
    var right: Int = 0
    var k_1: Int = 0
    var betaLength: Int = 0
    var textIndex: Int = 0
    var patternIndex: Int = 0
    
    for k in 1 ..< patternLength {
        if k > right {  // Outside a Z-box: compare the characters until mismatch
            patternIndex = 0
            
            while k + patternIndex < patternLength  &&
                    pattern[k + patternIndex] == pattern[patternIndex] {
                patternIndex = patternIndex + 1
            }
            
            zeta[k] = patternIndex
            
            if zeta[k] > 0 {
                left = k
                right = k + zeta[k] - 1
            }
        } else {  // Inside a Z-box
            k_1 = k - left + 1
            betaLength = right - k + 1
            
            if zeta[k_1 - 1] < betaLength { // Entirely inside a Z-box: we can use the values computed before
                zeta[k] = zeta[k_1 - 1]
            } else if zeta[k_1 - 1] >= betaLength { // Not entirely inside a Z-box: we must proceed with comparisons too
                textIndex = betaLength
                patternIndex = right + 1
                
                while patternIndex < patternLength && pattern[textIndex] == pattern[patternIndex] {
                    textIndex = textIndex + 1
                    patternIndex = patternIndex + 1
                }
                
                zeta[k] = patternIndex - k
                left = k
                right = patternIndex - 1
            }
        }
    }
    return zeta
}

extension String {
    
    func indexesOf(pattern: String) -> [Int]? {
        let patternLength: Int = pattern.count
        /* Let's calculate the Z-Algorithm on the concatenation of pattern and text */
        let zeta = ZetaAlgorithm(ptrn: pattern + "💲" + self)
        
        guard zeta != nil else {
            return nil
        }
        
        var indexes: [Int] = [Int]()
        
        /* Scan the zeta array to find matched patterns */
        for i in 0 ..< zeta!.count {
            if zeta![i] == patternLength {
                indexes.append(i - patternLength - 1)
            }
        }
        
        guard !indexes.isEmpty else {
            return nil
        }
        
        return indexes
    }
}
