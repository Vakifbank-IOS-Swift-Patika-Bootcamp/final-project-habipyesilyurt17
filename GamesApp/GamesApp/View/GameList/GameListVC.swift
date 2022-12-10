//
//  GameListVC.swift
//  GamesApp
//
//  Created by Habip Yeşilyurt on 10.12.2022.
//

import UIKit

final class GameListVC: UIViewController {
    @IBOutlet weak var gameSearchBar: UISearchBar!
    @IBOutlet weak var gameTableView: UITableView!
    
    private var gameListViewModel: GameListViewModelProtocol = GameListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureGameTableView()
        gameListViewModel.delegate = self
        gameListViewModel.fetchGames()
    }
    
    @IBAction func gamesOrderButtonPressed(_ sender: Any) {
    }
    
    private func configureGameTableView() {
        gameTableView.dataSource = self
        gameTableView.delegate   = self
        gameTableView.register(UINib(nibName: "GameListTableViewCell", bundle: nil), forCellReuseIdentifier: "GameCell")
        gameTableView.estimatedRowHeight = UITableView.automaticDimension
    }
}

extension GameListVC: GameListViewModelDelegate {
    func gamesLoaded() {
        gameTableView.reloadData()
    }
}

extension GameListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        gameListViewModel.getGameCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell") as? GameListTableViewCell, let model = gameListViewModel.getGame(at: indexPath.row) else { return UITableViewCell() }
        cell.configureCell(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
