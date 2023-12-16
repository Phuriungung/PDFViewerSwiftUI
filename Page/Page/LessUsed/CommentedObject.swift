//import SwiftUI
//
//struct CommentedObject: View {
//    var body: some View {
//        
//        Text("Number of PDF Selections: \(dele.pdfSelections.count)")
//            .onAppear {
//                // Simulate calling didMatchString
//                let samplePDFSelection = PDFSelection()
//                dele.didMatchString(samplePDFSelection)
//            }
//        Button("dele") {
//            print("count \(dele.pdfSelections.count)")
//            deleactive.toggle()
//        }
//        ScrollView(.horizontal) {
//            if dele.pdfSelections.count > 10 {
//                var i = dele.pdfSelections.count
//                for i in 1...i-5 {
//                    Text("\(dele.pdfSelections[i]) hi")
//                }
//                HStack {
//                    ForEach(1..<i, id: \.self) { index in
//                        Text("\(dele.pdfSelections[index].description) hi")
//                        Button("\(dele.pdfSelections[index].description) hi") {
//                            pdfselect = dele.pdfSelections[index]
//                        }
//                    }
//                }
//                
//                Text("\(dele.pdfSelections[dele.pdfSelections.count-3]) hi")
//                Text("\(dele.pdfSelections[dele.pdfSelections.count-4]) hi")
//                Text("\(dele.pdfSelections[dele.pdfSelections.count-5]) hi")
//                Text("Hi")
//            }
//        }
//        
//        Picker("Search methods", selection: $index) {
//            ForEach(colors, id: \.self) { color in
//                Text("\(color)")
//            }
//        }
//        
//        TextField("found", value: $foundnum, formatter: NumberFormatter()).frame(alignment: .center)
//        TextField("found", value: $pagenum, formatter: NumberFormatter()).frame(alignment: .center)
//        Button("now page") {
//            control
//        }
//        Button("Go to Page \(currentPage)") {
//            // Update the currentPage variable to the desired page
//            currentPage = 17
//            updateTrigger.toggle()
//        }
//        .padding()
//        
//    }
//    func searchInPDF() {
//        guard let pickurl = pickurl else {
//            return
//        }
//        let pdfDocument = PDFDocument(url: pickurl)
//        guard let searchResults = pdfDocument?.findString(textinput) else {
//            throws errorprint("unable to find searched text")
//        }
//        print(searchResults)
//        
//        var Name: NSNotification.Name?
//        Name = NSNotification.Name.PDFDocumentDidBeginPageFind
//        let observer = NotificationCenter.default.addObserver(forName: Name, object: nil, queue: nil) { (notification) in
//            
//        }
//    }
//}
