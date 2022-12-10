//
//  GameModel.swift
//  GamesApp
//
//  Created by Habip Yeşilyurt on 10.12.2022.
//

import Foundation

struct GameModel: Decodable {
    let next: String
    let results: [Game]
}

struct Game: Decodable {
    let id: Int
    let name: String
    let backgroundImage: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case backgroundImage = "background_image"
    }
}
