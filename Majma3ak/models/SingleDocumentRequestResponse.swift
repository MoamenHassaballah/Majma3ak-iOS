import Foundation

struct SingleDocumentRequestResponse: Codable {
    let code: Int?
    let message: String?
    let data: DocumentRequest?
}
