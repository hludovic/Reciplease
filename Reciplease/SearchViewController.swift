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
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.layer.cornerRadius = 3
        clearButton.layer.cornerRadius = 3
        searchButton.layer.cornerRadius = 3
        // Do any additional setup after loading the view.
    }

    @IBAction func add(_ sender: UIButton) {
    }
    
    @IBAction func clear(_ sender: UIButton) {
    }
    
    @IBAction func search(_ sender: UIButton) {
    }
    
    
}

