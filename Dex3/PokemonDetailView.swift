//
//  PokemonDetailView.swift
//  Dex3
//
//  Created by Berke Parıldar on 5.03.2024.
//

import SwiftUI
import CoreData
import Charts

struct PokemonDetailView: View {
    @EnvironmentObject var pokemon: Pokemon
    @State var showShiny = false
    var body: some View {
        ScrollView {
            ZStack {
                Image(pokemon.background)
                    .resizable()
                    .scaledToFit()
                    .shadow(color: .black, radius: 6)
                AsyncImage(url: showShiny ? pokemon.shiny : pokemon.sprite) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .padding(.top, 50)
                        .shadow(color: .black, radius: 6)
                } placeholder: {
                    ProgressView()
                }
            }
            
            HStack {
                ForEach(pokemon.types!, id: \.self) { type in
                    Text(type.capitalized)
                        .font(.title2)
                        .shadow(color: .white, radius: 1)
                        .padding([.top, .bottom], 7)
                        .padding([.leading, .trailing])
                        .background(Color(type.capitalized))
                        .clipShape(.rect(cornerRadius: 50))
                }
                Spacer()
                
            }
            .padding()
            
            Text("Stats")
                .font(.title)
            Chart(pokemon.stats) { stat in
                BarMark(
                    x: .value("Value", stat.value),
                    y: .value("Stat", stat.label)
                )
                .annotation  (position: .trailing){
                    Text("\(stat.value)")
                        .padding(.top, -5)
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                }
            }
            .frame(height: 200)
            .padding([.leading, .bottom, .trailing])
            .foregroundStyle(Color(pokemon.types![0].capitalized))
            .chartXScale(domain: 0...pokemon.highestStat.value + 10)
        }
        .navigationTitle(pokemon.name!.capitalized)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                Button {
                    showShiny.toggle()
                } label: {
                    if showShiny {
                        Image(systemName: "wand.and.stars")
                            .foregroundStyle(.yellow)
                    }
                    else {
                        Image(systemName: "wand.and.stars.inverse")
                    }
                }
            })
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
    fetchRequest.fetchLimit = 1
    let results = try! context.fetch(fetchRequest)
    return PokemonDetailView()
        .environmentObject(results.first!)
}
