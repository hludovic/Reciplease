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
    var recipe: Recipe?
    var imageData: Data?
    var favButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Reciplease"
        addFavoriteButton()
        commonInit()
        goButton.layer.cornerRadius = 3
        infoView.layer.cornerRadius = 3
        gradientBackground()
    }
    
    private func addFavoriteButton() {
        let imageButton = UIImage(systemName: "star")
        favButton = UIBarButtonItem(image: imageButton, style: .plain, target: self, action: #selector(saveToFavorite))
        navigationItem.rightBarButtonItem = favButton
    }
    
    private func commonInit() {
        guard let recipe = recipe else { return }
        titleLabel.text = recipe.title
        ingredientsTextView.text = "- " + recipe.ingredients.joined(separator: "\n- ")
        downloadImage(url: recipe.image)
    }
        
    private func downloadImage(url: String) {
        AF.download(url).responseData { (response) in
            if let data = response.value {
                self.imageData = data
                self.imageDetail.image = UIImage(data: data)
            }
        }
    }

    func gradientBackground() {
        let view = UIView(frame: imageDetail.frame)
        let gradient = CAGradientLayer()
        gradient.frame = view.frame
        gradient.colors = [UIColor.clear.cgColor, #colorLiteral(red: 0.2156862745, green: 0.2, blue: 0.1960784314, alpha: 1).cgColor]
        gradient.locations = [0.5, 1.0]
        view.layer.insertSublayer(gradient, at: 0)
        imageDetail.addSubview(view)
        imageDetail.bringSubviewToFront(view)
    }

    
    @objc func saveToFavorite() {
        if !isFavorite {
//            guard let recipe = recipe, let imageData = imageData else { return }
//            let favorite = Favorite(context: AppDelegate.viewContext)
//            favorite.directions = recipe.directions
//            favorite.duration = Int16(recipe.duration)
//            favorite.id = recipe.id
//            favorite.imageData = imageData
//            favorite.imageUrl = recipe.image
//            favorite.ingredients = recipe.ingredients
//            favorite.title = recipe.title
//
//            do {
            //            try AppDelegate.viewContext.save()
                        isFavorite = true
//                        print("Saved")
//                    } catch {
//                        print("ERROR")
//                    }
        } else {
            isFavorite = false
        }
        
    }
    
}
