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
    
    // MARK: - IBOutlet Properties
    @IBOutlet weak var tableView: UITableView!
    private enum Mode { case search, favorite }
    
    // MARK: - Properties
    private let cache = NSCache<NSString,UIImage>()
    private var mode: Mode = .search
    var recipes: [Recipe] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if tabBarController?.selectedViewController?.tabBarItem.tag == 1 {
            mode = .favorite
        }

        switch mode {
        case .favorite:
            title = "Favorite"
            loadFavorites()
            tableView.reloadData()
        case .search:
            title = "Reciplease"
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if mode == .favorite {
            loadFavorites()
            tableView.reloadData()
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

// MARK: - UITableViewDataSource
extension RecipeTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeTableViewCell
        fillACell(cell: cell, indexPath: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard mode == .favorite else { return }
        if editingStyle == .delete {
            guard Favorite.remove(id: recipes[indexPath.row].id) else { return }
            recipes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if mode == .favorite {
            return true
        } else {
            return false
        }
    }

}

// MARK: - Private Methods
private extension RecipeTableViewController {
    func loadFavorites() {
        let favorites = Favorite.all
        var tab: [Recipe] = []
        for favorite in favorites {
            let recipe = Recipe(favorite: favorite)
            tab.append(recipe)
        }
        recipes = tab
    }

    func fillACell(cell: RecipeTableViewCell, indexPath: IndexPath) {
        let recipe = recipes[indexPath.row]
        cell.titleLabel?.text = recipe.title
        cell.ingredientsLabel.text = recipe.query
        cell.likesLabel.text = "_ _ _"
        cell.timeLabel.text = "\(recipe.duration)m"
        cell.backgroundImage.image = UIImage(named: "placeholder")
        if let image = recipe.imageData {
            cell.backgroundImage.image = UIImage(data: image)
        } else {
            if let image: UIImage = cache.object(forKey: recipe.imageUrl as NSString) {
                cell.backgroundImage.image = image
                recipe.setImageData(data: image.pngData())
            } else {
                AF.download(recipe.imageUrl).responseData { (response) in
                    guard let data = response.value, let image = UIImage(data: data)  else {
                        return
                    }
                    self.cache.setObject(image, forKey: NSString(string: recipe.imageUrl))
                    if let updatedCell = self.tableView.cellForRow(at: indexPath) as? RecipeTableViewCell {
                        updatedCell.backgroundImage.image = image
                        recipe.setImageData(data: image.pngData())
                    }
                }
            }
        }
    }
}
