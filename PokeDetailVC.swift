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
    
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedexLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var atkLbl: UILabel!
    @IBOutlet weak var currEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var evoLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load the pokemon name
        nameLbl.text = pokemon.name
        
        // Load in the proper pokemon images
        let img = UIImage(named: "\(pokemon.pokedexId)")
        mainImg.image = img
        currEvoImg.image = img
        
        pokemon.downloadPokemonDetail {
            // Only be run after download is complete... update the UI
            self.updateUI()
        }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // Updates the information on the detailed pokemon screen
    func updateUI() {
        pokedexLbl.text = "\(pokemon.pokedexId)"
        atkLbl.text = pokemon.attack
        defLbl.text = pokemon.defense
        heightLbl.text = pokemon.height
        weightLbl.text = pokemon.weight
        typeLbl.text = pokemon.type
        descriptionLbl.text = pokemon.description
        
        if pokemon.nextEvoId == "" {
            evoLbl.text = "No Evolutions"
            nextEvoImg.isHidden = true
        } else {
            nextEvoImg.isHidden = false
            nextEvoImg.image = UIImage(named: pokemon.nextEvoId)
            evoLbl.text = "Next Evolution: \(pokemon.nextEvoName) - LVL \(pokemon.nextEvoLvl)"
        }
    }
}
