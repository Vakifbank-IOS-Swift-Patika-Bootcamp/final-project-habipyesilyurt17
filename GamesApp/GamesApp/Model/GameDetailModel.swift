//
//  GameDetailModel.swift
//  GamesApp
//
//  Created by Habip Yeşilyurt on 10.12.2022.
//

import Foundation

struct GameDetailModel: Decodable {
    let id: Int
    let name: String
    let released: String
    let website: String
    let rating: Double
    let descriptionRaw: String
    let backgroundImage: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, released, website
        case rating
        case descriptionRaw  = "description_raw"
        case backgroundImage = "background_image"
    }
}
