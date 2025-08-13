//
//  VerifiedOtpResponse.swift
//  Majma3ak
//
//  Created by ezz on 18/07/2025.
//

import Foundation

// MARK: - VerifiedOtpResponse
struct VerifiedOtpResponse: Codable {
    let code: Int
    let message: String
    let data: DataClassVerfied
}

// MARK: - DataClass
struct DataClassVerfied: Codable {
    let user: User
    let token: String
}

// MARK: - User
//struct User: Codable {
//    let id: Int
//    let name, email, phone, locale: String
//}
