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

    func testWhenRequestRecipesThentThResultIsLoaded() {
        let session: AlamofireSession = MockWebServiceSession(dataResult: FakeResponseData.responseData, urlResponse: FakeResponseData.responseOK!)
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
    private let result = Result<ResultRequest, AFError>.success(FakeResponseData.jsonResponse)

    init(dataResult: Data, urlResponse: HTTPURLResponse) {
        self.dataResult = dataResult
        self.urlResponse = urlResponse
    }
    
    func fetchRecipes(keywords: [String], callback: @escaping (DataResponse<ResultRequest, AFError>) -> Void) {
        let urlRequest = URLRequest(url: URL(string: "https://www.google.com/")!)
        let dataResponse = DataResponse(request: urlRequest, response: FakeResponseData.responseOK, data: dataResult, metrics: nil, serializationDuration: TimeInterval(), result: result)
        callback(dataResponse)
    }
}

