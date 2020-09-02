//
//  ViewController.swift
//  Reciplease
//
//  Created by Ludovic HENRY on 30/08/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var ingredientTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var isLoading: Bool = false {
        didSet {
            if isLoading {
                searchButton.isEnabled = false
                searchButton.setTitle("", for: .disabled)
                activityIndicator.startAnimating()
                activityIndicator.isHidden = false
            } else {
                searchButton.isEnabled = true
                searchButton.setTitle("Search for recipes", for: .normal)
                activityIndicator.stopAnimating()
                activityIndicator.isHidden = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isLoading = false
        refreshIngredientsList()
        addButton.layer.cornerRadius = 3
        clearButton.layer.cornerRadius = 3
        searchButton.layer.cornerRadius = 3
    }
    
    private func refreshIngredientsList() {
        ingredientsTextView.text = ""
        for ingredient in SettingService.ingredients {
            ingredientsTextView.text! += "- \(ingredient) \n"
        }
    }
    
    private func addIngredient() {
        guard let ingredient = ingredientTextField.text, ingredient != "" else {
            return
        }
        SettingService.ingredients.append(ingredient)
        ingredientTextField.text = ""
        refreshIngredientsList()
    }

    @IBAction func add(_ sender: UIButton) {
        addIngredient()
        ingredientTextField.resignFirstResponder()
    }
    
    @IBAction func clear(_ sender: UIButton) {
        SettingService.ingredients = []
        refreshIngredientsList()
    }
    
    @IBAction func search(_ sender: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let recipeListView = storyboard.instantiateViewController(identifier: "RecipeList") as! RecipeListViewController
        isLoading = true
        fetchRecipes { (recipes) in
            guard let recipes = recipes else {
                print("ERROR")
                self.isLoading = false
                return
            }
            self.isLoading = false
            recipeListView.recipes = recipes
            recipeListView.title = "Reciplease"
            self.navigationController?.pushViewController(recipeListView, animated: true)
        }
    }
    
    @IBAction func hideKeyboard(_ sender: Any) {
        ingredientTextField.resignFirstResponder()
    }
    
    func fetchRecipes(callback: @escaping (Recipes?) -> Void) {
        if SettingService.ingredients.count != 0 {
            RecipeWebService.fetchRecipes(keywords: SettingService.ingredients) { (recipes) in
                guard let recipes = recipes else {
                    print("ERROR")
                    callback(nil)
                    return
                }
                callback(recipes)
            }
        } else {
            print("ERROR")
            callback(nil)
            return
        }
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addIngredient()
        ingredientTextField.resignFirstResponder()
        return true
    }
}

