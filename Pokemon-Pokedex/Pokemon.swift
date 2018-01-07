//
//  Pokemon.swift
//  Pokemon-Pokedex
//
//  Created by Chaudhary Himanshu Raj on 04/01/18.
//  Copyright © 2018 Chaudhary Himanshu Raj. All rights reserved.
//

import Foundation

class Pokemon {
    
    fileprivate var _name : String!
    fileprivate var _pokedexId : Int!
    
    var name : String {
        return _name
    }
    
    var pokedexId : Int! {
        return _pokedexId
    }

    init(name: String , pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
    }
}
