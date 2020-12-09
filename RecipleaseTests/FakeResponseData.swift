//
//  FakeResponseData.swift
//  RecipleaseTests
//
//  Created by Ludovic HENRY on 08/12/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import Foundation
import Alamofire
@testable import Reciplease

class FakeResponseData {
    static var responseData: Data {
        let bundle = Bundle(for: RecipeWebServiceTests.self)
        let url = bundle.url(forResource: "ResultRequest", withExtension: "json")!
        return try! Data(contentsOf: url)
    }

    static var incorrectData = "ErrorData".data(using: .utf8)

    static var jsonResponse: ResultRequest {
        return try! JSONDecoder().decode(ResultRequest.self, from: FakeResponseData.responseData)
    }

    static var correctRequestData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "Currency", withExtension: "json")!
        return try! Data(contentsOf: url)
    }

    static var responseOK = HTTPURLResponse(url: URL(string: "https://google.fr")!, statusCode: 200, httpVersion: nil, headerFields: nil)
    static var responseKO = HTTPURLResponse(url: URL(string: "https://google.fr")!, statusCode: 500, httpVersion: nil, headerFields: nil)

    static let resultOK = Result<ResultRequest, AFError>.success(jsonResponse)
    static let resultKO = Result<ResultRequest, AFError>.failure(AFError.responseSerializationFailed(reason: AFError.ResponseSerializationFailureReason.inputFileNil))
}
