//
//  EditIngredientsView.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 18.06.2023.
//

import SwiftUI

extension EditIngredientView where ViewModel == EditIngredientsViewModel {
    init(ingredient: DBIngredient) {
        self.init(vm: EditIngredientsViewModel(ingredient))
    }
}

struct EditIngredientView<ViewModel>: View where ViewModel: EditIngredientsViewModelProtocol {
    @StateObject private var vm: ViewModel
    @EnvironmentObject private var router: Router
    
    internal init(vm: ViewModel) {
        self._vm = .init(wrappedValue: vm)
    }
    
    var body: some View{
        VStack{
            TextField("Ingredient name", text: $vm.name)
                .cyberpunkStyle()
            HStack{
                Button("Cancel") {
                    vm.cancel()
                }
                .cyberpunkStyle(.gray)

                Button("Save") {
                    vm.save()
                }
                .cyberpunkStyle(.green)
            }
        }
        .padding()
        .background(Color.darkPurple)
        .padding(5)
        .depthBorderUp()
        .padding(5)
        .backgroundWithoutSafeSpace(.darkPurple)
        .task {
            await vm.setup(router)
        }
    }
}

private final class MockViewModel: EditIngredientsViewModelProtocol {
    func save() {
    }
    
    func cancel() {
    }
    
    @Published var name: String = "Ingredient Name"
    func setup(_ router: Router) async {
    }
}

#Preview {
    EditIngredientView(vm: MockViewModel())
        .previewWrapper()
}
