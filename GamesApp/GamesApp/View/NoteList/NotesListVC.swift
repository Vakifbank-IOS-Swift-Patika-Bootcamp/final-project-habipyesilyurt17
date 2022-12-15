//
//  NotesListVC.swift
//  GamesApp
//
//  Created by Habip Yeşilyurt on 15.12.2022.
//

import UIKit

final class NotesListVC: BaseVC {
    @IBOutlet weak var notesTableView: UITableView!

    private let floatingButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))

        button.backgroundColor = .systemPink
        
        let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal )
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
        button.layer.cornerRadius = 30
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(floatingButton)
        floatingButton.addTarget(self, action: #selector(addNoteButtonPressed), for: .touchUpInside)
    }
    
    @objc func addNoteButtonPressed() {

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        floatingButton.frame = CGRect(
            x: view.frame.size.width - 70,
            y: view.frame.size.height - 150,
            width: 60,
            height: 60)
    }
    

}
