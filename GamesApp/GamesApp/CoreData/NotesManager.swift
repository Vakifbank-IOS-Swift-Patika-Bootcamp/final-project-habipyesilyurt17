//
//  NotesManager.swift
//  GamesApp
//
//  Created by Habip Yeşilyurt on 15.12.2022.
//

import UIKit
import CoreData

final class NotesManager: CoreDataProtocol {
    static let shared = NotesManager()
    typealias T = Notes
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func saveData(data: Notes, completion: @escaping (Bool, CoreDataError) -> ()) {
        do {
            try self.context.save()
            completion(true, .noError)
        } catch {
            completion(false, .savingError)
        }
    }
    
    func fetchData(completion: @escaping ([Notes]?, CoreDataError) -> ()) {
        let fetchRequest = NSFetchRequest<Notes>(entityName: "Notes")
        let sortByCreatedAt = NSSortDescriptor(key: "createdAt", ascending: false)
        fetchRequest.sortDescriptors = [sortByCreatedAt]
        do {
            let notes = try context.fetch(fetchRequest)
            if notes.count > 0 {
                completion(notes, .noError)
            } else {
                completion(nil, .dataError)
            }
        } catch {
            completion(nil, .fetchingError)
        }
    }
    
    func deleteData(id: Int, completion: @escaping (Bool, CoreDataError) -> ()) {
        let fetchRequest = NSFetchRequest<Notes>(entityName: "Notes")
        fetchRequest.predicate = NSPredicate(format: "id = %@", String(id))
        do {
            if let result = try context.fetch(fetchRequest).first {
                context.delete(result)
                try context.save()
                completion(true, .noError)
            }
        } catch {
            completion(false, .removingError)
        }
    }
    
    func updateData(id: Int, updatedNote: Notes, completion: @escaping (_ isSuccess: Bool, CoreDataError)->()) {
        let fetchRequest = NSFetchRequest<Notes>(entityName: "Notes")
        fetchRequest.predicate = NSPredicate(format: "id = %@", String(id))
        do {
            let results = try  context.fetch(fetchRequest)
            if results.count == 1 {
                let objectUpdate = results[0] as NSManagedObject
                if objectUpdate.value(forKey: "gameName") as? String != updatedNote.gameName {
                    objectUpdate.setValue(updatedNote.gameName, forKey: "gameName")
                }
                if objectUpdate.value(forKey: "note") as? String != updatedNote.note {
                    objectUpdate.setValue(updatedNote.note, forKey: "note")
                }
                do {
                    try context.save()
                    completion(true, .noError)
                } catch {
                    print("error: \(error.localizedDescription)")
                    completion(false, .savingError)
                }
            }
        } catch {
            print("error: \(error.localizedDescription)")
            completion(false, .fetchingError)
        }
    }

}
