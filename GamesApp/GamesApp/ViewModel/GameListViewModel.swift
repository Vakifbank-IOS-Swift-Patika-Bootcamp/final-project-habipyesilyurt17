//
//  GameListViewModel.swift
//  GamesApp
//
//  Created by Habip Yeşilyurt on 11.12.2022.
//

import Foundation

protocol GameListViewModelProtocol {
    var delegate: GameListViewModelDelegate? { get set }
    func fetchGames()
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
    
    func fetchGames() {
        NetworkManager.shared.getAllGames { [weak self] games, error in
            guard let self = self else { return }
            self.games = games
            self.delegate?.gamesLoaded()
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
