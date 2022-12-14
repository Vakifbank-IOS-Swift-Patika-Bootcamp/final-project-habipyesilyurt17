//
//  FavoriteGamesManager.swift
//  GamesApp
//
//  Created by Habip Yeşilyurt on 14.12.2022.
//

import UIKit
import CoreData

final class FavoriteGamesManager: CoreDataProtocol {
    static let shared = FavoriteGamesManager()
    typealias T = FavoriteGames
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveData(data: FavoriteGames, completion: @escaping (Bool, CoreDataError) -> ()) {
        do {
            try self.context.save()
            completion(true, .noError)
        } catch {
            completion(false, .savingError)
        }
    }
    
    func fetchData(id: Int, completion: @escaping (Result<[FavoriteGames], CoreDataError>) -> ()) {
        let fetchRequest = NSFetchRequest<FavoriteGames>(entityName: "FavoriteGames")
        let sortByCreatedAt = NSSortDescriptor(key: "createdAt", ascending: false)
        fetchRequest.sortDescriptors = [sortByCreatedAt]
        do {
            let games = try context.fetch(fetchRequest)
            if games.count > 0 {
                completion(.success(games))
            }
        } catch {
            completion(.failure(.fetchingError))
        }
    }
    
    func deleteData(id: Int, completion: @escaping (Bool, CoreDataError) -> ()) {
        let fetchRequest = NSFetchRequest<FavoriteGames>(entityName: "FavoriteGames")
        fetchRequest.predicate = NSPredicate(format: "gameId = %@", id)
        
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
}
