//
//  CreateIngredientView.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 11.05.2023.
//

import SwiftUI

struct CreateIngredientView: View {
    @StateObject private var vm: CreateIngredientViewModel
    @Environment(\.presentationMode) var presentationMode
    init(onAdd: @escaping () ->(), baseIngredient: DBIngredient? = nil){
        self._vm = .init(wrappedValue: .init(onAdd: onAdd, baseIngredient: baseIngredient))
    }
    var body: some View {
        VStack(alignment: .leading){
            let isML = vm.metric == "ml"
            let isPC = vm.metric == "pc"
            let isCus = vm.metric != "ml" && vm.metric != "pc"
            if let baseIngredient = vm.baseIngredient{
                Text("Add alternative for \(baseIngredient.name ?? "")")
                    .foregroundColor(.white)
                    .font(.CBTitle)
                    .multilineTextAlignment(.leading)
            }
            
            TextField("Ingredient name", text: $vm.name)
                .font(.smallTitle)
                .foregroundColor(.white)
                .tint(.white)
                .padding(5)
                .depthBorder()
            if vm.baseIngredient == nil{
                VStack(spacing: 10){
                    
                    HStack{
                        Text("Metric Type:")
                            .foregroundColor(.white)
                            .font(.normal)
                        Spacer()
                    }
                    HStack(spacing: 20){
                        Button {
                            withAnimation {
                                self.vm.metric = "ml"
                            }
                        } label: {
                            Text("ml")
                                .foregroundColor(.white.opacity(isML ? 1 : 0.6))
                                .font(.normal)
                        }
                        Button {
                            withAnimation {
                                self.vm.metric = "pc"
                            }
                        } label: {
                            Text("pc")
                                .foregroundColor(.white.opacity(isPC ? 1 : 0.6))
                                .font(.normal)
                        }
                        
                        Button {
                            withAnimation {
                                self.vm.metric = ""
                            }
                        } label: {
                            Text("custom")
                                .foregroundColor(.white.opacity(isCus ? 1 : 0.6))
                                .font(.normal)
                        }
                    }
                    
                    
                }
                .padding(8)
                .background(Color.black)
                .padding(5)
                .depthBorder()
            }
            
            if isCus, vm.baseIngredient == nil{
                TextField("Custom metric name", text: .init(get: {
                    if vm.metric != "pc", vm.metric != "ml"{
                        return vm.metric
                    }else{
                        return ""
                    }
                }, set: { newval in
                    withAnimation {
                        self.vm.metric = newval
                    }
                }))
                .font(.normal)
                .foregroundColor(.white)
                .tint(.white)
                .padding(5)
                .depthBorder()
            }
            
            HStack{
                CPButtonView(color: .orange,
                             text: "Reset",
                             enabled: true) {
                    vm.name = ""
                }
                CPButtonView(color: .green,
                             text: "Add",
                             enabled: !vm.name.isEmpty) {
                    vm.addIngredient()
                    withAnimation{
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            Spacer()
        }
        .padding()
        .backgroundWithoutSafeSpace(.darkPurple)
    }
}

struct CreateIngredientView_Previews: PreviewProvider {
    static var previews: some View {
        CreateIngredientView(onAdd: {})
            .backgroundWithoutSafeSpace(.darkPurple)
    }
}
