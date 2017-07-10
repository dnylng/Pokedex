//
//  PokeDetailVC.swift
//  Pokedex
//
//  Created by Danny Luong on 7/10/17.
//  Copyright © 2017 dnylng. All rights reserved.
//

import UIKit

class PokeDetailVC: UIViewController {

    var pokemon: Pokemon!
    
    @IBOutlet weak var nameLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLbl.text = pokemon.name
    }
}
