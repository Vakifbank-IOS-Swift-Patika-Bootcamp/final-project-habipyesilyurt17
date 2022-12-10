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
    case API_KEY  = "?key=ded10ba013a0407eb15d07339795c01e"
}
