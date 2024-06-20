import Foundation

public struct MultipartRequest {
    
    public let boundary: String
    
    private let separator: String = "\r\n"
    private var data: Data

    public init(boundary: String = UUID().uuidString) {
        self.boundary = boundary
        self.data = Data()
    }
    
    private mutating func appendBoundarySeparator() {
        data.append("--\(boundary)\(separator)".data(using: .utf8)!)
    }
    
    private mutating func appendSeparator() {
        data.append(separator.data(using: .utf8)!)
    }

    private func disposition(_ key: String) -> String {
        "Content-Disposition: form-data; name=\"\(key)\""
    }

    public mutating func add(
        key: String,
        value: String
    ) {
        appendBoundarySeparator()
        data.append((disposition(key) + separator).data(using: .utf8)!)
        appendSeparator()
        data.append((value + separator).data(using: .utf8)!)
    }

    public mutating func add(
        key: String,
        fileName: String,
        fileMimeType: String,
        fileData: Data
    ) {
        appendBoundarySeparator()
        data.append((disposition(key) + "; filename=\"\(fileName)\"" + separator).data(using: .utf8)!)
        data.append(("Content-Type: \(fileMimeType)" + separator + separator).data(using: .utf8)!)
        data.append(fileData)
        appendSeparator()
    }

    public var httpContentTypeHeadeValue: String {
        "multipart/form-data; boundary=\(boundary)"
    }

    public var httpBody: Data {
        var bodyData = data
        bodyData.append("--\(boundary)--".data(using: .utf8)!)
        return bodyData
    }
}
