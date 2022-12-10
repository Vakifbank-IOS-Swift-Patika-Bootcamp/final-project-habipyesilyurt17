//
//  NetworkManager.swift
//  GamesApp
//
//  Created by Habip Yeşilyurt on 10.12.2022.
//

import Foundation

struct NetworkManager {
    static let shared = NetworkManager()
    
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
    
    func getAllGames(completion: @escaping ([Game]?, String?)->()) {
        let urlString = GameEndPoint.BASE_URL.rawValue + GameEndPoint.API_URL.rawValue + GameEndPoint.API_KEY.rawValue
        NetworkManager.shared.request(type: GameModel.self, url: urlString, method: .get) { response in
            switch response {
            case .success(let games):
                completion(games.results, nil)
            case .failure(let error):
                completion(nil, error.rawValue)
            }
        }
    }
    
    func getGameDetail(gameId: Int, completion: @escaping (GameDetailModel?, String?) -> Void) {
        let urlString = GameEndPoint.BASE_URL.rawValue + GameEndPoint.API_URL.rawValue + "/\(gameId)" + GameEndPoint.API_KEY.rawValue
        NetworkManager.shared.request(type: GameDetailModel.self, url: urlString, method: .get) { response in
            switch response {
            case .success(let game):
                completion(game, nil)
            case .failure(let error):
                completion(nil, error.rawValue)
            }
        }
    }
}
