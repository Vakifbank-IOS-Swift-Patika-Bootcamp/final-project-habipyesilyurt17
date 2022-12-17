//
//  GameFilterVC.swift
//  GamesApp
//
//  Created by Habip Yeşilyurt on 17.12.2022.
//

import UIKit

final class GameFilterVC: UIViewController, UISheetPresentationControllerDelegate  {
    override var sheetPresentationController: UISheetPresentationController {
        presentationController as! UISheetPresentationController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        sheetPresentationController.delegate = self
        sheetPresentationController.selectedDetentIdentifier = .medium
        sheetPresentationController.prefersGrabberVisible = true
        sheetPresentationController.preferredCornerRadius = 24
        sheetPresentationController.detents = [ .medium() ]
    }
    
    @IBAction func getAllGamesFilterButtonPressed(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("getAllGames"), object: nil)
    }
    
    @IBAction func upcomingGamesFilterButtonPressed(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("upcomingGames"), object: nil)
    }
    
    @IBAction func topRatedGamesFilterButtonPressed(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("fetchTopRatedGames"), object: nil)
    }
    
}
