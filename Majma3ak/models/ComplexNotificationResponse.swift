//
//  ComplexNotificationResponse.swift
//  Majma3ak
//
//  Created by Moamen Hassaballah on 09/10/2025.
//

import Foundation

// MARK: - ComplexNotificationResponse
struct ComplexNotificationResponse: Codable {
    let code: Int
    let message: String
    let data: DataClassComplexNotifications
}

// MARK: - DataClassComplexNotifications
struct DataClassComplexNotifications: Codable {
    let data: [ComplexNotificationModel]
    let meta: MetaData
}

// MARK: - MetaData
struct MetaData: Codable {
    let total, count, perPage, currentPage: Int
    let totalPages: Int
    let firstPageURL, lastPageURL: String
    let nextPageURL, prevPageURL: String?

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

// MARK: - ComplexNotificationModel
struct ComplexNotificationModel: Codable {
    let id: Int
    let title, content: String
    let complexAdminID: String
    let userID: String?
    let residentialComplexID: String
    let channel: String
    let locale: String?
    let status: String
    let sentAt, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, title, content
        case complexAdminID = "complex_admin_id"
        case userID = "user_id"
        case residentialComplexID = "residential_complex_id"
        case channel, locale, status
        case sentAt = "sent_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
}
