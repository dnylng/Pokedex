//
//  ViewController.swift
//  Pokedex
//
//  Created by Danny Luong on 7/6/17.
//  Copyright © 2017 dnylng. All rights reserved.
//

import UIKit

class PokedexVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collection: UICollectionView!

    // An array of pokemon
    var pokeArray = [Pokemon]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.delegate = self
        collection.dataSource = self
        
        parsePokemonCSV()
    }

    // Parse the pokemon csv file
    func parsePokemonCSV() {
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        do {
            let csv = try CSV(contentsOfURL: path)
            let info = csv.rows
//            print("Info: \(info)")
            
            // Populate the pokemon array with pokemon objects that have init name and id
            for row in info {
                // For each row in the info array, grab pokemon name and id
                let pokeName = row["identifier"]!
                let pokeId = Int(row["id"]!)!
                
                let poke = Pokemon(name: pokeName, pokedexId: pokeId)
                pokeArray.append(poke)
            }
            print("Poke Array Count: \(pokeArray.count)")
        } catch let err as NSError {
            // If error is found, then csv file is at fault
            print(err.debugDescription)
        }
    }
    
    // Reusable cell behavior
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            
            let pokemon = pokeArray[indexPath.row]
            cell.configureCell(pokemon: pokemon)
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    // Selected cell behavior
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    // Number of rows in the collection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokeArray.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 105)
    }
    
}

