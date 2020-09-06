//
//  Recipe.swift
//  Reciplease
//
//  Created by Ludovic HENRY on 03/09/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import Foundation

class Recipe {
    let directions: String
    let duration: Int
    let id: String
    private(set) var imageData: Data?
    let imageUrl: String
    let ingredients: String
    let query: String
    let title: String
    let isFavorite: Bool
    
    init(result: RecipeResult) {
        self.directions = result.directions
        self.duration = result.duration
        self.id = result.id
        self.imageUrl = result.image
        self.ingredients = result.ingredients.joined(separator: "\n- ")
        self.query = SettingService.ingredients.joined(separator: ", ")
        self.title = result.title
        self.isFavorite = false
    }
    
    init(favorite: Favorite) {
        self.directions = favorite.directions!
        self.duration = Int(favorite.duration)
        self.id = favorite.id!
        self.imageUrl = favorite.imageUrl!
        self.ingredients = favorite.ingredients!
        self.query = favorite.query!
        self.title = favorite.title!
        self.isFavorite = true
        self.imageData = favorite.imageData
    }
    
    func setImageData(data: Data?) {
        self.imageData = data
    }
    
}
