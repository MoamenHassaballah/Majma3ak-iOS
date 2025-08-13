//
//  RegisterResponse.swift
//  Majma3ak
//
//  Created by ezz on 26/06/2025.
//


struct RegisterResponse: Codable {
    let code: Int
    let message: String
    let data: RegisterData
}

struct RegisterData: Codable {
    let user: User
}

