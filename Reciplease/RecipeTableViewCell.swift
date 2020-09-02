//
//  RecipeTableViewCell.swift
//  Reciplease
//
//  Created by Ludovic HENRY on 30/08/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import UIKit
import Alamofire

class RecipeTableViewCell: UITableViewCell {
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var infosView: UIView!
    var imageUrl: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()        
        infosView.layer.cornerRadius = 4
    }
    
    func gradientBackground() {
        let view = UIView(frame: backgroundImage.frame)
        let gradient = CAGradientLayer()
        gradient.frame = view.frame
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.6, 1.0]
        view.layer.insertSublayer(gradient, at: 0)
        backgroundImage.addSubview(view)
        backgroundImage.bringSubviewToFront(view)
    }
    
    private func downloadImage(url: String) {
        AF.download(url).responseData { (response) in
            if let data = response.value {
                self.backgroundImage.image = UIImage(data: data)
                self.gradientBackground()
            }
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview != nil {
            downloadImage(url: imageUrl!)
            if let imageUrl = imageUrl {
                downloadImage(url: imageUrl)
            }
        }
    }
    
}
