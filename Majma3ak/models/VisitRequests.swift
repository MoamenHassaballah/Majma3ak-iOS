//
//  VisitRequests.swift
//  Majma3ak
//
//  Created by ezz on 02/07/2025.
//


//
//  visitRequests.swift
//  Majma3ak
//
//  Created by ezz on 02/07/2025.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let visitRequests = try? JSONDecoder().decode(VisitRequests.self, from: jsonData)

import Foundation

// MARK: - VisitRequests
struct VisitRequestsResponse: Codable {
    let code: Int
    let message: String
    let data: VisitRequestsData
}

// MARK: - DataClass
struct VisitRequestsData: Codable {
    let visitRequests: [VisitRequest]
    let meta: Meta

    enum CodingKeys: String, CodingKey {
        case visitRequests = "visit_requests"
        case meta
    }
}


struct AddVisitRequestResponse : Codable {
    let code : Int
    let message : String
    let data : VisitRequest
}


// MARK: - VisitRequest
struct VisitRequest: Codable {
    let id: Int
    let visiterName, visiterPhone, visitTime, visitDate: String
    let status: String
    let user: UserV
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case visiterName = "visiter_name"
        case visiterPhone = "visiter_phone"
        case visitTime = "visit_time"
        case visitDate = "visit_date"
        case status, user
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct UserV : Codable {
    let id : Int
    let name : String
}
