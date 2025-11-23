// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let maintenanceRequestsResponse = try? JSONDecoder().decode(MaintenanceRequestsResponse.self, from: jsonData)

import Foundation

// MARK: - MaintenanceRequestsResponse
struct MaintenanceRequestsResponse: Codable {
    let code: Int
    let message: String?
    let data: DataClass?
}

// MARK: - DataClass
struct DataClass: Codable {
    let maintenanceRequests: [MaintenanceRequest]?
    let meta: Meta?

    enum CodingKeys: String, CodingKey {
        case maintenanceRequests = "maintenance_requests"
        case meta
    }
}

// MARK: - MaintenanceRequest
struct MaintenanceRequest: Codable {
    let id: Int?
    let title, description, status, apartmentID: String?
    let complex: Complex?
    let images: Images?
    let maintenanceDepartment: Maintenance?
//    let user, assignedAt , maintenanceCompany: JSONNull?
  let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, title, description, status
        case apartmentID = "apartment_id"
        case complex
        case images
        case maintenanceDepartment = "maintenance_department"
//        case maintenanceCompany = "maintenance_company"
//        case user
//    case assignedAt = "assigned_at"
       case createdAt = "created_at"
      case updatedAt = "updated_at"
    }
}


// MARK: - Images
struct Images: Codable {
    let user: [ImageItem]?
    let admin: [ImageItem]?
}

// MARK: - ImageItem
struct ImageItem: Codable {
    let id: Int?
    let imageURL: String?
    let uploadedAt: String?
    let description: String?

    enum CodingKeys: String, CodingKey {
        case id
        case imageURL = "image_url"
        case uploadedAt = "uploaded_at"
        case description
    }
}

// MARK: - Complex
struct Complex: Codable {
    let id: Int?
    let name: String?
    let building: Building?
}

// MARK: - Building
struct Building: Codable {
    let id: Int?
    let address, description: String?
    let apartment: Apartment?
}

// MARK: - Apartment
struct Apartment: Codable {
    let id: Int?
    let number, floorNumber: String?

    enum CodingKeys: String, CodingKey {
        case id, number
        case floorNumber = "floor_number"
    }
}

// MARK: - Maintenance
struct Maintenance: Codable {
    let id: Int?
    let name: String?
}

// MARK: - Meta
struct Meta: Codable {
    let total, count, perPage, currentPage: Int?
    let totalPages: Int?
   // let firstPageURL, lastPageURL: String
 //   let nextPageURL, prevPageURL: JSONNull?

    enum CodingKeys: String, CodingKey {
        case total, count
        case perPage = "per_page"
        case currentPage = "current_page"
        case totalPages = "total_pages"
//        case firstPageURL = "first_page_url"
//        case lastPageURL = "last_page_url"
//        case nextPageURL = "next_page_url"
//        case prevPageURL = "prev_page_url"
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
    }

    public var hashValue: Int {
            return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                    throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
    }

    public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
    }
}
