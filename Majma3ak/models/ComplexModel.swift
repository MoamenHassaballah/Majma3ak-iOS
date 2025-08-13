//
//  ComplexModel.swift
//  Majma3ak
//
//  Created by ezz on 25/06/2025.
//


// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let complexModel = try? JSONDecoder().decode(ComplexModel.self, from: jsonData)

import Foundation



//MARK:  - Getcomplex
struct ComplexResponse : Codable {
    let code : Int
    let message : String
    let data : [ComplexModel]
}

// MARK: - ComplexModel
struct ComplexModel: Codable {
    let id: Int
    let name: String
    let images: [ImageModel]
}


struct ImageModel: Codable {
    let id: Int
    let imageUrl: String
    let residentialComplexId: String
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case imageUrl = "image_url"
        case residentialComplexId = "residential_complex_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

