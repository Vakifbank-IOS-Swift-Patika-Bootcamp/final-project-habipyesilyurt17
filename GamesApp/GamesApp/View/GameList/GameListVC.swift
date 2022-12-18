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
    
    private var gameListViewModel = GameListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureGameTableView()
        configureSearchBar()
        indicator.startAnimating()
        gameListViewModel.delegate = self
        fetchGames()
        gameListViewModel.setNotification(5, of: .seconds, repeats: false, title: "Remember me!", body: "This is local notification")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getAllGames), name: NSNotification.Name(rawValue: "getAllGames"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(fetchUpcomingGames), name: NSNotification.Name(rawValue: "upcomingGames"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(fetchTopRatedGames), name: NSNotification.Name(rawValue: "fetchTopRatedGames"), object: nil)
    }
    
    private func configureGameTableView() {
        gameTableView.dataSource = self
        gameTableView.delegate   = self
        gameTableView.register(UINib(nibName: "GameListTableViewCell", bundle: nil), forCellReuseIdentifier: "GameCell")
        gameTableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    private func configureSearchBar() {
        gameSearchBar.placeholder = "Search a game"
        gameSearchBar.delegate = self
    }
    
    private func fetchGames() {
        gameListViewModel.fetchGames(isPagination: false) { [weak self] isSuccess, errorMessage in
            guard let self = self else { return }
            if !isSuccess {
                guard let errorMessage = errorMessage else { return }
                self.showErrorAlert(message: errorMessage.rawValue) {
                    self.indicator.stopAnimating()
                }
            }
        }
    }
    
    @objc func getAllGames() {
        let blurVisualEffectView = createBlurEffectOnTableView()
        gameListViewModel.fetchGames(isPagination: false) { [weak self] isSuccess, errorMessage in
            guard let self = self else { return }
            if isSuccess {
                self.removeBlurEffect(blurEffectView: blurVisualEffectView, isSuccess: isSuccess, error: errorMessage)
            } else {
                guard let errorMessage = errorMessage else { return }
                self.showErrorAlert(message: errorMessage.rawValue) {
                    self.indicator.stopAnimating()
                }
            }
        }
    }
    
    @objc func fetchUpcomingGames() {
        let blurVisualEffectView = createBlurEffectOnTableView()
        gameListViewModel.fetchMostAnticipatedUpcomingGamesOf2022(isPagination: false) { [weak self] isSuccess, errorMessage in
            guard let self = self else { return }
            if isSuccess {
                self.removeBlurEffect(blurEffectView: blurVisualEffectView, isSuccess: isSuccess, error: errorMessage)
            } else {
                guard let errorMessage = errorMessage else { return }
                self.showErrorAlert(message: errorMessage.rawValue) {
                    self.indicator.stopAnimating()
                }
            }
        }
    }
    
    @objc func fetchTopRatedGames() {
        let blurVisualEffectView = createBlurEffectOnTableView()
        gameListViewModel.fetchTopRatedGamesOf2022(isPagination: false) { [weak self] isSuccess, errorMessage in
            guard let self = self else { return }
            if isSuccess {
                self.removeBlurEffect(blurEffectView: blurVisualEffectView, isSuccess: isSuccess, error: errorMessage)
            } else {
                guard let errorMessage = errorMessage else { return }
                self.showErrorAlert(message: errorMessage.rawValue) {
                    self.indicator.stopAnimating()
                }
            }
        }
    }
    
    @IBAction func gamesOrderButtonPressed(_ sender: Any) {
        let gameFilterVC = storyboard?.instantiateViewController(withIdentifier: "GameFilterVC") as! GameFilterVC
        self.present(gameFilterVC, animated: true)
    }
    
    private func createBlurEffectOnTableView() -> UIVisualEffectView {
        self.dismiss(animated: true, completion: nil)
        let blurEffect = UIBlurEffect(style: .light)
        let blurVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurVisualEffectView.frame = gameTableView.bounds
        blurVisualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        indicator.startAnimating()
        gameTableView.addSubview(blurVisualEffectView)
        return blurVisualEffectView
    }
    
    private func removeBlurEffect(blurEffectView: UIVisualEffectView, isSuccess: Bool, error: ErrorTypes?) {
        if isSuccess {
            blurEffectView.removeFromSuperview()
        } else {
            guard let error = error else { return }
            self.showErrorAlert(message: error.rawValue) {
            }
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "GameDetailVC") as? GameDetailVC else { return }
        detailVC.gameId = gameListViewModel.getGameId(at: indexPath.row)
        navigationController?.pushViewController(detailVC, animated: true)
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
            gameListViewModel.fetchGames(isPagination: true) { [weak self] isSuccess, errorMessage in
                guard let self = self else { return }
                if isSuccess {
                    self.gameTableView.tableFooterView = nil
                } else {
                    guard let errorMessage = errorMessage else { return }
                    self.showErrorAlert(message: errorMessage.rawValue) {
                    }
                }
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

extension GameListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        gameListViewModel.searchGame(searchText: searchText)
        gameTableView.reloadData()
    }
}
