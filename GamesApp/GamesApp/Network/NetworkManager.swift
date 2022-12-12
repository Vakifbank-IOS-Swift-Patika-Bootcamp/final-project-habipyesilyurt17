//
//  NetworkManager.swift
//  GamesApp
//
//  Created by Habip Yeşilyurt on 10.12.2022.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    var isPaginating: Bool = false

    private func request<T: Decodable>(type: T.Type, url: String, method: HTTPMethods, completion: @escaping ((Result<T, ErrorTypes>)->())) {
        let session = URLSession.shared
        if let url  = URL(string: url) {
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            session.dataTask(with: request) { data, response, error in
                if let _ = error {
                    DispatchQueue.main.async {
                        completion(.failure(.generalError))
                    }
                } else if let data = data {
                    self.handleResponse(data: data) { response in
                        DispatchQueue.main.async {
                            completion(response)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(.invalidURL))
                    }
                }
            }.resume()
        }
    }
    
    private func handleResponse<T: Decodable>(data: Data, completion: @escaping ((Result<T, ErrorTypes>)->())) {
        do {
            let response = try JSONDecoder().decode(T.self, from: data)
            completion(.success(response))
        } catch {
            completion(.failure(.invalidData))
        }
    }
    
    func getAllGames(isPagination: Bool, nextPage: String?, completion: @escaping ([Game]?, String?, String?)->()) {
        let urlString: String
        if isPagination {
            isPaginating = true
            guard let nextPage = nextPage else { return }
            urlString = nextPage
        } else {
            urlString = APIURLs.allGames()
        }
        
        request(type: GameModel.self, url: urlString, method: .get) { response in
            switch response {
            case .success(let games):
                completion(games.results, games.next, nil)
                if isPagination {
                    self.isPaginating = false
                }
            case .failure(let error):
                completion(nil, nil, error.rawValue)
            }
        }
    }
    
    func getGameDetail(gameId: Int, completion: @escaping (GameDetailModel?, String?) -> Void) {
        let urlString = APIURLs.gameDetail(gameId: gameId)
        request(type: GameDetailModel.self, url: urlString, method: .get) { response in
            switch response {
            case .success(let game):
                completion(game, nil)
            case .failure(let error):
                completion(nil, error.rawValue)
            }
        }
    }
    
    func getTopRatedGamesOf2022(isPagination: Bool, nextPage: String?, completion: @escaping ([Game]?, String?, String?)->()) {
        let urlString: String
        if isPagination {
            isPaginating = true
            guard let nextPage = nextPage else { return }
            urlString = nextPage
        } else {
            urlString = APIURLs.topRatedGamesOf2022()
        }
        
        request(type: GameModel.self, url: urlString, method: .get) { response in
            switch response {
            case .success(let games):
                completion(games.results, games.next, nil)
                if isPagination {
                    self.isPaginating = false
                }
            case .failure(let error):
                completion(nil, nil, error.rawValue)
            }
        }
        
    }
}
