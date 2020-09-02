//
//  Recipe.swift
//  Reciplease
//
//  Created by Ludovic HENRY on 01/09/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import Foundation

struct Recipe: Decodable {
    let id: String
    let title: String
    let ingredients: [String]
    let duration: Int
    let image: String
    let directions: String
    
    enum CodingKeys: String, CodingKey {
        case id = "uri"
        case title = "label"
        case ingredients = "ingredientLines"
        case duration = "totalTime"
        case image
        case directions = "url"
    }
}
