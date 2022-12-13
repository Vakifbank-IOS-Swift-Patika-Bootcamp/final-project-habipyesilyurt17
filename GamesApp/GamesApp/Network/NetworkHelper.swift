//
//  NetworkHelper.swift
//  GamesApp
//
//  Created by Habip Yeşilyurt on 10.12.2022.
//

import Foundation

enum HTTPMethods: String {
    case get = "GET"
}

enum ErrorTypes: String, Error {
    case invalidData  = "Invalid data"
    case invalidURL   = "Invalid url"
    case generalError = "An error happened"
}

enum GameEndPoint: String {
    case BASE_URL = "https://api.rawg.io/api"
    case API_URL  = "/games"
    case API_KEY  = "key=ded10ba013a0407eb15d07339795c01e"
}

enum APIURLs {
    static func allGames() -> String {
        GameEndPoint.BASE_URL.rawValue + GameEndPoint.API_URL.rawValue + "?" + GameEndPoint.API_KEY.rawValue
    }
    
    static func gameDetail(gameId: Int) -> String {
        GameEndPoint.BASE_URL.rawValue + GameEndPoint.API_URL.rawValue + "/\(gameId)" + "?" + GameEndPoint.API_KEY.rawValue
    }
    
    static func topRatedGamesOf2022() -> String {
        GameEndPoint.BASE_URL.rawValue + GameEndPoint.API_URL.rawValue + "?dates=2022-01-01,2022-12-31&ordering=-rating&" + GameEndPoint.API_KEY.rawValue
    }
}
