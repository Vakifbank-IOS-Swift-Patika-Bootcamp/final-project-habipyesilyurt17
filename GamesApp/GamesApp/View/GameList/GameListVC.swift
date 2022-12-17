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
        configureSearchBar()
        indicator.startAnimating()
        gameListViewModel.delegate = self
        fetchGames()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getAllGames), name: NSNotification.Name(rawValue: "getAllGames"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(fetchUpcomingGames), name: NSNotification.Name(rawValue: "upcomingGames"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(fetchTopRatedGames), name: NSNotification.Name(rawValue: "fetchTopRatedGames"), object: nil)
    }
    
    private func fetchGames() {
        gameListViewModel.fetchGames(isPagination: false) { isSuccess, errorMessage in
            if isSuccess {
            } else {
                guard let errorMessage = errorMessage else { return }
                print("errorMessage = \(errorMessage)")
            }
        }
    }
    
    @objc func getAllGames() {
        self.dismiss(animated: true, completion: nil)
        let blurEffect = UIBlurEffect(style: .light)
        let blurVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurVisualEffectView.frame = view.bounds
        blurVisualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.gameTableView.addSubview(blurVisualEffectView)
        indicator.startAnimating()
        gameListViewModel.fetchGames(isPagination: false) { isSuccess, errorMessage in
            if isSuccess {
                blurVisualEffectView.removeFromSuperview()
            } else {
                guard let errorMessage = errorMessage else { return }
                print("errorMessage = \(errorMessage)")
            }
        }
    }

    @objc func fetchUpcomingGames() {
        self.dismiss(animated: true, completion: nil)
        let blurEffect = UIBlurEffect(style: .light)
        let blurVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurVisualEffectView.frame = view.bounds
        blurVisualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.gameTableView.addSubview(blurVisualEffectView)
        indicator.startAnimating()
        gameListViewModel.fetchMostAnticipatedUpcomingGamesOf2022(isPagination: false) { isSuccess, errorMessage in
            if isSuccess {
                blurVisualEffectView.removeFromSuperview()
            } else {
                guard let errorMessage = errorMessage else { return }
                print("errorMessage = \(errorMessage)")
            }
        }
    }
    
    @objc func fetchTopRatedGames() {
        self.dismiss(animated: true, completion: nil)
        let blurEffect = UIBlurEffect(style: .light)
        let blurVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurVisualEffectView.frame = view.bounds
        blurVisualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        self.gameTableView.addSubview(blurVisualEffectView)
        indicator.startAnimating()
        gameListViewModel.fetchTopRatedGamesOf2022(isPagination: false) { isSuccess, errorMessage in
            if isSuccess {
                blurVisualEffectView.removeFromSuperview()
            } else {
                guard let errorMessage = errorMessage else { return }
                print("errorMessage = \(errorMessage)")
            }
        }
    }
    
    @IBAction func gamesOrderButtonPressed(_ sender: Any) {
        let gameFilterVC = storyboard?.instantiateViewController(withIdentifier: "GameFilterVC") as! GameFilterVC
        self.present(gameFilterVC, animated: true)        
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
            gameListViewModel.fetchGames(isPagination: true) { isSuccess, errorMessage in
                if isSuccess {
                    self.gameTableView.tableFooterView = nil
                } else {
                    guard let errorMessage = errorMessage else { return }
                    print("errorMessage = \(errorMessage)")
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
