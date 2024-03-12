//
//  ContentView.swift
//  Dex3
//
//  Created by Berke Parıldar on 3.03.2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        animation: .default)
    private var pokedex: FetchedResults<Pokemon>
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        predicate: NSPredicate(format: "favorite = %d", true),
        animation: .default)
    private var favorites: FetchedResults<Pokemon>
    @StateObject private var viewModel = PokemonViewModel(controller: FetchController())
    @State var filterByFavorites: Bool = false
    var body: some View {
        switch viewModel.status {
        case .fetching:
            NavigationStack{
                List(filterByFavorites ? favorites : pokedex) { pokemon in
                    NavigationLink (value: pokemon) {
                        AsyncImage(url: pokemon.sprite) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 100, height: 100)
                        Text("\(pokemon.name!.capitalized)")
                    }
                }
                .navigationTitle("Pokedex")
                .navigationDestination(for: Pokemon.self, destination: { pokemon in
                    PokemonDetailView()
                        .environmentObject(pokemon)
                })
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            withAnimation {
                                filterByFavorites.toggle()
                            }
                        } label: {
                            Label("Filter by favorites", systemImage: filterByFavorites ? "star.fill" : "star")
                        }
                        .font(.title)
                        .foregroundStyle(.yellow)
                    }
                }
            }
        default:
            ProgressView()
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
