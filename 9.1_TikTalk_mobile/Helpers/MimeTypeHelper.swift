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
        case "mp3":
            return "audio/mpeg"
        case "wav":
            return "audio/wav"
        case "aac":
            return "audio/aac"
        case "ogg":
            return "audio/ogg"
        case "flac":
            return "audio/flac"
        case "m4a":
            return "audio/mp4"
        default:
            return "application/octet-stream" // Общее значение по умолчанию
        }
    }
}
