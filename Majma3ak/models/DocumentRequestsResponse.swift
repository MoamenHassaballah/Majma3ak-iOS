import Foundation

struct DocumentRequestsResponse: Codable {
    let code: Int?
    let message: String?
    let data: DocumentRequestsData?
}

struct DocumentRequestsData: Codable {
    let documentRequests: [DocumentRequest]?
    let meta: DocumentRequestsResponseMeta?

    enum CodingKeys: String, CodingKey {
        case documentRequests = "DocumentRequests"
        case meta
    }
}

struct DocumentRequest: Codable {
    let id: Int?
    let title: String?
    let description: String?
    let status: String?
    let rejectionReason: String?
    let apartment: String?
    let documents: [DocumentItem]?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, title, description, status, apartment, documents
        case rejectionReason = "rejection_reason"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct DocumentItem: Codable {
    let id: Int?
    let fileName: String?
    let filePath: String?
    let fileType: String?
    let description: String?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case fileName = "file_name"
        case filePath = "file_path"
        case fileType = "file_type"
        case description
        case createdAt = "created_at"
    }
}

struct DocumentRequestsResponseMeta: Codable {
    let total: Int?
    let count: Int?
    let perPage: Int?
    let currentPage: Int?
    let totalPages: Int?
    let firstPageURL: String?
    let lastPageURL: String?
    let nextPageURL: String?
    let prevPageURL: String?

    enum CodingKeys: String, CodingKey {
        case total, count
        case perPage = "per_page"
        case currentPage = "current_page"
        case totalPages = "total_pages"
        case firstPageURL = "first_page_url"
        case lastPageURL = "last_page_url"
        case nextPageURL = "next_page_url"
        case prevPageURL = "prev_page_url"
    }
}
