//
//  user_model.swift
//  Majma3ak
//
//  Created by ezz on 21/06/2025.
//

struct User : Codable {
    let id : Int
    let name : String
    let email : String
    let phone : String
    let locale : String
}

struct LoginData : Codable {
    let token : String
    let user : User
}

struct LoginResponse : Codable {
    let code : Int
    let message : String
    let data : LoginData
}
