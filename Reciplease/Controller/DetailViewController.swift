//
//  DetailViewController.swift
//  Reciplease
//
//  Created by Ludovic HENRY on 02/09/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import UIKit
import Alamofire

class DetailViewController: UIViewController {
    @IBOutlet weak var imageDetail: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var infoView: UIView!
    var recipe: Recipe?
    var favButton: UIBarButtonItem?
    var isFavorite: Bool = false {
        didSet {
            if isFavorite {
                let imageButton = UIImage(systemName: "star.fill")
                favButton?.image = imageButton
            } else {
                let imageButton = UIImage(systemName: "star")
                favButton?.image = imageButton
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Reciplease"
        addFavoriteButton()
        commonInit()
        goButton.layer.cornerRadius = 3
        infoView.layer.cornerRadius = 3
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func addFavoriteButton() {
        let imageButton = UIImage(systemName: "star")
        favButton = UIBarButtonItem(image: imageButton, style: .plain, target: self, action: #selector(saveToFavorite))
        navigationItem.rightBarButtonItem = favButton
    }
    
    private func commonInit() {
        
        if Favorite.isFavorite(recipe: recipe!) {
            isFavorite = true
        }
        
        guard let recipe = recipe else { return }
        titleLabel.text = recipe.title
        ingredientsTextView.text = recipe.ingredients
        if let imageData = recipe.imageData {
            imageDetail.image = UIImage(data: imageData)

        } else {
            imageDetail.image = UIImage(named: "placeholder")
        }
    }
    
    @objc func saveToFavorite() {
        if !isFavorite {
            do {
                let favorite = Favorite(context: AppDelegate.viewContext)
                favorite.addRecipe(recipe: recipe!)
                try AppDelegate.viewContext.save()
                print("SAVED")
            } catch {
                print("PAS SAUVEGARD2")
            }
            isFavorite = true
        } else {
            isFavorite = false
        }
    }
    
}
