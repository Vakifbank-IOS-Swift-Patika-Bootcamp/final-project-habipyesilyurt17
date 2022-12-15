//
//  FavoriteGameListVC.swift
//  GamesApp
//
//  Created by Habip Yeşilyurt on 14.12.2022.
//

import UIKit

final class FavoriteGameListVC: BaseVC {
    @IBOutlet weak var favoriteGamesTableView: UITableView!

    private var favoriteGameListViewModel: FavoriteGameListViewModelProtocol = FavoriteGameListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFavoriteGamesTableView()
        indicator.startAnimating()
        favoriteGameListViewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getGames()
    }
    
    @objc private func getGames() {
        favoriteGameListViewModel.fetchGames { isSuccess, errorMessage in
            if !isSuccess {
                guard let errorMessage = errorMessage else { return }
                print("errorMessage = \(errorMessage)")
            }
        }
    }
    
    private func configureFavoriteGamesTableView() {
        favoriteGamesTableView.dataSource = self
        favoriteGamesTableView.delegate   = self
        favoriteGamesTableView.register(UINib(nibName: "GameListTableViewCell", bundle: nil), forCellReuseIdentifier: "GameCell")
        favoriteGamesTableView.estimatedRowHeight = UITableView.automaticDimension
    }

}

extension FavoriteGameListVC: GameListViewModelDelegate {
    func gamesLoaded() {
        self.indicator.stopAnimating()
        self.favoriteGamesTableView.reloadData()
    }
}

extension FavoriteGameListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favoriteGameListViewModel.getGameCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell") as? GameListTableViewCell else { return UITableViewCell() }
        cell.gameTitle.text = favoriteGameListViewModel.getGame(at: indexPath.row)?.name
        if let imageData = favoriteGameListViewModel.getGame(at: indexPath.row)?.image as? Data {
            cell.gameImage.image = UIImage(data: imageData)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "GameDetailVC") as? GameDetailVC else { return }
        guard let id = favoriteGameListViewModel.getGame(at: indexPath.row)?.gameId else { return }
        detailVC.gameId = Int(id)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
