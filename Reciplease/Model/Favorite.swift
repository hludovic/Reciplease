//
//  Favorite.swift
//  Reciplease
//
//  Created by Ludovic HENRY on 02/09/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import Foundation
import CoreData

class Favorite: NSManagedObject {
    static var all: [Favorite] {
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        guard let result = try? AppDelegate.viewContext.fetch(request) else { return [] }
        return result
    }
}
