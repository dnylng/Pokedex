//
//  ViewController.swift
//  Pokedex
//
//  Created by Danny Luong on 7/6/17.
//  Copyright © 2017 dnylng. All rights reserved.
//

import UIKit
import AVFoundation

class PokedexVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var collection: UICollectionView!

    @IBOutlet weak var searchBar: UISearchBar!
    
    // An array of pokemon
    var pokeArray = [Pokemon]()
    
    // Playing BG music
    var musicPlayer: AVAudioPlayer!
    
    // Search results of the pokemon
    var filteredPokemon = [Pokemon]()
    
    // Searching or not
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.delegate = self
        collection.dataSource = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done
        
        // Gesture recognition to close the keyboard if tapped out of keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        initAudio()
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
//            print("Poke Array Count: \(pokeArray.count)")
        } catch let err as NSError {
            // If error is found, then csv file is at fault
            print(err.debugDescription)
        }
    }
    
    func initAudio() {
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path!)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.volume = 0.1
            musicPlayer.play()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    // Reusable cell behavior
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
         
            // Display filtered/unfiltered pokemon
            let pokemon: Pokemon!
            if inSearchMode {
                // Show filtered pokemon
                pokemon = filteredPokemon[indexPath.row]
            } else {
                // Show all of the pokemon
                pokemon = pokeArray[indexPath.row]
            }
            
            cell.configureCell(pokemon: pokemon)
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    // Selected cell behavior
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // When selected a cell, make the keyboard disappear
        searchBar.endEditing(true)
        
        var pokemon: Pokemon!
        
        if inSearchMode {
            pokemon = filteredPokemon[indexPath.row]
        } else {
            pokemon = pokeArray[indexPath.row]
        }
        
        performSegue(withIdentifier: "PokeDetailVC", sender: pokemon)
    }
    
    // Setup the segue to pass info between VC's
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokeDetailVC" {
            
            // Set the destination to PokeDetailVC
            if let detailVC = segue.destination as? PokeDetailVC {
                
                // Set the info being sent as a type of Pokemon and set that var in the detailVC
                if let pokemon = sender as? Pokemon {
                    detailVC.pokemon = pokemon
                }
            }
        }
    }
    
    // Number of rows in the collection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode {
            return filteredPokemon.count
        }
        return pokeArray.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 105)
    }
    
    @IBAction func musicBtnPressed(_ sender: UIButton) {
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            // Set the button transparent
            sender.alpha = 0.2
        } else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
    
    // Closes the keyboard when return is pressed in search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    // Closes the keyboard when dragging the screen
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    // Closes the keyboard when cancel button pressed
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    // Closes the keyboard when tapped out of search bar
    func dismissKeyboard() {
        searchBar.endEditing(true)
    }
    
    // Determines whether there is text in the search bar to filter
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            // If not searching, then revert to full list of pokemon
            inSearchMode = false
            collection.reloadData()
            
            // Closes the keyboard when done searching
            searchBar.endEditing(true)
        } else {
            inSearchMode = true
            
            // Filter the pokeArray by the search string
            filteredPokemon = pokeArray.filter({$0.name.localizedStandardRange(of: searchBar.text!) != nil})
            collection.reloadData()
        }
    }
}

