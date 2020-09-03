//
//  RecipeWebService.swift
//  Reciplease
//
//  Created by Ludovic HENRY on 01/09/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import Foundation
import Alamofire

class RecipeWebService {
    static func fetchRecipes(keywords: [String], callback: @escaping ([Recipe]?) -> Void ) {
        
        let url = "https://api.edamam.com/search"
        // API KEY
        let app_key = "_"
        let app_id = "_"
        // -------
        var favorites: [Recipe] = []
        let q: String = keywords.joined(separator: ", ")        
        let parameters: [String: String] = [ "app_key": app_key, "app_id": app_id, "q": q ]
        AF.request(url, method: .get, parameters: parameters)
            .validate()
            .responseDecodable(of: result.self) { (response) in
                guard let result = response.value else {
                    callback(nil)
                    return
                }
                for hit in result.hits {
                    let favorite = Recipe(context: AppDelegate.viewContext)
                    favorite.directions = hit.recipe.directions
                    favorite.duration = Int16(hit.recipe.duration)
                    favorite.id = hit.recipe.id
                    favorite.imageUrl = hit.recipe.image
                    favorite.ingredients = "- " + hit.recipe.ingredients.joined(separator: "\n- ")
                    favorite.query = SettingService.ingredients.joined(separator: ", ")
                    favorite.title = hit.recipe.title
                    favorites.append(favorite)
                }
                callback(favorites)
        }
    }
}


struct result: Decodable {
    let count: Int
    let hits: [Hit]
}

struct Hit: Decodable {
    let recipe: RecipeResult
}

struct RecipeResult: Decodable {
    let id: String
    let title: String
    let ingredients: [String]
    let duration: Int
    let image: String
    let directions: String
    
    enum CodingKeys: String, CodingKey {
        case id = "uri"
        case title = "label"
        case ingredients = "ingredientLines"
        case duration = "totalTime"
        case image
        case directions = "url"
    }
}
