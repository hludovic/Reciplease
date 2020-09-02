//
//  RecipeListViewController.swift
//  Reciplease
//
//  Created by Ludovic HENRY on 30/08/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import UIKit
import Alamofire

class RecipeListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var recipes: Recipes?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension RecipeListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = recipes?.all.count else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeTableViewCell
        guard let recipe = recipes?.all[indexPath.row] else { return RecipeTableViewCell() }
        cell.titleLabel.text = recipe.title
        cell.imageUrl = recipe.image
        return cell
    }
    
    
}
