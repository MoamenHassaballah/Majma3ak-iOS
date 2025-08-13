//
//  MaintenanceDepartmentsResponse.swift
//  Majma3ak
//
//  Created by ezz on 29/06/2025.
//

struct MaintenanceDepartmentsResponse : Codable {
    let code : Int
    let message : String
    let data : [MaintenanceDepartmentsModel]
}

struct MaintenanceDepartmentsModel : Codable {
    let id : Int
    let name : String
    let description : String
    let icon : String
    let createdAt : String
    let updatedAt : String
    
    enum CodingKeys : String ,  CodingKey {
        case id
        case name
        case description
        case icon
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
