//
//  PokemonViewModel.swift
//  Dex3
//
//  Created by Berke Parıldar on 5.03.2024.
//

import Foundation

@MainActor
class PokemonViewModel: ObservableObject {
    enum Status {
        case notStarted
        case fetching
        case success
        case failed(error: Error)
    }
    
    @Published private(set) var status = Status.notStarted
    
    private let controller: FetchController
    
    init(controller: FetchController) {
        self.controller = controller
        Task {
            await getPokemon()
        }
    }
    
    private func getPokemon() async {
        status = .fetching
        do {
            var pokeDex = try await controller.fetchAllPokemon()
            pokeDex.sort { $0.id < $1.id }
            for pokemon in pokeDex {
                let newPokemon = Pokemon(context: PersistenceController.shared.container.viewContext)
                newPokemon.id = Int16(pokemon.id)
                newPokemon.name = pokemon.name
                newPokemon.types = pokemon.types
                newPokemon.hp = Int16(pokemon.hp)
                newPokemon.attack = Int16(pokemon.attack)
                newPokemon.specialAttack = Int16(pokemon.specialAttack)
                newPokemon.defence = Int16(pokemon.defense)
                newPokemon.specialDefense = Int16(pokemon.defense)
                newPokemon.speed = Int16(pokemon.speed)
                newPokemon.sprite = pokemon.sprite
                newPokemon.shiny = pokemon.shiny
                newPokemon.favorite = false
                try PersistenceController.shared.container.viewContext.save()
            }
            status = .success
        } catch {
            status = .failed(error: error)
        }
    }
}
