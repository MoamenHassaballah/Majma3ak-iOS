//
//  ProfileResponse.swift
//  Majma3ak
//
//  Created by ezz on 02/07/2025.
//

import Foundation

// MARK: - ProfileResponse
struct ProfileResponse: Codable {
    let code: Int
    let message: String
    let data: DataClassProfileUSer
}

// MARK: - DataClass
struct DataClassProfileUSer: Codable {
    let id: Int
    let name, email, phone, phoneVerifiedAt: String?
    let profilePciture: String?
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name, email, phone
        case phoneVerifiedAt = "phone_verified_at"
        case profilePciture = "profile_picture"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
