
import Foundation

struct ContactsResponse: Codable {
    let code: Int
    let message: String
    let data: ContactsData
}

struct ContactsData: Codable {
    let contacts: [Contact]
    let meta: Meta
}

struct Contact: Codable {
    let id: Int
    let name: String
    let email: String
    let phone: String
    let type: String
    let content: String
    let status: String
    let user: UserV
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name, email, phone, type, content, status, user
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

//struct User: Codable {
//    let id: Int
//    let name: String
//}

//struct Meta: Codable {
//    let total: Int
//    let count: Int
//    let perPage: Int
//    let currentPage: Int
//    let totalPages: Int
//    let firstPageURL: String
//    let lastPageURL: String
//    let nextPageURL: String?
//    let prevPageURL: String?
//
//    enum CodingKeys: String, CodingKey {
//        case total, count
//        case perPage = "per_page"
//        case currentPage = "current_page"
//        case totalPages = "total_pages"
//        case firstPageURL = "first_page_url"
//        case lastPageURL = "last_page_url"
//        case nextPageURL = "next
