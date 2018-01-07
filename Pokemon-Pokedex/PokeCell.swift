//
//  PokeCell.swift
//  Pokemon-Pokedex
//
//  Created by Chaudhary Himanshu Raj on 04/01/18.
//  Copyright © 2018 Chaudhary Himanshu Raj. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    @IBOutlet weak var pokeImage: UIImageView!
    @IBOutlet weak var pokeName: UILabel!
    var pokemon : Pokemon!
    
    required init?(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5.0
    }
    
    func configurePokemonCell(_ pokemon: Pokemon) {
        self.pokemon = pokemon
        pokeName.text = self.pokemon.name.capitalized
        self.pokeImage.image = UIImage(named: String(self.pokemon.pokedexId))
    }
}
