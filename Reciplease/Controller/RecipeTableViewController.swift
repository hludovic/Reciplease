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
    enum Mode { case search, favorite }
    let cache = NSCache<NSString,UIImage>()
    @IBOutlet weak var tableView: UITableView!
    var recipes: [Recipe] = []
    var mode: Mode = .search

    override func viewDidLoad() {
        super.viewDidLoad()
        if tabBarController?.selectedViewController?.tabBarItem.tag == 1 {
            mode = .favorite
        }
        commonInit()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if mode == .favorite {
            recipes = Favorite.allRecipes
            tableView.reloadData()
        }
    }

    func commonInit() {
        switch mode {
        case .favorite:
            title = "Favorite"
            recipes = Favorite.allRecipes
            tableView.reloadData()
        case .search:
            title = "Reciplease"
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

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard mode == .favorite else { return }
        if editingStyle == .delete {
            let favorite = Favorite.all[indexPath.row]
            AppDelegate.viewContext.delete(favorite)
            recipes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            try? AppDelegate.viewContext.save()
            print("delete")
        }
    }

    private func fillACell(cell: RecipeTableViewCell, indexPath: IndexPath) {
        let recipe = recipes[indexPath.row]
        cell.titleLabel?.text = recipe.title
        cell.ingredientsLabel.text = recipe.query
        cell.likesLabel.text = "_ _ _"
        cell.timeLabel.text = "\(recipe.duration)m"
        
        cell.backgroundImage.image = UIImage(named: "placeholder")
        loadImage(url: recipe.imageUrl) { (image) in
            cell.backgroundImage.image = image
            recipe.setImageData(data: image.pngData())
        }
    }

    func loadImage(url: String, callback: @escaping (UIImage) -> Void) {
        if let cachedImage: UIImage = cache.object(forKey: url as NSString) {
            callback(cachedImage)
        } else {
            AF.download(url).responseData { (response) in
                guard let data = response.value, let image = UIImage(data: data)  else {
                    callback(UIImage(named: "placeholder")!)
                    return
                }
                self.cache.setObject(image, forKey: NSString(string: url))
                callback(image)
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
