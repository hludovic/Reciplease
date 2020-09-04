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
    
    static var allRecipes: [Recipe] {
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        guard let favorites = try? AppDelegate.viewContext.fetch(request) else { return [] }

        var recipes: [Recipe] = []
        for favorite in favorites {
            let recipe = Recipe(favorite: favorite)
            recipes.append(recipe)
        }
        return recipes
    }
    
    static func isFavorite(recipe: Recipe) -> Bool {
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", recipe.id)
        guard let response = try? AppDelegate.viewContext.fetch(request) else { return false }
        if response.count > 0 {
            return true
        } else {
            return false
        }
    }
    
    func addRecipe(recipe: Recipe) {
        self.directions = recipe.directions
        self.duration = Int16(recipe.duration)
        self.id = recipe.id
        self.imageData = recipe.imageData
        self.imageUrl = recipe.imageUrl
        self.ingredients = recipe.ingredients
        self.query = recipe.query
        self.title = recipe.title
    }
    
}
