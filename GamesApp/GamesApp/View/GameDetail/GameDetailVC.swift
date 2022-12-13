//
//  GameDetailVC.swift
//  GamesApp
//
//  Created by Habip Yeşilyurt on 12.12.2022.
//

import UIKit
import Kingfisher

final class GameDetailVC: BaseVC {
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var gameRating: UILabel!
    @IBOutlet weak var gameReleased: UILabel!
    @IBOutlet weak var gameDescription: UITextView!
    @IBOutlet weak var favoriteButton: UIButton!
    var gameId: Int?
    private var gameDetailViewModel: GameDetailViewModelProtocol = GameDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameDetailViewModel.delegate = self

        let blurEffect = UIBlurEffect(style: .light)
        let blurVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurVisualEffectView.frame = view.bounds
        blurVisualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurVisualEffectView)
        indicator.startAnimating()
        guard let id = gameId else { return }
        gameDetailViewModel.getGameDetail(gameId: id) { isSuccess, errorMessage in
            if isSuccess {
                blurVisualEffectView.removeFromSuperview()
            } else {
                guard let errorMessage = errorMessage else { return }
                print("errorMessage = \(errorMessage)")
            }
        }
    }

    
    @IBAction func websiteButtonPressed(_ sender: Any) {
        guard let webViewVC = storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as? WebViewVC else { return }
        webViewVC.urlString = gameDetailViewModel.getGameWebsite()
        navigationController?.pushViewController(webViewVC, animated: true)
    }
    
    
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        //favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
    }
    
}

extension GameDetailVC: GameDetailViewModelDelegate {
    func gameLoaded() {
        indicator.stopAnimating()
        guard let url = gameDetailViewModel.getGameImageUrl() else { return }
        gameImage.kf.setImage(with: url)
        gameTitle.text       = gameDetailViewModel.getGameTitle()
        gameRating.attributedText = configureLabelWithIcon(labelText: String(gameDetailViewModel.getGameRating()), icon: "star.fill")
        gameReleased.attributedText = configureLabelWithIcon(labelText: gameDetailViewModel.getGameReleased(), icon: "calendar")
        gameDescription.text = gameDetailViewModel.getGameDescription()
        gameDescription.isEditable = false
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
