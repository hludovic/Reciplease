//
//  RecipeWebServiceTests.swift
//  RecipleaseTests
//
//  Created by Ludovic HENRY on 06/12/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import XCTest
import Alamofire
@testable import Reciplease

class RecipeWebServiceTests: XCTestCase {

    func testFetchRecipesShouldPostFailedCallbackIfHTTPResponseFail() {
        let session: AlamofireSession = MockWebServiceSession(dataResult: FakeResponseData.responseData, result: FakeResponseData.resultOK, urlResponse: FakeResponseData.responseKO!)
        let ingredients: [String] = ["egg", "sugar"]

        let webService = RecipeWebService(session: session)
        webService.fetchRecipes(keywords: ingredients) { (recipes) in
            XCTAssertNil(recipes)
        }
    }

    func testFetchRecipesShouldPostFailedCallbackIfRequestContainsNoIngredients() {
        let session: AlamofireSession = MockWebServiceSession(dataResult: FakeResponseData.responseData, result: FakeResponseData.resultOK, urlResponse: FakeResponseData.responseOK!)
        let ingredients: [String] = []

        let webService = RecipeWebService(session: session)
        webService.fetchRecipes(keywords: ingredients) { (recipes) in
            XCTAssertNil(recipes)
        }
    }

    func testFetchRecipesShouldPostFailedCallbackIfWrongData() {
        let session: AlamofireSession = MockWebServiceSession(dataResult: FakeResponseData.incorrectData!, result: FakeResponseData.resultKO, urlResponse: FakeResponseData.responseOK!)
        let ingredients: [String] = ["egg", "sugar"]

        let webService = RecipeWebService(session: session)
        webService.fetchRecipes(keywords: ingredients) { (recipes) in
            XCTAssertNil(recipes)
        }
    }

    func testFetchRecipesShouldPostRightCallbackIfAllIsCorrect() {
        let session: AlamofireSession = MockWebServiceSession(dataResult: FakeResponseData.responseData, result: FakeResponseData.resultOK, urlResponse: FakeResponseData.responseOK!)
        let ingredients: [String] = ["egg", "sugar"]

        let webService = RecipeWebService(session: session)
        webService.fetchRecipes(keywords: ingredients) { (recipes) in
            XCTAssertEqual("Sugar Puffs", recipes![0].title)
            XCTAssertEqual("Sugar Cookies", recipes!.last!.title)
            XCTAssertEqual(10, recipes!.count)
        }
    }
}

final class MockWebServiceSession: AlamofireSession {
    private let dataResult: Data
    private let urlResponse: HTTPURLResponse?
    private let result: Result<ResultRequest, AFError>
    
    init(dataResult: Data, result: Result<ResultRequest, AFError>, urlResponse: HTTPURLResponse) {
        self.dataResult = dataResult
        self.urlResponse = urlResponse
        self.result = result
    }

    func fetchRecipes(keywords: [String], callback: @escaping (DataResponse<ResultRequest, AFError>) -> Void) {
        let urlRequest = URLRequest(url: URL(string: "https://google.fr")!)
        let dataResponse = DataResponse(request: urlRequest, response: urlResponse, data: dataResult, metrics: nil, serializationDuration: TimeInterval(), result: result)
        callback(dataResponse)
    }
}

