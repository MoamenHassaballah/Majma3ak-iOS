//
//  NotifcationsResponse.swift
//  Majma3akMaintanceApp
//
//  Created by ezz on 09/07/2025.
//


// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let notifcationsResponse = try? JSONDecoder().decode(NotifcationsResponse.self, from: jsonData)

import Foundation

// MARK: - NotifcationsResponse
struct NotifcationsResponse: Codable {
    let code: Int
    let message: String
    let data: DataClassNotifcations
}

// MARK: - DataClass
struct DataClassNotifcations : Codable {
    let notifications: [NotificationModel]
    let total, count, perPage, currentPage: Int
    let totalPages: Int
    let firstPageURL, lastPageURL: String
//    let nextPageURL, prevPageURL: JSONNull?

    enum CodingKeys: String, CodingKey {
        case notifications, total, count
        case perPage = "per_page"
        case currentPage = "current_page"
        case totalPages = "total_pages"
        case firstPageURL = "first_page_url"
        case lastPageURL = "last_page_url"
//        case nextPageURL = "next_page_url"
//        case prevPageURL = "prev_page_url"
    }
}

// MARK: - Notification
struct NotificationModel: Codable {
    let id: Int
    let title, content, channel, status: String
    let sentAt, createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, title, content, channel, status
        case sentAt = "sent_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
