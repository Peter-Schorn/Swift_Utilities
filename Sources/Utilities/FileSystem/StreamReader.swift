import Foundation


/// Lazily reads text files. 
public class StreamReader: Sequence, IteratorProtocol  {

    let encoding : String.Encoding
    let chunkSize : Int
    var fileHandle : FileHandle!
    let delimData : Data
    var buffer : Data
    var atEOF : Bool

    public init?(
        url: URL,
        delimiter: String = "\n",
        encoding: String.Encoding = .utf8,
        chunkSize: Int = 4096
    ) {

        // guard let fileHandle = FileHandle(forReadingAtPath: path),
        guard let fileHandle = try? FileHandle(forReadingFrom: url),
                let delimData = delimiter.data(using: encoding)
        else {
            return nil
        }
        
        self.encoding = encoding
        self.chunkSize = chunkSize
        self.fileHandle = fileHandle
        self.delimData = delimData
        self.buffer = Data(capacity: chunkSize)
        self.atEOF = false
    }

    deinit {
        self.close()
    }

    /// Return next line, or nil on end of file.
    public func next() -> String? {
        
        precondition(fileHandle != nil, "Attempt to read from closed file")

        // Read data chunks from file until a line delimiter is found:
        while !atEOF {
            
            if let range = buffer.range(of: delimData) {
                print("range = buffer.range(of: delimData)")
                // Convert complete line (excluding the delimiter) to a string:
                let line = String(data: buffer.subdata(in: 0..<range.lowerBound), encoding: encoding)
                // Remove line (and the delimiter) from the buffer:
                buffer.removeSubrange(0..<range.upperBound)
                return line
            }
            
            print("else")
            
            let tmpData = fileHandle.readData(ofLength: chunkSize)
            
            if tmpData.count > 0 {
                buffer.append(tmpData)
            } else {
                // EOF or read error.
                atEOF = true
                if buffer.count > 0 {
                    // Buffer contains last line in file (not terminated by delimiter).
                    let line = String(data: buffer as Data, encoding: encoding)
                    buffer.count = 0
                    return line
                }
            }
        }
        return nil
    }

    /// Start reading from the beginning of file.
    public func rewind() -> Void {
        fileHandle.seek(toFileOffset: 0)
        buffer.count = 0
        atEOF = false
    }

    /// Close the underlying file. No reading must be done after calling this method.
    public func close() -> Void {
        fileHandle?.closeFile()
        fileHandle = nil
    }
}
