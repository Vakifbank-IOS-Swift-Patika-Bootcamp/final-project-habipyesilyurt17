//
//  NotesListVC.swift
//  GamesApp
//
//  Created by Habip Yeşilyurt on 15.12.2022.
//

import UIKit

final class NotesListVC: BaseVC {
    @IBOutlet weak var notesTableView: UITableView!
    private var noteListViewModel: NoteListViewModelProtocol = NoteListViewModel()
    
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
        noteListViewModel.delegate = self
        configureNotesTableView()
        view.addSubview(floatingButton)
        floatingButton.addTarget(self, action: #selector(addNoteButtonPressed), for: .touchUpInside)
        noteListViewModel.fetchGames(isPagination: false) { error in
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getNotes()
        NotificationCenter.default.addObserver(self, selector: #selector(getNotes), name: NSNotification.Name(rawValue: "newData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getNotes), name: NSNotification.Name(rawValue: "updateData"), object: nil)
    }
    
    @objc private func getNotes() {
        noteListViewModel.fetchNotes { [weak self] isSuccess, fetchError in
            guard let self = self else { return }
            if !isSuccess {
                guard let fetchError = fetchError else { return }
                self.showErrorAlert(message: fetchError.rawValue) {
                }
            }
        }
    }
    
    private func configureNotesTableView() {
        notesTableView.dataSource = self
        notesTableView.delegate   = self
        notesTableView.register(UINib(nibName: "NotesTableViewCell", bundle: nil), forCellReuseIdentifier: "NotesCell")
        notesTableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    @objc func addNoteButtonPressed() {
        let noteFormVC = self.storyboard?.instantiateViewController(withIdentifier: "NoteFormVC") as? NoteFormVC
        guard let noteFormVC = noteFormVC else { return }
        noteFormVC.choosenFormLabel = "Add Form"
        noteFormVC.games = noteListViewModel.getGames()
        noteFormVC.gameNames = noteListViewModel.getGameNames()
        self.present(noteFormVC, animated: true)
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

extension NotesListVC: NoteListViewModelDelegate {
    func notesLoaded() {
        self.indicator.stopAnimating()
        self.notesTableView.reloadData()
    }
}

extension NotesListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noteListViewModel.getNoteCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotesCell") as? NotesTableViewCell, let model = noteListViewModel.getNote(at: indexPath.row) else { return UITableViewCell() }
        cell.configureCell(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: nil) { [weak self] action, view, complete in
            guard let self = self else { return }
            let selectedNote = self.noteListViewModel.getNote(at: indexPath.row)
            guard let noteFormVC = self.storyboard?.instantiateViewController(withIdentifier: "NoteFormVC") as? NoteFormVC else { return }
            noteFormVC.choosenFormLabel = "Edit Form"
            noteFormVC.choosenNote = selectedNote
            noteFormVC.games = self.noteListViewModel.getGames()
            noteFormVC.gameNames = self.noteListViewModel.getGameNames()
            self.present(noteFormVC, animated: true)
        }
        
        let deleteAction = UIContextualAction(style: .normal, title: nil) { [weak self] action, view, complete in
            guard let self = self else { return }
            guard let noteId = self.noteListViewModel.getNote(at: indexPath.row)?.id else { return }
            self.noteListViewModel.deleteNote(noteId: Int(noteId)) { isSuccess, deleteError in
                if isSuccess {
                    self.getNotes()
                } else {
                    guard let deleteError = deleteError else { return }
                    self.showErrorAlert(message: deleteError.rawValue) {
                    }
                }
            }
        }
        editAction.image = UIImage(systemName: "square.and.pencil")?.colored(in: .white)
        editAction.backgroundColor = .blue
        deleteAction.image = UIImage(systemName: "trash.fill")?.colored(in: .white)
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
