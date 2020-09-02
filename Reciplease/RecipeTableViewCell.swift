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
        // Initialization code
        
        infosView.layer.cornerRadius = 4
        

    }

    func gradientBackground() {
        let view = UIView(frame: backgroundImage.frame)
        let gradient = CAGradientLayer()
        gradient.frame = view.frame
        gradient.colors = [UIColor.clear.cgColor, #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).cgColor]
        gradient.locations = [0.5, 1.0]
        view.layer.insertSublayer(gradient, at: 0)
        backgroundImage.addSubview(view)
        backgroundImage.bringSubviewToFront(view)
    }

    private func downloadImage(url: String) {
        AF.request(url).responseData { (response) in
            guard let data = response.data else {
                print("ERROR-IMAGE")
                return
            }
            let image = UIImage(data: data)
            self.backgroundImage.image = image
            self.gradientBackground()
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
