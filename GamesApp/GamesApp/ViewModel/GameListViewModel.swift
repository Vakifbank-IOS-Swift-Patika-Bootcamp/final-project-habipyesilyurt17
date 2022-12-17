//
//  GameListViewModel.swift
//  GamesApp
//
//  Created by Habip Yeşilyurt on 11.12.2022.
//

import Foundation

protocol GameListViewModelProtocol {
    var delegate: GameListViewModelDelegate? { get set }
    func fetchGames(isPagination: Bool, completion: @escaping (_ isSuccess: Bool, String?) -> ())
    func fetchTopRatedGamesOf2022(isPagination: Bool, completion: @escaping (_ isSuccess: Bool, String?) -> ())
    func fetchMostAnticipatedUpcomingGamesOf2022(isPagination: Bool, completion: @escaping (_ isSuccess: Bool, String?) -> ())
    func getGameCount() -> Int
    func getGame(at index: Int) -> Game?
    func getGameId(at index: Int) -> Int?
    func searchGame(searchText: String)
}

protocol GameListViewModelDelegate: AnyObject {
    func gamesLoaded()
}

final class GameListViewModel: GameListViewModelProtocol {
    weak var delegate: GameListViewModelDelegate?
    private var games: [Game]?
    private var filteredGames: [Game]?
    var nextPage: String?
    
    func fetchGames(isPagination: Bool, completion: @escaping (_ isSuccess: Bool, String?) -> ()) {
        guard !NetworkManager.shared.isPaginating else { return }
        NetworkManager.shared.getAllGames(isPagination: isPagination, nextPage: nextPage) { [weak self] games, next, error in
            if error != nil {
                completion(false, error)
            } else {
                guard let self = self else { return }
                if isPagination {
                    guard let games = games else { return }
                    self.games?.append(contentsOf: games)
                } else {
                    self.games = games
                }
                self.filteredGames = self.games
                self.nextPage = next
                self.delegate?.gamesLoaded()
                completion(true, nil)
            }
        }
    }
    
    func fetchTopRatedGamesOf2022(isPagination: Bool, completion: @escaping (_ isSuccess: Bool, String?) -> ()) {
        guard !NetworkManager.shared.isPaginating else { return }
        NetworkManager.shared.getTopRatedGamesOf2022(isPagination: isPagination, nextPage: nextPage) { [weak self] games, next, error in
            if error != nil {
                completion(false, error)
            } else {
                guard let self = self else { return }
                self.games?.removeAll()
                if isPagination {
                    guard let games = games else { return }
                    self.games?.append(contentsOf: games)
                } else {
                    self.games = games
                }
                self.filteredGames = self.games
                self.nextPage = next
                self.delegate?.gamesLoaded()
                completion(true, nil)
            }
        }

    }

    func fetchMostAnticipatedUpcomingGamesOf2022(isPagination: Bool, completion: @escaping (_ isSuccess: Bool, String?) -> ()) {
        guard !NetworkManager.shared.isPaginating else { return }
        NetworkManager.shared.getMostAnticipatedUpcomingGamesOf2022(isPagination: isPagination, nextPage: nextPage) { [weak self] games, next, error in
            if error != nil {
                completion(false, error)
            } else {
                guard let self = self else { return }
                self.games?.removeAll()
                if isPagination {
                    guard let games = games else { return }
                    self.games?.append(contentsOf: games)
                } else {
                    self.games = games
                }
                self.filteredGames = self.games
                self.nextPage = next
                self.delegate?.gamesLoaded()
                completion(true, nil)
            }
        }

    }

    
    func getGameCount() -> Int {
        filteredGames?.count ?? 0
    }
    
    func getGame(at index: Int) -> Game? {
        filteredGames?[index]
    }
    
    func getGameId(at index: Int) -> Int? {
        filteredGames?[index].id
    }
    
    func searchGame(searchText: String) {
        filteredGames = []
        if searchText == "" {
            filteredGames = games
        } else {
            guard let games = games else { return }
            for game in games {
                if game.name.lowercased().contains(searchText.lowercased()) {
                    filteredGames?.append(game)
                }
            }
        }
    }
}
