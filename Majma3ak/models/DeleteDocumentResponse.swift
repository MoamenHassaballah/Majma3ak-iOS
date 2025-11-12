import Foundation

struct DeleteDocumentResponse: Codable {
    let code: Int
    let message: String
    let data: [String]?
}

