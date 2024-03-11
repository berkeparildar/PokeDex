//
//  PokemonExtension.swift
//  Dex3
//
//  Created by Berke Parıldar on 12.03.2024.
//

import Foundation

extension Pokemon {
    var background: String {
        switch self.types![0] {
        case "normal", "grass", "electric", "fairy" :
            return "normalgrasselectricpoisonfairy"
        case "rock", "ground", "steel", "fighting", "dark", "psychic":
            return "rockgroundsteelfightingdarkpsychic"
        case "fire", "dragon":
            return "firedragon"
        case "flying", "bug":
            return "flyingbug"
        case "ice":
            return "ice"
        case "water":
            return "water"
        default:
            return "defaultcase"
        }
    }
    
    var stats: [Stat] {
        [
            Stat(id: 1, label: "HP", value: self.hp),
            Stat(id: 2, label: "Attack", value: self.attack),
            Stat(id: 3, label: "Defense", value: self.defence),
            Stat(id: 4, label: "Special Attack", value: self.specialAttack),
            Stat(id: 5, label: "Special Defense", value: self.specialDefense),
            Stat(id: 6, label: "Speed", value: self.speed)
        ]
    }
    
    var highestStat: Stat {
        stats.max{ $0.value < $1.value }!
    }
}

struct Stat: Identifiable {
    let id: Int
    let label: String
    let value: Int16
}
