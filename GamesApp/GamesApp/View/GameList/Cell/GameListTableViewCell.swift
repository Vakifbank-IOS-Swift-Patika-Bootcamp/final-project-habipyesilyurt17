//
//  GameListTableViewCell.swift
//  GamesApp
//
//  Created by Habip Yeşilyurt on 10.12.2022.
//

import UIKit
import Kingfisher


final class GameListTableViewCell: UITableViewCell {
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameTitle: UILabel!
    
    func configureCell(model: Game) {
        gameTitle.text = model.name
        guard let url = URL(string: model.backgroundImage) else { return }
        gameImage.kf.setImage(with: url)
    }
    
    override func prepareForReuse() {
        gameImage.image = nil
    }
}
