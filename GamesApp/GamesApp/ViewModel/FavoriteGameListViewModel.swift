//
//  FavoriteGameListViewModel.swift
//  GamesApp
//
//  Created by Habip Yeşilyurt on 14.12.2022.
//

import Foundation

protocol FavoriteGameListViewModelProtocol {
    var delegate: GameListViewModelDelegate? { get set }
    func fetchGames(completion: @escaping (_ isSuccess: Bool, String?) -> ())
    func getGameCount() -> Int
    func getGame(at index: Int) -> FavoriteGames?
}

final class FavoriteGameListViewModel: FavoriteGameListViewModelProtocol {
    weak var delegate: GameListViewModelDelegate?
    private var favoriteGames: [FavoriteGames]?
    
    func fetchGames(completion: @escaping (_ isSuccess: Bool, String?) -> ()) {
        FavoriteGamesManager.shared.fetchData { [weak self] games, fetchError in
            guard let self = self else { return }
            if fetchError == .noError {
                guard let games = games else { return }
                self.favoriteGames = games
                self.delegate?.gamesLoaded()
                completion(true, nil)
            } else {
                if self.getGameCount() == 1 {
                    self.favoriteGames?.removeAll()
                }
                self.delegate?.gamesLoaded()
                completion(false, fetchError.rawValue)
            }
        }
    }
    
    func getGameCount() -> Int {
        favoriteGames?.count ?? 0
    }
    
    func getGame(at index: Int) -> FavoriteGames? {
        favoriteGames?[index]
    }
}
