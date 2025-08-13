//
//  Apartments.swift
//  Majma3ak
//
//  Created by ezz on 29/06/2025.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let apartmentsResponse = try? JSONDecoder().decode(ApartmentsResponse.self, from: jsonData)

import Foundation

// MARK: - ApartmentsResponse
struct ApartmentsResponse: Codable {
    let code: Int
    let message: String
    let data: DataClassApartments
}

// MARK: - DataClass
struct DataClassApartments: Codable {
    let apartments: [ApartmentAssociated]
//    let meta: Meta
}

// MARK: - Apartment
struct ApartmentAssociated: Codable {
    let id: Int
    let floorNumber, number: String
    let building: BuildingApartment
    let residencyDate: String?
    let price, listingType, createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case floorNumber = "floor_number"
        case number, building
        case residencyDate = "residency_date"
        case price
        case listingType = "listing_type"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Building
struct BuildingApartment: Codable {
    let id: Int
    let address: String
    let complex: ComplexApartment
}

// MARK: - Complex
struct ComplexApartment: Codable {
    let name: String
}


