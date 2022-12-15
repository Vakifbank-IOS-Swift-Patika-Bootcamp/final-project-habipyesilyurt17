//
//  GameDetailViewModel.swift
//  GamesApp
//
//  Created by Habip Yeşilyurt on 14.12.2022.
//

import Foundation

protocol GameDetailViewModelProtocol {
    var delegate: GameDetailViewModelDelegate? { get set }
    func getGameDetail(gameId: Int, completion: @escaping (_ isSuccess: Bool, String?) -> ())
    func getGameImageUrl() -> URL?
    func getGameTitle() -> String
    func getGameRating() -> Double
    func getGameReleased() -> String
    func getGameWebsite() -> String
    func getGameDescription() -> String
    func gameIsFavorite() -> Bool
}

protocol GameDetailViewModelDelegate: AnyObject {
    func gameLoaded()
}

final class GameDetailViewModel: GameDetailViewModelProtocol {
    weak var delegate: GameDetailViewModelDelegate?
    private var game: GameDetailModel?

    func getGameDetail(gameId: Int, completion: @escaping (Bool, String?) -> ()) {
        NetworkManager.shared.getGameDetail(gameId: gameId) { [weak self] gameDetail, error in
            if error != nil {
                completion(false, error)
            } else {
                guard let self = self else { return }
                self.game = gameDetail
                FavoriteGamesManager.shared.fetchData { favoriteGames, dataError in
                    guard let favoriteGames = favoriteGames else { return }
        
                    favoriteGames.forEach { favoriteGame in
                        if self.game!.id == favoriteGame.gameId {
                            self.game?.isFavorite = true
                            //break
                        }
                    }
                    
                }
                self.delegate?.gameLoaded()
                completion(true, nil)
            }
        }
    }

    func getGameImageUrl() -> URL? {
        URL(string: game?.backgroundImage ?? "")
    }

    func getGameTitle() -> String {
        game?.name ?? ""
    }

    func getGameRating() -> Double {
        game?.rating ?? 0
    }

    func getGameReleased() -> String {
        game?.released ?? ""
    }

    func getGameWebsite() -> String {
        game?.website ?? ""
    }

    func getGameDescription() -> String {
        game?.descriptionRaw ?? ""
    }

    func gameIsFavorite() -> Bool {
        game?.isFavorite ?? false
    }
}
