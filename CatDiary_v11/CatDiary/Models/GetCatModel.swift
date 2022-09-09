//
//  GetCatModel.swift
//  CatDiary
//
//  Created by Hertz on 9/4/22.
//

import Foundation

// MARK: - WelcomeElement
struct CatGetModel: Codable {
    let breeds: [Breed]?
    let id: String?
    let url: String?
}

// MARK: - Breed
struct Breed: Codable {
    let id, name: String?
    let lifeSpan: String?
    let childFriendly: Int?
    let energyLevel: Int?
    let intelligence: Int?
    let strangerFriendly: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case lifeSpan = "life_span"
        case childFriendly = "child_friendly"
        case energyLevel = "energy_level"
        case intelligence
        case strangerFriendly = "stranger_friendly"
    }
}


