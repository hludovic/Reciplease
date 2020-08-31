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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

