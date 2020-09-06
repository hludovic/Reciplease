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
    
    private func displayError(message: String) {
        let alert = UIAlertController(title: "Error !", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func addIngredient() {
        guard let ingredient = ingredientTextField.text, ingredient != "" else {
            displayError(message: "You must enter an ingredient before adding it to the list.")
            return
        }
        SettingService.ingredients.append(ingredient)
        ingredientTextField.text = ""
        refreshIngredientsList()
    }

    @IBAction func pressAddButton(_ sender: UIButton) {
        addIngredient()
        ingredientTextField.resignFirstResponder()
    }
    
    @IBAction func pressClearButton(_ sender: UIButton) {
        SettingService.ingredients = []
        refreshIngredientsList()
    }
    
    @IBAction func pressSearchButton(_ sender: UIButton) {
        isLoading = true
        RecipeWebService.fetchRecipes(keywords: SettingService.ingredients) { (recipes) in
            self.isLoading = false
            guard let recipes = recipes else {
                self.displayError(message: "Search could not be performed.")
                return
            }
            guard recipes.count > 0 else {
                self.displayError(message: "No recipe was found.")
                return
            }
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let recipeListView = storyboard.instantiateViewController(identifier: "RecipeList") as! RecipeTableViewController
            recipeListView.recipes = recipes
            self.navigationController?.pushViewController(recipeListView, animated: true)
        }
    }
    
    @IBAction func hideKeyboard(_ sender: Any) {
        ingredientTextField.resignFirstResponder()
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addIngredient()
        ingredientTextField.resignFirstResponder()
        return true
    }
}

