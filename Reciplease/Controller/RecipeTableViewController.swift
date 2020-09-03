//
//  RecipeListViewController.swift
//  Reciplease
//
//  Created by Ludovic HENRY on 30/08/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import UIKit
import Alamofire

class RecipeTableViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var recipes: [Recipe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if tabBarController?.selectedViewController?.tabBarItem.tag == 1 {
            title = "Favorite"
            for favorite in  Favorite.all {
                let recipe = Recipe(favorite: favorite)
                recipes.append(recipe)
            }
        }
    }
}

extension RecipeTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeTableViewCell
        fillACell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    private func fillACell(cell: RecipeTableViewCell, indexPath: IndexPath) {
        let recipe = recipes[indexPath.row]
        cell.titleLabel?.text = recipe.title
        cell.ingredientsLabel.text = recipe.ingredients
        
        let placeholderImage = UIImage(named: "placeholder")
        cell.backgroundImage.image = placeholderImage
        
        AF.download(recipe.imageUrl).responseData { (response) in
            guard let data = response.value else { return }
            if let updateCell = self.tableView.cellForRow(at: indexPath) as? RecipeTableViewCell {
                recipe.setImageData(data: data)
                updateCell.backgroundImage?.image = UIImage(data: data)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToDetail" {
            let destination = segue.destination as! DetailViewController
            let recipe = recipes[tableView.indexPathForSelectedRow!.row]
            destination.recipe = recipe
        }
    }
    
}
