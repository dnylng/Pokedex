//
//  PokeCell.swift
//  Pokedex
//
//  Created by Danny Luong on 7/7/17.
//  Copyright © 2017 dnylng. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    var pokemon: Pokemon!
    
    func configureCell(pokemon: Pokemon) {
        // Update the pokemon info
        self.pokemon = pokemon
        
        // Update the UI of that pokemon
        thumbImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
        nameLbl.text = self.pokemon.name.capitalized
    }
    
}
