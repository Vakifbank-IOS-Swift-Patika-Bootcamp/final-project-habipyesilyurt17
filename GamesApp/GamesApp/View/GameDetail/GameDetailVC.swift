//
//  GameDetailVC.swift
//  GamesApp
//
//  Created by Habip Yeşilyurt on 12.12.2022.
//

import UIKit

final class GameDetailVC: UIViewController {
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var gameRating: UILabel!
    @IBOutlet weak var gameReleased: UILabel!
    @IBOutlet weak var gameWebsite: UILabel!
    @IBOutlet weak var gameDescription: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
