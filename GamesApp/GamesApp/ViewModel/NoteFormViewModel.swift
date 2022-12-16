//
//  NoteFormViewModel.swift
//  GamesApp
//
//  Created by Habip Yeşilyurt on 15.12.2022.
//

import Foundation

protocol NoteFormViewModelProtocol {
    var delegate: NoteListViewModelDelegate? { get set }
    func newOrEditForm(formType: String, gameText: String?, noteText: String?, games: [Game]?, selectedNote: Notes?, completion: @escaping (_ isSuccess: Bool, String?) -> ())
}

final class NoteFormViewModel: NoteFormViewModelProtocol {
    weak var delegate: NoteListViewModelDelegate?

    func newOrEditForm(formType: String, gameText: String?, noteText: String?, games: [Game]?, selectedNote: Notes?, completion: @escaping (Bool, String?) -> ()) {
        let contextNote = Notes(context: NotesManager.shared.context)
        if let name = gameText {
            contextNote.setValue(name, forKey: "gameName")
        }
        if let note = noteText {
            contextNote.setValue(note, forKey: "note")
        }
        if contextNote.gameName != "" && contextNote.note != "" {
            if formType == "Edit Form" {
                editNote(contextNote: contextNote, choosenNote: selectedNote) { isSuccess, editError in
                    if isSuccess {
                        completion(true, nil)
                    } else {
                        completion(false, editError)
                    }
                }
            } else {
                guard let games = games else { return }
                newNote(contextNote: contextNote, games: games) { isSuccess, createError in
                    if isSuccess {
                        completion(true, nil)
                    } else {
                        completion(false, createError)
                    }
                }
            }
        } else {
            completion(false, "Inputs can not be empty!")
        }
    }
    
    private func editNote(contextNote: Notes, choosenNote: Notes?, completion: @escaping (Bool, String?) -> ()) {
        guard let selectedNote = choosenNote else { return }
        contextNote.id = selectedNote.id
        contextNote.createdAt = selectedNote.createdAt
        NotesManager.shared.updateData(id: Int(selectedNote.id), updatedNote: contextNote) { isSuccess, updateError in
            if isSuccess {
                NotificationCenter.default.post(name: NSNotification.Name("updateData"), object: nil)
                completion(true, nil)
            } else {
                completion(false, updateError.rawValue)
            }
        }
    }
    
    private func newNote(contextNote: Notes, games: [Game], completion: @escaping (Bool, String?) -> ()) {
        contextNote.setValue(UUID().hashValue, forKey: "id")
        contextNote.setValue(Date(), forKey: "createdAt")
        NotesManager.shared.saveData(data: contextNote) { isSuccess, saveError in
            if isSuccess {
                NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
                completion(true, nil)
            } else {
                completion(false, saveError.rawValue)
            }
        }
    }
}
