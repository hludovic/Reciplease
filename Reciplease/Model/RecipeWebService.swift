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
    private static let app_key = "_" // API KEY
    private static let app_id = "_"  // API ID
    private static let url = "https://api.edamam.com/search"

    static func fetchRecipes(keywords: [String], callback: @escaping ([Recipe]?) -> Void ) {
        guard keywords.count > 0 else {
            callback(nil)
            return
        }
        var recipes: [Recipe] = []
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
                    let recipe = Recipe(directions: hit.recipe.url, duration: hit.recipe.totalTime,
                                    id: hit.recipe.uri, image: hit.recipe.image,
                                    ingredients: hit.recipe.ingredientLines, title: hit.recipe.label)
                    recipes.append(recipe)
                }
                callback(recipes)
        }
    }

    private struct result: Decodable {
        let count: Int
        let hits: [Hit]
        
        struct Hit: Decodable {
            let recipe: RecipeResult
            
            struct RecipeResult: Decodable {
                let uri: String
                let label: String
                let ingredientLines: [String]
                let totalTime: Int
                let image: String
                let url: String
            }
        }
    }
}

