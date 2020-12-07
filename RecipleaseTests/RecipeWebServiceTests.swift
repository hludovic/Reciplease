//
//  RecipeWebServiceTests.swift
//  RecipleaseTests
//
//  Created by Ludovic HENRY on 06/12/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import XCTest
@testable import Reciplease

class RecipeWebServiceTests: XCTestCase {

    func testWhenRequestRecipesThentThResultIsLoaded() {
        let webService: WebServiceable = FakeRecipeWebService()
        let ingredients: [String] = ["egg", "sugar"]
        webService.fetchRecipes(keywords: ingredients) { (recipes) in
            XCTAssertEqual("Sugar Puffs", recipes![0].title)
            XCTAssertEqual("Sugar Cookies", recipes!.last!.title)
            XCTAssertEqual(10, recipes!.count)
        }
    }
}


final class FakeRecipeWebService: WebServiceable {
    var success: Bool = true
    private var resultRequest: ResultRequest {
        let bundle = Bundle(for: RecipeWebServiceTests.self)
        let url = bundle.url(forResource: "ResultRequest", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return try! JSONDecoder().decode(ResultRequest.self, from: data)
    }

    func fetchRecipes(keywords: [String], callback: @escaping([Recipe]?) -> Void ) {
        let recipes = resultToRecipes(result: resultRequest)
        success ? callback(recipes) : callback(nil)
    }
    
    
}

