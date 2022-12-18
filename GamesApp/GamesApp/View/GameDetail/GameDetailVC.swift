//
//  GameDetailVC.swift
//  GamesApp
//
//  Created by Habip Yeşilyurt on 13.12.2022.
//

import UIKit

final class GameDetailVC: BaseVC {
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var gameRating: UILabel!
    @IBOutlet weak var gameReleased: UILabel!
    @IBOutlet weak var gameDescription: UITextView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var blurView: UIView!
    
    var gameId: Int?
    private var gameDetailViewModel: GameDetailViewModelProtocol = GameDetailViewModel()
    private var favoriteGameListViewModel = FavoriteGameListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        gameDetailViewModel.delegate = self
        fetchGameDetail()
    }
    
    private func fetchGameDetail() {
        blurView.alpha = 1
        indicator.startAnimating()
        
        guard let id = gameId else { return }
        gameDetailViewModel.getGameDetail(gameId: id) { [weak self] isSuccess, errorMessage in
            guard let self = self else { return }
            if isSuccess {
                self.blurView.alpha = 0
            } else {
                guard let errorMessage = errorMessage else { return }
                self.showErrorAlert(message: errorMessage.rawValue) {
                    self.indicator.stopAnimating()
                }
            }
        }
    }

    @IBAction func websiteButtonPressed(_ sender: Any) {
        guard let webViewVC = storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as? WebViewVC else { return }
        webViewVC.urlString = gameDetailViewModel.getGameWebsite()
        navigationController?.pushViewController(webViewVC, animated: true)
    }
    
    
    @IBAction func favoriteGameButtonPressed(_ sender: Any) {
        if gameDetailViewModel.gameIsFavorite() {
            guard let gameId = gameId else { return }
            favoriteGameListViewModel.deleteGame(gameId: gameId) { [weak self] isSuccess, deleteError in
                guard let self = self else { return }
                if isSuccess {
                    self.favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
                    NotificationCenter.default.post(name: NSNotification.Name("deleteData"), object: nil)
                } else {
                    guard let deleteError = deleteError else { return }
                    self.showErrorAlert(message: deleteError) {
                        self.indicator.stopAnimating()
                    }
                }
            }
        } else {
            let favoriteGame = createNewFavoriteGame()
            favoriteGameListViewModel.saveGame(game: favoriteGame) { [weak self] isSuccess, saveError in
                guard let self = self else { return }
                if isSuccess {
                    self.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                } else {
                    guard let saveError = saveError else { return }
                    self.showErrorAlert(message: saveError) {
                        self.indicator.stopAnimating()
                    }
                }
            }
        }
    }
    
    private func createNewFavoriteGame() -> FavoriteGames {
        let newGame = FavoriteGames(context: FavoriteGamesManager.shared.context)
        newGame.setValue(gameId, forKey: "gameId")
        newGame.setValue(gameTitle.text, forKey: "name")
        newGame.setValue(Double(gameDetailViewModel.getGameRating()), forKey: "rating")
        newGame.setValue(gameDetailViewModel.getGameReleased(), forKey: "released")
        newGame.setValue(gameDescription.text, forKey: "desc")
        newGame.setValue(Date(), forKey: "createdAt")
        guard let imageData = gameImage.image else { return newGame }
        newGame.setValue(imageData.pngData(), forKey: "image")
        return newGame
    }
    
}

extension GameDetailVC: GameDetailViewModelDelegate {
    func gameLoaded() {
        indicator.stopAnimating()
        guard let url = gameDetailViewModel.getGameImageUrl() else { return }
        gameImage.kf.setImage(with: url)
        gameTitle.text = gameDetailViewModel.getGameTitle()
        gameRating.attributedText = configureLabelWithIcon(labelText: String(gameDetailViewModel.getGameRating()), icon: "star.fill")
        gameReleased.attributedText = configureLabelWithIcon(labelText: gameDetailViewModel.getGameReleased(), icon: "calendar")
        gameDescription.text = gameDetailViewModel.getGameDescription()
        gameDescription.isEditable = false
        
        if gameDetailViewModel.gameIsFavorite() {
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }

    private func configureLabelWithIcon(labelText: String, icon: String) -> NSMutableAttributedString {
        let attachment = NSTextAttachment()
        let text = labelText
        let img = UIImage(systemName: icon)
        let font = UIFont.systemFont(ofSize: 18)
        attachment.image = img
        let mid = font.descender + font.capHeight
        attachment.bounds = CGRect(x: 0, y: font.descender - (img?.size.height ?? 32) / 2 + mid + 2, width: (img?.size.width ?? 32), height: (img?.size.height ?? 32))
        let attachmentString = NSAttributedString(attachment: attachment)
        let mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(attachmentString)
        let string = NSMutableAttributedString(string: text, attributes: [:])
        mutableAttributedString.append(string)
        return mutableAttributedString
    }
}
