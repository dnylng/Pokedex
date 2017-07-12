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
    private var _nextEvoName: String!
    private var _nextEvoId: String!
    private var _nextEvoLvl: String!
    
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
    
    var nextEvoName: String {
        if let nextEvoName = self._nextEvoName {
            return nextEvoName
        }
        return ""
    }
    
    var nextEvoId: String {
        if let nextEvoId = self._nextEvoId {
            return nextEvoId
        }
        return ""
    }
    
    var nextEvoLvl: String {
        if let nextEvoLvl = self._nextEvoLvl {
            return nextEvoLvl
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
                
                // Grab the description array from dict
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>], descArr.count > 0 {
                    // Grab the url that links to the pokemon description
                    if let url = descArr[0]["resource_uri"] {
                        let fullUrl = "\(URL_BASE)\(url)"
                        
                        // Request JSON info for desc
                        Alamofire.request(fullUrl).responseJSON(completionHandler: { (response) in
                            // Now we need to extract the description
                            if let descDict = response.result.value as? Dictionary<String, AnyObject> {
                                if let description = descDict["description"] as? String {
//                                    print(description)
                                    let newDesc = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    self._description = newDesc
                                }
                            }
                            completed()
                        })
                    }
                } else {
                    self._description = ""
                }
                
                // Grab the types array from dict
                if let typesArr = dict["types"] as? [Dictionary<String, String>], typesArr.count > 0 {
                    for i in 0..<typesArr.count {
                        // If not 1 type, append other type
                        if i > 0 {
                            if let name = typesArr[i]["name"] {
                                self._type.append("/\(name.capitalized)")
                            }
                        } else {
                            // Only 1 type
                            if let name = typesArr[i]["name"] {
                                self._type = name.capitalized
                            }
                        }
                    }
//                    print("Type: \(self._type!)")
                } else {
                    self._type = ""
                }
                
                // Evolutions info
                if let evoArr = dict["evolutions"] as? [Dictionary<String, AnyObject>], evoArr.count > 0 {
                    // Grab next evolution name
                    if let nextEvo = evoArr[0]["to"] as? String {
                        
                        // Filter out mega evolutions
                        if nextEvo.range(of: "mega") == nil {
                            self._nextEvoName = nextEvo.capitalized
                        }
                    }
                    
                    // Grab the id of the next evo by using resource URI
                    if let uri = evoArr[0]["resource_uri"] as? String {
                        let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                        let nextEvoId = newStr.replacingOccurrences(of: "/", with: "")
                        
                        self._nextEvoId = nextEvoId
                    }
                    
                    // Grab the evo lvl
                    if let lvlExist = evoArr[0]["level"] {
                        if let lvl = lvlExist as? Int {
                            self._nextEvoLvl = "\(lvl)"
                        }
                    } else {
                        self._nextEvoLvl = ""
                    }
                    
//                    print("Evo Lvl: \(self._nextEvoLvl!)")
//                    print("Evo Name: \(self.nextEvoName)")
//                    print("Evo Id: \(self.nextEvoId)")
                }
                
            }
            completed()
        }
    }
}
