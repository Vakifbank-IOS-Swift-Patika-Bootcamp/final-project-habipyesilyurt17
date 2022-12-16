//
//  NotesTableViewCell.swift
//  GamesApp
//
//  Created by Habip Yeşilyurt on 15.12.2022.
//

import UIKit

final class NotesTableViewCell: UITableViewCell {
    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    
    func configureCell(model: Notes) {
        gameLabel.text = model.gameName
        noteLabel.text = model.note
    }
}
