//
//  FavoriteTests.swift
//  RecipleaseTests
//
//  Created by Ludovic HENRY on 06/10/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import XCTest
import CoreData
@testable import Reciplease

class FavoriteTests: XCTestCase {
    var testableContext: NSManagedObjectContext!
    
    var fakeRecipes:[Recipe] {
        let bundle = Bundle(for: FavoriteTests.self)
        let url = bundle.url(forResource: "ResultRequest", withExtension: "json")!
        let data = try? Data(contentsOf: url)
        let jsonData = try? JSONDecoder().decode(ResultRequest.self, from: data!)
        var recipes:[Recipe] = []
        for hit in jsonData!.hits {
            let recipe = Recipe(directions: hit.recipe.url, duration: hit.recipe.totalTime,
                                id: hit.recipe.uri, image: hit.recipe.image, calories: hit.recipe.calories,
                              ingredients: hit.recipe.ingredientLines, title: hit.recipe.label)
            recipes.append(recipe)
        }
        return recipes
    }

    override func setUp() {
        super.setUp()
        self.testableContext = loadTestableContext()
    }

    func loadTestableContext() -> NSManagedObjectContext {
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        let container = NSPersistentContainer(name: "Reciplease")
        container.persistentStoreDescriptions = [persistentStoreDescription]
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container.newBackgroundContext()
    }

    func testWhenSavingAFavoriteThenItShouldBeSaved() {
        XCTAssertEqual(0, Favorite.all(context: testableContext).count)
        
        let favorite1 = Favorite(context: testableContext)
        favorite1.newObject(recipe: fakeRecipes[6])
        try? testableContext.save()
        let favorite2 = Favorite(context: testableContext)
        favorite2.newObject(recipe: fakeRecipes[7])
        try? testableContext.save()
        
        XCTAssertEqual(2, Favorite.all(context: testableContext).count)
        XCTAssertEqual("Sugar Cookies", Favorite.all(context: testableContext)[0].title!)
        XCTAssertEqual("Sugar-Cookie Handprints", Favorite.all(context: testableContext)[1].title!)
    }
    
    func testWhenRemoveAFavoriteThenItShouldBeRemoved() {
        let favorite = Favorite(context: testableContext)
        favorite.newObject(recipe: fakeRecipes[4])
        XCTAssertEqual(1, Favorite.all(context: testableContext).count)

        XCTAssertTrue(Favorite.remove(id: fakeRecipes[4].id, context: testableContext))
        XCTAssertEqual(0, Favorite.all(context: testableContext).count)
    }
    
    
}
