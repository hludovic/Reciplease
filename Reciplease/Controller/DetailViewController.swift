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
    
    // MARK: - IBOutlet Properties
    @IBOutlet weak var imageDetail: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!

    // MARK: - Properties
    var recipe: Recipe?
    var errorMessage: String? {
        didSet {
            let alert = UIAlertController(title: "Error !", message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    var isFavorite: Bool = false {
        didSet {
            if isFavorite {
                let imageButton = UIImage(systemName: "star.fill")
                favoriteButton?.image = imageButton
                favoriteButton?.tintColor = #colorLiteral(red: 0.2666666667, green: 0.5803921569, blue: 0.3647058824, alpha: 1)
            } else {
                let imageButton = UIImage(systemName: "star")
                favoriteButton?.image = imageButton
                favoriteButton?.tintColor = UIColor.white
            }
        }
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let recipe = recipe else { return }
        title = "Reciplease"
        isFavorite = recipe.isFavorite
        titleLabel.text = recipe.title
        timeLabel.text = "\(recipe.duration)m"
        likesLabel.text = "_ _ _"
        ingredientsTextView.text = recipe.ingredients
        if let imageData = recipe.imageData {
            imageDetail.image = UIImage(data: imageData)
        }
        goButton.layer.cornerRadius = 3
        infoView.layer.cornerRadius = 3
    }

    // MARK: - IBAction Methods
    @IBAction func pressFavButton(_ sender: UIBarButtonItem) {
        guard let recipe = recipe else { return }
        if !isFavorite {
            do {
                let favorite = Favorite(context: AppDelegate.viewContext)
                favorite.newObject(recipe: recipe)
                try AppDelegate.viewContext.save()
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            } catch {
                errorMessage =  "The recipe could not be added to favorites."
            }
            isFavorite = true
        } else {
            guard Favorite.remove(id: recipe.id) else {
                errorMessage = "The recipe could not be removed from favorites."
                return
            }
            isFavorite = false
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
    }

    @IBAction func pressDirectionsButton(_ sender: UIButton) {
        guard let urlString = recipe?.directions, let url = URL(string: urlString) else {
            errorMessage = "The url of the recipe is not good."
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
