import Foundation

struct DocumentResponse: Codable {
    let code: Int
    let message: String
    let data: [UserDocument]
}

struct UserDocument: Codable {
    let id: Int
    let user_id: String
    let apartment_id: String
    let file_name: String?
    let file_path: String
    let file_url: String
    let file_type: String
    let document_type: String?
    let description: String
    let apartment: ApartmentData?
    let created_at: String
    let updated_at: String

    enum CodingKeys: String, CodingKey {
        case id
        case user_id = "user_id"
        case apartment_id = "apartment_id"
        case file_name
        case file_path = "file_path"
        case file_url = "file_url"
        case file_type = "file_type"
        case document_type
        case description
        case apartment
        case created_at = "created_at"
        case updated_at = "updated_at"
    }
}

struct ApartmentData: Codable {
    let id: Int
    let number: String
    let floor_number: String

    enum CodingKeys: String, CodingKey {
        case id
        case number
        case floor_number = "floor_number"
    }
}
