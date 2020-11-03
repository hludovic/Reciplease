//
//  FavoriteTests.swift
//  RecipleaseTests
//
//  Created by Ludovic HENRY on 06/10/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import XCTest
@testable import Reciplease

class FavoriteTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    func testOk() {
        let recipes = loadRecipe()
        
        let favorite = Favorite(context: FakeCoreDataStack.testableContext)
        favorite.newObject(recipe: recipes[0])
        let fav2 = Favorite(context: FakeCoreDataStack.testableContext)
        fav2.newObject(recipe: recipes[1])
        
        try? FakeCoreDataStack.testableContext.save()
        
        print("😇 \(Favorite.all(context: FakeCoreDataStack.testableContext).count)")
        print("😇 \(Favorite.all(context: FakeCoreDataStack.testableContext)[0].title!)")
    }
    
    
    func loadRecipe() -> [Recipe] {
        let bundle = Bundle(for: FavoriteTests.self)
        let url = bundle.url(forResource: "ResultRequest", withExtension: "json")!
        var recipes:[Recipe] = []
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode(RecipeWebService.ResultRequest.self, from: data)
            
            for hit in jsonData.hits {
                let recipe = Recipe(directions: hit.recipe.url, duration: hit.recipe.totalTime,
                                  id: hit.recipe.uri, image: hit.recipe.image,
                                  ingredients: hit.recipe.ingredientLines, title: hit.recipe.label)
                recipes.append(recipe)
            }
        } catch {
            print("Error")
        }
        return recipes
    }
}
