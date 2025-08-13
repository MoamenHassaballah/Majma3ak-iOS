//
//  APIResponse.swift
//  Majma3akMaintanceApp
//
//  Created by ezz on 10/07/2025.
//


struct APIResponse<T: Decodable>: Decodable {
    let code: Int
    let message: String
    let data: T
}
struct Empty: Decodable {}
