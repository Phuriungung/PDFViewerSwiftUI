import SwiftUI

struct FilePicker: View {
    @State private var openFile = false
    @Binding var url: URL?
    @Binding var filename: String?
    
    var body: some View {
        Button("Open File Picker") {
            self.openFile.toggle()
        }
        .fileImporter(isPresented: $openFile, allowedContentTypes: [.pdf], allowsMultipleSelection: false) { result in
            do {
                guard let fileURL = try result.get().first else {
                    return
                }
                
                // Convert shared app group URL to sandboxed URL
                if fileURL.startAccessingSecurityScopedResource() {
                    let sandboxedURL = FileManager.default.temporaryDirectory
                        .appendingPathComponent(UUID().uuidString)
                        .appendingPathExtension("pdf")
                    
                    do {
                        try FileManager.default.copyItem(at: fileURL, to: sandboxedURL)
                        self.url = sandboxedURL
                        self.filename = FileManager().displayName(atPath: fileURL.path().removingPercentEncoding!)
                        print(self.filename ?? "none")
                    } catch {
                        print("Error copying file to sandboxed directory: \(error.localizedDescription)")
                    }
                    
                    fileURL.stopAccessingSecurityScopedResource()
                }
            } catch {
                print("Error reading file: \(error.localizedDescription)")
            }
        }
    }
}
