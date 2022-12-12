//
//  GameListVC.swift
//  GamesApp
//
//  Created by Habip Yeşilyurt on 10.12.2022.
//

import UIKit

final class GameListVC: BaseVC {
    @IBOutlet weak var gameSearchBar: UISearchBar!
    @IBOutlet weak var gameTableView: UITableView!
    
    private var gameListViewModel: GameListViewModelProtocol = GameListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureGameTableView()
        indicator.startAnimating()
        gameListViewModel.delegate = self
        gameListViewModel.fetchGames(isPagination: false) { errorMessage in
            guard let errorMessage = errorMessage else { return }
            print("errorMessage = \(errorMessage)")
        }
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
        indicator.stopAnimating()
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

extension GameListVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY       = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height {
            gameTableView.tableFooterView = createSpinnerFooter()
            gameListViewModel.fetchGames(isPagination: true) { errorMessage in
                self.gameTableView.tableFooterView = nil
                guard let errorMessage = errorMessage else { return }
                print("errorMessage = \(errorMessage)")
            }
        }
    }
    
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        footerView.addSubview(indicator)
        indicator.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        indicator.startAnimating()
        return footerView
    }
}
