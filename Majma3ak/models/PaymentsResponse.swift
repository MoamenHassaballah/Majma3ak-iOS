//
//  PaymentsResponse.swift
//  Majma3ak
//
//  Created by Moamen Hassaballah on 12/08/2025.
//


import Foundation

struct PaymentsResponse: Codable {
    let code: Int?
    let message: String?
    let data: [PaymentData]?
}

struct PaymentData: Codable {
    let id: Int?
    let user: PaymentUser?
    let complex_admin: ComplexAdmin?
    let total_amount: String?
    let installment_amount: String?
    let installment_period_from: String?
    let installment_period_to: String?
    let description: String?
    let status: String?
    let installments: [Installment]?
    let created_at: String?
    let updated_at: String?
}

struct PaymentUser: Codable {
    let id: Int?
    let name: String?
    let email: String?
    let phone: String?
}

struct ComplexAdmin: Codable {
    let id: Int?
    let name: String?
}

struct Installment: Codable {
    let id: Int?
    let payment_id: String?
    let amount: String?
    let payment_date: String?
    let created_at: String?
    let updated_at: String?
}
