//
//  GameListViewModel.swift
//  GamesApp
//
//  Created by Habip Yeşilyurt on 11.12.2022.
//

import Foundation

protocol GameListViewModelProtocol {
    var delegate: GameListViewModelDelegate? { get set }
    func fetchGames(isPagination: Bool, completion: @escaping (_ isSuccess: Bool, ErrorTypes?) -> ())
    func fetchTopRatedGamesOf2022(isPagination: Bool, completion: @escaping (_ isSuccess: Bool, ErrorTypes?) -> ())
    func fetchMostAnticipatedUpcomingGamesOf2022(isPagination: Bool, completion: @escaping (_ isSuccess: Bool, ErrorTypes?) -> ())
    func getGameCount() -> Int
    func getGame(at index: Int) -> Game?
    func getGameId(at index: Int) -> Int?
    func searchGame(searchText: String)
}

protocol GameListViewModelDelegate: AnyObject {
    func gamesLoaded()
}

protocol NotificationManagerProtocol {
    func setNotification(_ duration: Int, of type: LocalNotificationDurationType, repeats: Bool, title: String, body: String)
}

final class GameListViewModel: GameListViewModelProtocol, NotificationManagerProtocol {
    weak var delegate: GameListViewModelDelegate?
    private var games: [Game]?
    private var filteredGames: [Game]?
    var nextPage: String?
    
    func fetchGames(isPagination: Bool, completion: @escaping (_ isSuccess: Bool, ErrorTypes?) -> ()) {
        guard !NetworkManager.shared.isPaginating else { return }
        NetworkManager.shared.getAllGames(isPagination: isPagination, nextPage: nextPage) { [weak self] games, next, fetchError in
            guard let self = self else { return }
            self.getFetchRequestResults(isPagination: isPagination, next: next, games: games, fetchError: fetchError, completion: completion)
        }
    }
    
    func fetchTopRatedGamesOf2022(isPagination: Bool, completion: @escaping (_ isSuccess: Bool, ErrorTypes?) -> ()) {
        guard !NetworkManager.shared.isPaginating else { return }
        NetworkManager.shared.getTopRatedGamesOf2022(isPagination: isPagination, nextPage: nextPage) { [weak self] games, next, fetchError in
            guard let self = self else { return }
            self.getFetchRequestResults(isPagination: isPagination, next: next, games: games, fetchError: fetchError, completion: completion)
        }

    }

    func fetchMostAnticipatedUpcomingGamesOf2022(isPagination: Bool, completion: @escaping (_ isSuccess: Bool, ErrorTypes?) -> ()) {
        guard !NetworkManager.shared.isPaginating else { return }
        NetworkManager.shared.getMostAnticipatedUpcomingGamesOf2022(isPagination: isPagination, nextPage: nextPage) { [weak self] games, next, fetchError in
            guard let self = self else { return }
            self.getFetchRequestResults(isPagination: isPagination, next: next, games: games, fetchError: fetchError, completion: completion)
        }

    }
    
    private func getFetchRequestResults(isPagination: Bool, next: String?, games: [Game]?, fetchError: ErrorTypes?, completion: @escaping (_ isSuccess: Bool, ErrorTypes?) -> ()) {
        if fetchError != nil {
            completion(false, .fetchError)
        } else {
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
    
    func setNotification(_ duration: Int, of type: LocalNotificationDurationType, repeats: Bool, title: String, body: String) {
        LocalNotificationManager.shared.setNotification(duration, of: type, repeats: repeats, title: title, body: body)
    }
}
