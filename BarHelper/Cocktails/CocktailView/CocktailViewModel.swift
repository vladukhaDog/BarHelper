//
//  CocktailViewModel.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 21.10.2024.
//

import Foundation
import Combine
import SwiftUI

protocol CocktailViewModelProtocol: ObservableObject {
    var cocktail: DBCocktail {get set}
    func delete()
    func edit()
    func setup(router: Router)
    func toggleFavourite()
}


final class CocktailViewModel: CocktailViewModelProtocol {
    @Published var cocktail: DBCocktail
    private var cocktailsRepository: CocktailsDI = CocktailsRepository()
    private var router: Router?
    
    private var cancellable = Set<AnyCancellable>()
    
    init(cocktail: DBCocktail) {
        self.cocktail = cocktail
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
                case .deleted(_):
                    break
                case .added(_):
                    break
                case .updated(let cocktail):
                    if self.cocktail.id == cocktail.id {
                        self.objectWillChange.send()
                        self.cocktail = cocktail
                    }
                }
            }
        }
    }
    
    func toggleFavourite() {
        Task {
            do {
                try await cocktailsRepository.favCocktail(cocktail, isFav: !cocktail.isFavourite)
            } catch RepositoryError.contextError(let error) {
                AlertsManager.shared.alert("Database error occured")
                print("failed to fetch cocktails", error)
            } catch {
                AlertsManager.shared.alert("Something went wrong")
                print("Something bad happened", error)
            }
        }
    }
    
    func delete() {
        Task {
            do {
                try await cocktailsRepository.deleteCocktail(cocktail)
                await router?.back()
            } catch RepositoryError.contextError(let error) {
                AlertsManager.shared.alert("Database error occured")
                print("failed to fetch cocktails", error)
            } catch {
                AlertsManager.shared.alert("Something went wrong")
                print("Something bad happened", error)
            }
        }
    }
    
    func edit() {
        Task {
            await router?.push(.EditCocktail(cocktail))
        }
    }
    
    func setup(router: Router) {
        self.router = router
    }
}
