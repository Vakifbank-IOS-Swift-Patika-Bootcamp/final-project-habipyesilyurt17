//
//  GameListViewModel.swift
//  GamesApp
//
//  Created by Habip Yeşilyurt on 11.12.2022.
//

import Foundation

protocol GameListViewModelProtocol {
    var delegate: GameListViewModelDelegate? { get set }
    func fetchGames(isPagination: Bool, completion: @escaping (String?) -> ())
    func getGameCount() -> Int
    func getGame(at index: Int) -> Game?
    func getGameId(at index: Int) -> Int?
}

protocol GameListViewModelDelegate: AnyObject {
    func gamesLoaded()
}

final class GameListViewModel: GameListViewModelProtocol {
    weak var delegate: GameListViewModelDelegate?
    private var games: [Game]?
    var nextPage: String?
    
    func fetchGames(isPagination: Bool, completion: @escaping (String?) -> ()) {
        guard !NetworkManager.shared.isPaginating else { return }
        NetworkManager.shared.getAllGames(isPagination: isPagination, nextPage: nextPage) { [weak self] games, next, error in
            guard let self = self else { return }
            if isPagination {
                guard let games = games else { return }
                self.games?.append(contentsOf: games)
            } else {
                self.games = games
            }
            self.nextPage = next
            self.delegate?.gamesLoaded()
            completion(error)
        }
    }
    
    func getGameCount() -> Int {
        games?.count ?? 0
    }
    
    func getGame(at index: Int) -> Game? {
        games?[index]
    }
    
    func getGameId(at index: Int) -> Int? {
        games?[index].id
    }
}
