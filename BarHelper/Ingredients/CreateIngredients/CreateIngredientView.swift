//
//  CreateIngredientView.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 11.05.2023.
//

import SwiftUI

struct CreateIngredientView: View {
    @StateObject private var vm: CreateIngredientViewModel
    @FocusState private var nameIsFocused: Bool
    @FocusState private var metricIsFocused: Bool
    @EnvironmentObject var router: Router
    
    init(_ parent: DBIngredient? = nil) {
        self._vm = .init(wrappedValue: CreateIngredientViewModel(parent: parent))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if let parent = vm.parent {
                parentInfo(parent)
            }
            TextField("Ingredient name", text: $vm.name)
            .cyberpunkStyle(focusState: $nameIsFocused)
            .onAppear {
                DispatchQueue.main.async {
                    nameIsFocused = true
                }
            }
            
            if vm.parent == nil{
                metricSelect
            }
            controls
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
        .navigationTitle("New Ingredient")
        .customToolBar(id: "CreateIngredient",
                       text: "Save",
                       router: router,
                       action: {
            print("hihi")
        })
    }
    
    private func parentInfo(_ parent: DBIngredient) -> some View {
        VStack(alignment: .leading) {
            Text("Add an alternative for")
                .cyberpunkFont(.smallTitle)
            Text(parent.name ?? "")
                .cyberpunkFont(.title)
        }
            .foregroundColor(.white)
            
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(8)
            .background(Color.black)
            .padding(5)
            .depthBorder()
    }
    
    private var metricSelect: some View {
        VStack {
            VStack(alignment: .center, spacing: 10){
                Text("Metric Type:")
                    .foregroundColor(.white)
                    .cyberpunkFont(.smallTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                metricPresets
                
            }
            .padding(8)
            .background(Color.black)
            .padding(5)
            .depthBorder()
            if vm.metric != "pc" && vm.metric != "ml"{
                customMetricTextField
            }
        }
        .padding(10)
        .depthBorderUp()
        .clipped()
        .animation(.bouncy, value: vm.metric)
        
    }
    
    private var customMetricTextField: some View {
        TextField("Custom metric name", text: .init(get: {
            if vm.metric != "pc", vm.metric != "ml"{
                return vm.metric
            }else{
                return ""
            }
        }, set: { newVal in
            withAnimation {
                self.vm.metric = newVal
            }
        }))
        .cyberpunkStyle(focusState: $metricIsFocused)
    }
    
    private var metricPresets: some View {
        HStack(spacing: 20) {
            let isML = vm.metric == "ml"
            let isPC = vm.metric == "pc"
            let isCus = !isML && !isPC
            Button {
                self.vm.metric = "ml"
            } label: {
                Text("ml")
                    .foregroundStyle(isML ? Color.tintedOrange : .white)
            }
            Button {
                self.vm.metric = "pc"
            } label: {
                Text("pc")
                    .foregroundStyle(isPC ? Color.tintedOrange : .white)
            }
            
            Button {
                if !isCus {
                    self.vm.metric = ""
                }
                metricIsFocused = true
            } label: {
                Text("custom")
                    .foregroundStyle(isCus ? Color.tintedOrange : .white)
//                    .foregroundColor(.white.opacity(isCus ? 1 : 0.6))
            }
        }
        
        .cyberpunkFont(30)
    }
    
    private var controls: some View {
        HStack{
            Button("Reset") {
                vm.name = ""
                vm.metric = "ml"
            }
            .cyberpunkStyle(.orange)
            Button("Add") {
                vm.addIngredient()
            }
            .cyberpunkStyle(.green)
            .disabled(vm.name.isEmpty || vm.metric.isEmpty)
        }
        .padding(8)
        .background(Color.black)
        .padding(5)
        .depthBorder()
    }
}

#Preview("No parent") {
    NavigationStack(path: .constant([Destination.CreateIngredientView(nil)])) {
        Color.blue
            .navigationDestination(for: Destination.self) { route in
                CreateIngredientView()
                    .environmentObject(Router.init())
                    .navigationBarTitleDisplayMode(.inline)
            }
    }
    .navigationBarTitleTextColor(.white)
    .tint(.mint)
}

#Preview("With parent") {
    NavigationStack(path: .constant([Destination.CreateIngredientView(nil)])) {
        Color.blue
            .navigationDestination(for: Destination.self) { route in
                CreateIngredientView(MockData.mockIngredient("Parent Ingredient"))
                    .environmentObject(Router.init())
                    .navigationBarTitleDisplayMode(.inline)
            }
    }
    .navigationBarTitleTextColor(.white)
    .tint(.mint)
}
