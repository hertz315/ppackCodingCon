//
//  FavoriteCatModel.swift
//  CatDiary
//
//  Created by Hertz on 9/5/22.
//

import Foundation

// MARK: - WelcomeElement
struct FavoriteCatModel: Codable {
    let id: Int?
    let userID, imageID, subID: String?
    let image: Image?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case imageID = "image_id"
        case subID = "sub_id"
        case image
    }
}

// MARK: - Image
struct Image: Codable {
    let id: String?
    let imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case imageUrl = "url"
    }
}



