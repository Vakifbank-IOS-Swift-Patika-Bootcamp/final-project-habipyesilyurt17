//
//  NoteListViewModel.swift
//  GamesApp
//
//  Created by Habip Yeşilyurt on 15.12.2022.
//

import Foundation

protocol NoteListViewModelProtocol {
    var delegate: NoteListViewModelDelegate? { get set }
    func fetchNotes(completion: @escaping (_ isSuccess: Bool, CoreDataError?) -> ())
    func deleteNote(noteId: Int, completion: @escaping (_ isSuccess: Bool, CoreDataError?) -> ())
    func getNoteCount() -> Int
    func getNote(at index: Int) -> Notes?
    func fetchGames(isPagination: Bool, completion: @escaping (String?) -> ())
    func getGameNames() -> [String]
    func getGames() -> [Game]?
}

protocol NoteListViewModelDelegate: AnyObject {
    func notesLoaded()
}

final class NoteListViewModel: NoteListViewModelProtocol {
    weak var delegate: NoteListViewModelDelegate?
    private var notes: [Notes]?
    private var gameNames: [String]?
    private var games: [Game]? {
        didSet {
            guard let games = games else { return }
            let nameArr = games.map { $0.name }
            gameNames = Set(nameArr).sorted(by: <)
        }
    }
    
    func fetchNotes(completion: @escaping (Bool, CoreDataError?) -> ()) {
        NotesManager.shared.fetchData { [weak self] notes, fetchError in
            guard let self = self else { return }
            if fetchError == .noError {
                guard let notes = notes else { return }
                self.notes = notes
                self.delegate?.notesLoaded()
                completion(true, nil)
            } else {
                if self.getNoteCount() == 1 {
                    self.notes?.removeAll()
                }
                self.delegate?.notesLoaded()
                completion(false, .fetchingError)
            }
        }
    }
    
    func deleteNote(noteId: Int, completion: @escaping (Bool, CoreDataError?) -> ()) {
        NotesManager.shared.deleteData(id: noteId, completion: { isSuccess, error in
            if isSuccess {
                completion(true, nil)
            } else {
                completion(false, .removingError)
            }
        })
    }
    
    func getNoteCount() -> Int {
        notes?.count ?? 0
    }
    
    func getNote(at index: Int) -> Notes? {
        notes?[index]
    }
    
    func fetchGames(isPagination: Bool, completion: @escaping (String?) -> ()) {
        NetworkManager.shared.getAllGames(isPagination: false, nextPage: nil) { [weak self] games, next, error in
            guard let self = self else { return }
            if error == nil {
                self.games = games
            }
        }
    }
    
    func getGameNames() -> [String] {
        gameNames ?? []
    }
    
    func getGames() -> [Game]? {
        games
    }
        
}
