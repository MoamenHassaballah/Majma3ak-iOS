struct OfferModel: Codable {
    let id: Int
    let title: String
    let description: String
    let imageUrl: String
    let startDate: String
    let endDate: String
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case imageUrl = "image_url"
        case startDate = "start_date"
        case endDate = "end_date"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
