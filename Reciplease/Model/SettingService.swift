//
//  SettingService.swift
//  Reciplease
//
//  Created by Ludovic HENRY on 30/08/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import Foundation

class SettingService {
    private struct Keys {
        static let ingredients = "ingredients"
    }
    
    static var ingredients: [String] {
        get {
            UserDefaults.standard.array(forKey: Keys.ingredients) as? [String] ?? []
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.ingredients)
        }
    }
}
