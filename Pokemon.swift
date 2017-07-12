//
//  Pokemon.swift
//  Pokedex
//
//  Created by Danny Luong on 7/6/17.
//  Copyright © 2017 dnylng. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _attack: String!
    private var _height: String!
    private var _weight: String!
    private var _nextEvoTxt: String!
    private var _pokemonURL: String!
    
    var name: String {
        if let name = self._name {
            return name
        }
        return ""
    }
    
    var pokedexId: Int {
        if let pokedexId = self._pokedexId {
            return pokedexId
        }
        return 0
    }
    
    var description: String {
        if let description = self._description {
            return description
        }
        return ""
    }
    
    var type: String {
        if let type = self._type {
            return type
        }
        return ""
    }
    
    var defense: String {
        if let defense = self._defense {
            return defense
        }
        return "0"
    }
    
    var attack: String {
        if let attack = self._attack {
            return attack
        }
        return "0"
    }
    
    var height: String {
        if let height = self._height {
            return height
        }
        return "0"
    }
    
    var weight: String {
        if let weight = self._weight {
            return weight
        }
        return "0"
    }
    
    var nextEvoTxt: String {
        if let nextEvoTxt = self._nextEvoTxt {
            return nextEvoTxt
        }
        return ""
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name.capitalized
        self._pokedexId = pokedexId
        
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(pokedexId)/"
//        print(self._pokemonURL)
    }
    
    func downloadPokemonDetail(completed: @escaping DownloadComplete) {
        Alamofire.request(_pokemonURL).responseJSON { (response) in
//            print("Response: \(response)")
            
            // Grab the large dictionary of the pokemon
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                
                // Grab weight from dict
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                // Grab height from dict
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                // Grab attack from dict
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                // Grab defense from dict
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
//                print(self._weight)
//                print(self._height)
//                print(self._attack)
//                print(self._defense)
            }
            completed()
        }
    }
}
