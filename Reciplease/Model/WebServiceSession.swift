//
//  WebServiceSession.swift
//  Reciplease
//
//  Created by Ludovic HENRY on 07/12/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import Foundation
import Alamofire

protocol AlamofireSession {
    func fetchRecipes(keywords: [String], callback: @escaping (DataResponse<ResultRequest, AFError>) -> Void )
}

final class WebServiceSession: AlamofireSession {
    private let appKey = "" // API KEY
    private let appId = ""  // API ID
    private let url = "https://api.edamam.com/search"

    func fetchRecipes(keywords: [String], callback: @escaping (DataResponse<ResultRequest, AFError>) -> Void ) {
        let query: String = keywords.joined(separator: ", ")
        let parameters: [String: String] = [ "app_key": appKey, "app_id": appId, "q": query ]

        AF.request(url, method: .get, parameters: parameters)
            .responseDecodable(of: ResultRequest.self) { (response) in
                callback(response)
        }
    }
}
