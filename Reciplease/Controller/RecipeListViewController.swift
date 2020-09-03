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

extension RecipeListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = recipes?.all.count else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeTableViewCell
        guard let recipe = recipes?.all[indexPath.row] else { return RecipeTableViewCell() }
        cell.titleLabel?.text = recipe.title
        cell.ingredientsLabel.text = SettingService.ingredients.joined(separator: ", ")
        
        let placeholderImage = UIImage(named: "placeholder")
        cell.backgroundImage?.image = placeholderImage
        AF.download(recipe.image).responseData { (response) in
            guard let data = response.value else { return }
            if let updateCell = tableView.cellForRow(at: indexPath) as? RecipeTableViewCell {
                updateCell.backgroundImage?.image = UIImage(data: data)
            }
        }
        return cell
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToDetail" {
            let destination = segue.destination as! DetailViewController
            guard let recipe = recipes?.all[tableView.indexPathForSelectedRow!.row] else { return }
            destination.recipe = recipe
        }
    }
    
}
