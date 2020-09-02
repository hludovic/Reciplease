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
        
        // Do any additional setup after loading the view.
    }
    
    
    func fetchRecipes(){
        let keywords = ["chicken", "egg"]
        RecipeWebService.fetchRecipes(keywords: keywords) { (recipes) in
            guard let recipes = recipes else {
                print("ERROR")
                return
            }
            self.recipes = recipes
            self.tableView.reloadData()
        }
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
        return cell
    }
    
    
}
