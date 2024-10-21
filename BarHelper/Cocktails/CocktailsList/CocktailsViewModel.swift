//
//  CocktailsViewModel.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 09.05.2023.
//

import Foundation
import Combine
import SwiftUI

protocol CocktailsViewModelProtocol: ObservableObject {
    var search: String {get set}
    var cocktails: [Cocktail] {get set}
    var cocktailsFromDB: [UUID?: DBCocktail] {get set}
}

class CocktailsViewModel: CocktailsViewModelProtocol{
    private let cocktailsRepository: CocktailsDI = CocktailsRepository()
    @Published var search = ""
    @Published var cocktails: [Cocktail] = []
    var cocktailsFromDB: [UUID?: DBCocktail] = [:]
    @Published var localSearch = false
    private var cancellable = Set<AnyCancellable>()
    
    init(_ cocktails: [DBCocktail]?){
        if let cocktails{
            self.cocktails = cocktails.map({$0.structCocktail()})
            self.cocktailsFromDB = .init(uniqueKeysWithValues: cocktails.map{($0.id, $0)})
            self.localSearch = true
        }else{
            Task{
                await fetchCocktails()
            }
        }
        $search
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .dropFirst()
            .sink { newSearch in
            Task{
                let searchText: String? = newSearch.isEmpty ? nil : newSearch
                await self.fetchCocktails(search: searchText)
            }
        }
        .store(in: &cancellable)
        
        cocktailsRepository
            .getPublisher()
            .sink {[weak self] notification in
                guard let self else {return}
                guard let action = notification.object as? CocktailsDI.Action
                else {return}
                self.updateList(action)
            }
            .store(in: &cancellable)
    }
    
    internal func updateList(_ action: CocktailsDI.Action) {
        DispatchQueue.main.async {
            withAnimation {
                switch action {
                case .deleted(let cocktail):
                    self.cocktails.removeAll(where: {$0.id == cocktail.id})
                case .added(let cocktail):
                    let index = self.cocktails.map({$0.name ?? ""})
                        .findAlphabeticalOrderIndex(for: cocktail.name ?? "")
                    self.cocktails.insert(cocktail.structCocktail(), at: index)
                    self.cocktailsFromDB[cocktail.id] = cocktail
                case .updated(let cocktail):
                    if let index = self.cocktails.firstIndex(where: {$0.id == cocktail.id}) {
                        self.objectWillChange.send()
                        self.cocktails[index] = cocktail.structCocktail()
                        self.cocktailsFromDB[cocktail.id] = cocktail
                    }
                }
            }
        }
    }

    private func fetchCocktails(search: String? = nil) async{
        do{
            let cocktails = try await cocktailsRepository.fetchCocktails(search: search)
            await MainActor.run {
                self.cocktails = cocktails.map({$0.structCocktail()})
                self.cocktailsFromDB = .init(uniqueKeysWithValues: cocktails.map{($0.id, $0)})
            }
        } catch RepositoryError.contextError(let error) {
            AlertsManager.shared.alert("Database error occured")
            print("failed to fetch cocktails", error)
        } catch {
            AlertsManager.shared.alert("Something went wrong")
            print("Something bad happened", error)
        }
    }
}
