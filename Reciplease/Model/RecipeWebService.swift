//
//  RecipeWebService.swift
//  Reciplease
//
//  Created by Ludovic HENRY on 01/09/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import Foundation
import Alamofire

final class RecipeWebService {
    private var session: AlamofireSession = WebServiceSession()

    convenience init(session: AlamofireSession) {
        self.init()
        self.session = session
    }

    func fetchRecipes(keywords: [String], callback: @escaping ([Recipe]?) -> Void ) {
        guard keywords.count > 0 else {
            callback(nil)
            return
        }
        var recipes: [Recipe] = []
        session.fetchRecipes(keywords: keywords) { (response) in
            guard response.response?.statusCode == 200 else {
                callback(nil)
                return
            }
            guard let result = response.value else {
                callback(nil)
                return
            }
            recipes = self.resultToRecipes(result: result)
            callback(recipes)
        }
    }
    
    private func resultToRecipes(result: ResultRequest) -> [Recipe] {
        var recipes: [Recipe] = []
        for hit in result.hits {
            let recipe = Recipe(directions: hit.recipe.url, duration: hit.recipe.totalTime,
                                id: hit.recipe.uri, image: hit.recipe.image, calories: hit.recipe.calories,
                                ingredients: hit.recipe.ingredientLines, title: hit.recipe.label)
            recipes.append(recipe)
        }
        return recipes
    }
}


