//
//  ResultRequest.swift
//  Reciplease
//
//  Created by Ludovic HENRY on 08/12/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import Foundation

struct ResultRequest: Decodable {
    let count: Int
    let hits: [Hit]
    struct Hit: Decodable {
        let recipe: RecipeResult
        struct RecipeResult: Decodable {
            let uri: String
            let label: String
            let calories: Double
            let ingredientLines: [String]
            let totalTime: Int
            let image: String
            let url: String
        }
    }
}
