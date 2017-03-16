import Foundation

extension String {
    func writeLine(to url: URL) throws {
        try self.appending("\n").writeString(url: url)
    }
    
    func writeString(url: URL) throws {
        let data = self.data(using: .utf8)!
        try data.append(to: url)
    }
}

extension Data {
    
    func append(to url: URL) throws {
        if let fileHandle = try? FileHandle(forWritingTo: url) {
            defer {
                fileHandle.closeFile()
            }
            
            fileHandle.seekToEndOfFile()
            fileHandle.write(self)
        }
        else {
            try write(to: url, options: .atomic)
        }
    }
}
