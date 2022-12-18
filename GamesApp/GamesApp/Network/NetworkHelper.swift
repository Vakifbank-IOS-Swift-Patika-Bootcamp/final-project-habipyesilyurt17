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
    case fetchError   = "Data couldn't be fetched"
}

enum GameEndPoint: String {
    case BASE_URL = "https://api.rawg.io/api"
    case API_URL  = "/games"
    var api_key: String {
        return "key=\(Bundle.main.infoDictionary!["API_KEY"] as! String)"
    }
}

enum APIURLs {
    static func allGames() -> String {
        GameEndPoint.BASE_URL.rawValue + GameEndPoint.API_URL.rawValue + "?" + GameEndPoint.API_URL.api_key
    }
    
    static func gameDetail(gameId: Int) -> String {
        GameEndPoint.BASE_URL.rawValue + GameEndPoint.API_URL.rawValue + "/\(gameId)" + "?" + GameEndPoint.API_URL.api_key

    }
    
    static func topRatedGamesOf2022() -> String {
        GameEndPoint.BASE_URL.rawValue + GameEndPoint.API_URL.rawValue + "?dates=2022-01-01,2022-12-31&ordering=-rating&" + GameEndPoint.API_URL.api_key
    }
    
    static func mostAnticipatedUpcomingGamesOf2022() -> String {
        GameEndPoint.BASE_URL.rawValue + GameEndPoint.API_URL.rawValue + "?dates=2022-01-01,2022-12-31&ordering=-added&" + GameEndPoint.API_URL.api_key
    }
}
