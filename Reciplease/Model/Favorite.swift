//
//  Favorite.swift
//  Reciplease
//
//  Created by Ludovic HENRY on 02/09/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import Foundation
import CoreData

class Favorite: NSManagedObject {
    static var all: [Favorite] {
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        guard let result = try? AppDelegate.viewContext.fetch(request) else { return [] }
        return result
    }

    func newObject(recipe: Recipe) {
        self.directions = recipe.directions
        self.duration = Int16(recipe.duration)
        self.id = recipe.id
        self.imageData = recipe.imageData
        self.imageUrl = recipe.imageUrl
        self.ingredients = recipe.ingredients
        self.query = recipe.query
        self.title = recipe.title
    }
    
    static func remove(id: String) -> Bool {
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        guard let favoriteResult = try? AppDelegate.viewContext.fetch(request), favoriteResult.count > 0 else { return false}
        let favorite = favoriteResult[0]
        AppDelegate.viewContext.delete(favorite)
        return true
    }
    
}
