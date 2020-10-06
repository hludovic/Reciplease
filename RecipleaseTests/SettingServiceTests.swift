//
//  SettingServiceTests.swift
//  RecipleaseTests
//
//  Created by Ludovic HENRY on 04/10/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import XCTest
@testable import Reciplease

class SettingServiceTests: XCTestCase {
    let ingredient = "testValue"

    override func setUp() {
        super.setUp()
        removeIngredientTest()
    }

    private func removeIngredientTest() {
        var index = SettingService.ingredients.firstIndex(of: ingredient)
        while index != nil {
            SettingService.ingredients.remove(at: index!)
            index = SettingService.ingredients.firstIndex(of: ingredient)
        }
    }

    func testWhenAddingIngredientThenItShouldBeInIngredientsList() {
        XCTAssertEqual(nil, SettingService.ingredients.firstIndex(of: ingredient))
        
        SettingService.ingredients.append(ingredient)
        
        let index = SettingService.ingredients.firstIndex(of: ingredient)
        XCTAssertNotNil(index)
        XCTAssertEqual(ingredient, SettingService.ingredients[index!])
    }

    func testWhenRemovingIngredientThenItShouldBeRemovedFromTheIngredientsList() {
        XCTAssertEqual(nil, SettingService.ingredients.firstIndex(of: ingredient))
        SettingService.ingredients.append(ingredient)
        
        let index = SettingService.ingredients.firstIndex(of: ingredient)
        SettingService.ingredients.remove(at: index!)
        
        XCTAssertEqual(nil, SettingService.ingredients.firstIndex(of: ingredient))
    }
}
