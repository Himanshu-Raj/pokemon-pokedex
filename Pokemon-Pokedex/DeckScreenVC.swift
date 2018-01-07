//
//  ViewController.swift
//  Pokemon-Pokedex
//
//  Created by Chaudhary Himanshu Raj on 04/01/18.
//  Copyright © 2018 Chaudhary Himanshu Raj. All rights reserved.
//

import UIKit
import AVFoundation

class DeckScreenVC: UIViewController {

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var pokemonSerachBar: UISearchBar!
    
    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var musicPLayer : AVAudioPlayer!
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        collection.dataSource = self
        collection.delegate = self
        pokemonSerachBar.delegate = self
        pokemonSerachBar.returnKeyType = UIReturnKeyType.done
        
        parsePokemonCSV()
        initAudio()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pokemonDetailsVC" {
            if let detailsVC = segue.destination as? PokemonDetailsVC {
                if let poke = sender as? Pokemon {
                    detailsVC.pokemon = poke
                }
            }
        }
    }
    
    @IBAction func musicButtonTapped(_ sender: Any) {
        
        if musicPLayer.isPlaying {
            musicPLayer.pause()
            if let button = sender as? UIButton {
                button.alpha = 0.2
            }
            
        } else {
            musicPLayer.play()
            if let button = sender as? UIButton {
                button.alpha = 1.0
            }
        }
        
    }
    
    
    func parsePokemonCSV() {
            let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")
        do {
            let csv = try CSV(contentsOfURL: path!)
            let rows = csv.rows
                // print(rows)
            for row in rows {
                let pokeId = Int(row["id"]!)!
                let pokename =  row["identifier"]!
                
                let poke = Pokemon(name: pokename, pokedexId : pokeId)
                pokemon.append(poke)
                
            }
        } catch let err as NSError {
            print(err.description)
        }
    }
    
    func initAudio() {
        let path = Bundle.main.path(forResource: "PokemonMusic", ofType: "mp3")
        do {
            musicPLayer = try AVAudioPlayer(contentsOf: URL(string : path!)!)
            musicPLayer.prepareToPlay()
            musicPLayer.numberOfLoops = -1
            musicPLayer.play()
            }
            catch let err as NSError {
            print(err.description)
        }
    }
}


extension DeckScreenVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode {
            return filteredPokemon.count
        } else {
        return pokemon.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pokeCell", for: indexPath ) as? PokeCell {
            
            // let pokemon = Pokemon(name : "Pokemon", pokedexId : indexPath.row)
            // cell.configurePokemonCell(pokemon)
            let poke : Pokemon!
            
                if inSearchMode {
                        poke = filteredPokemon[indexPath.row]
                        cell.configurePokemonCell(poke)
                } else {
                        poke = pokemon[indexPath.row]
                        cell.configurePokemonCell(poke)
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var poke : Pokemon!
        if inSearchMode {
            poke = filteredPokemon[indexPath.row]
        } else {
            poke = pokemon[indexPath.row]
        }
        
        performSegue(withIdentifier: "pokemonDetailsVC", sender: poke)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 105)
    }
}

extension DeckScreenVC : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if pokemonSerachBar.text == nil && pokemonSerachBar.text == "" {
            inSearchMode = false
            collection.reloadData()
            view.endEditing(true)
            
        } else {
            inSearchMode = true
            let lower = pokemonSerachBar.text!.lowercased()
            filteredPokemon = pokemon.filter({$0.name.range(of: lower) != nil})
            collection.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
