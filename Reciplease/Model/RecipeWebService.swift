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
        guard keywords.count > 0 else {
            callback(nil)
            return
        }
        let url = "https://api.edamam.com/search"
        // API KEY
        let app_key = "_"
        let app_id = "_"
        // -------
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
                    let recipe = Recipe(result: hit.recipe)
                    recipes.append(recipe)
                }
                callback(recipes)
        }
    }
}

struct result: Decodable {
    let count: Int
    let hits: [Hit]
    
    struct Hit: Decodable {
        let recipe: RecipeResult
    }
}

struct RecipeResult: Decodable {
    let uri: String
    let label: String
    let ingredientLines: [String]
    let totalTime: Int
    let image: String
    let url: String
}
