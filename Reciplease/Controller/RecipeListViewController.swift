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
    var recipes: [Recipe] = []
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension RecipeListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeTableViewCell
        fillACell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    private func fillACell(cell: RecipeTableViewCell, indexPath: IndexPath) {
        let data = recipes[indexPath.row]
        guard let titleLabel = data.title, let ingredients = data.query, let url = data.imageUrl else { return }
        
        cell.titleLabel?.text = titleLabel
        cell.ingredientsLabel.text = ingredients
        
        let placeholderImage = UIImage(named: "placeholder")
        cell.backgroundImage.image = placeholderImage
        
        AF.download(url).responseData { (response) in
            guard let data = response.value else { return }
            if let updateCell = self.tableView.cellForRow(at: indexPath) as? RecipeTableViewCell {
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
