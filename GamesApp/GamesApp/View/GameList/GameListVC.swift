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
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func gamesOrderButtonPressed(_ sender: Any) {
    }
}
