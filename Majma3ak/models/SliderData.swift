//
//  SliderData.swift
//  Majma3ak
//
//  Created by ezz on 25/06/2025.
//

struct SliderData: Codable {
    let complexes: [ComplexModel]
    let offers: [OfferModel]
}

struct SliderResponse: Codable {
    let code: Int
    let message: String
    let data: SliderData
}
