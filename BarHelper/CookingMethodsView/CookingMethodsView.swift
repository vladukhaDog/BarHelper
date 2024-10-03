//
//  CookingMethodsView.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 09.05.2023.
//

import SwiftUI

struct CookingMethodsView<ViewModel>: View where ViewModel: CookingMethodsViewModelProtocol {
    
    init(vm: ViewModel = CookingMethodsViewModel()) {
        self._vm = StateObject(wrappedValue: vm)
    }
    
    @StateObject private var vm: ViewModel
    @State private var showAdd = false
    var body: some View {
        old
            .sheet(item: $vm.methodToView) { item in
                EditCookingMethodView(item)
                    .presentationDetents([.medium, .large])
            }
    }

    var old: some View {
        VStack(alignment: .trailing) {
            ScrollView {
                LazyVStack {
                    ForEach(vm.methods, id: \.id) { method in
                        Button {
                            vm.methodToView = method
                        } label: {
                            Text(method.name ?? "")
                                .cyberpunkFont(.smallTitle)
                                .foregroundColor(.white)
                        }
                        .padding(5)
                    }
                }
                .padding(.horizontal, 5)
            }
            .frame(maxWidth: .infinity)
            .background(Color.black)
            .padding(5)
            .depthBorder()
            .padding(.horizontal, 5)
            
            Button("Add") {
                showAdd.toggle()
            }
            .cyberpunkStyle(.green)
            .frame(width: 150)
            .sheet(isPresented: $showAdd) {
                addCookingMethod
                .presentationDetents([.medium, .large])
            }
            .padding(.horizontal)
            
        }
        .backgroundWithoutSafeSpace(.darkPurple)
        .navigationTitle("Cooking types")
    }
    
    private var addCookingMethod: some View{
        VStack{
            TextField("", text: $vm.name, prompt: Text("Cooking Type name"))
                .font(.smallTitle)
                .foregroundColor(.white)
                .tint(.white)
                .padding(5)
                .depthBorder()
            HStack{
                Button("Reset") {
                    vm.name = ""
                }
                .cyberpunkStyle(.orange)

                Button("Add") {
                    showAdd = false
                    vm.addCookingMethod()
                }
                .cyberpunkStyle(.green)
            }
            Spacer()
        }
        .padding()
        .backgroundWithoutSafeSpace(.darkPurple)
    }
}


// MARK: Preview Mock data
/// Mock view model with a list of mock methods prefilled
fileprivate final class MockCookingMethodsViewModel: CookingMethodsViewModelProtocol {
    var name: String = ""
    
    @Published var methods: [CookingMethod] = []
    
    @Published var methodToView: CookingMethod? = nil
    
    init() {
        Task {
            await fetchMethods()
        }
    }
    func fetchMethods() async {
        DispatchQueue.main.async {
            self.methods = MockData.mockCookingMethods(14)
        }
    }
    
    func updateList(_ action: CookingMethodRepository.Action) {}
    func addCookingMethod() {}
    func deleteMethod(method: CookingMethod) {}
}

// MARK: Preview
#Preview {
    NavigationStack(path: .constant([Destination.CookingMethodsList])) {
        Color.blue
            .navigationDestination(for: Destination.self) { route in
                CookingMethodsView(vm: MockCookingMethodsViewModel())
                    .navigationBarTitleDisplayMode(.inline)
            }
    }
    .navigationBarTitleTextColor(.white)
    .tint(.mint)
}
