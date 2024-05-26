import Foundation


final class MimeTypeHelper {
    static func mimeType(for pathExtension: String) -> String {
        switch pathExtension.lowercased() {
        case "jpeg", "jpg":
            return "image/jpeg"
        case "png":
            return "image/png"
        case "gif":
            return "image/gif"
        case "bmp":
            return "image/bmp"
        case "tiff":
            return "image/tiff"
        default:
            return "application/octet-stream" // Общее значение по умолчанию
        }
    }
}
