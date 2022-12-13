//
//  FavoriteGamesManager.swift
//  GamesApp
//
//  Created by Habip Yeşilyurt on 13.12.2022.
//

import UIKit
import CoreData

final class FavoriteGamesManager {
    static let shared = FavoriteGamesManager()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func fetchData() -> [FavoriteGames]? {
        var favoriteGames: [FavoriteGames] = []
        let fetchRequest = NSFetchRequest<FavoriteGames>(entityName: "FavoriteGames")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(FavoriteGames.favoriteDate), ascending: false)]
        do {
            favoriteGames = try self.context.fetch(FavoriteGames.fetchRequest())
        } catch {
            print("error: \(error.localizedDescription)")
        }
        return favoriteGames
    }
    
    func saveData(model: GameDetailModel) {
        let newFavoriteGame = FavoriteGames(context: context)
        newFavoriteGame.setValue(Date(), forKey: "favoriteDate")
        newFavoriteGame.setValue(model.id, forKey: "gameId")
        newFavoriteGame.setValue(model.name, forKey: "name")
        newFavoriteGame.setValue(model.rating, forKey: "rating")
        newFavoriteGame.setValue(model.released, forKey: "released")
        newFavoriteGame.setValue(model.descriptionRaw, forKey: "desc")
        newFavoriteGame.setValue(model.backgroundImage, forKey: "image")
        
        do {
            try self.context.save()
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
    
    func deleteData(index: String) {
        let fetchRequest = NSFetchRequest<FavoriteGames>(entityName: "FavoriteGames")
        let predicate = NSPredicate(format: "(gameId = %@)", index as CVarArg)
        fetchRequest.predicate = predicate

        do {
            let context = self.context
            let result = try context.fetch(fetchRequest).first
            
            if let result = result {
                context.delete(result)
                try context.save()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
