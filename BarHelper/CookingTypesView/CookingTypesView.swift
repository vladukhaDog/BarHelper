//
//  CookingMethodsView.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 09.05.2023.
//

import SwiftUI

struct CookingMethodsView: View {
    @StateObject private var vm = CookingMethodsViewModel()
    @State private var showAdd = false
    var body: some View {
        VStack{
            ScrollView{
                VStack{
                    HStack{
                        Spacer()
                    }
                    ForEach(vm.types){type in
                        HStack{
                            Button {
                                vm.typeToDelete = type
                            } label: {
                                Text(type.name ?? "")
                                    .font(.smallTitle)
                                    .foregroundColor(.white)
                                    
                            }

                        }
                        .padding(5)
                    }
                }
                .padding(.horizontal, 5)
            }
            .background(Color.black)
            .padding(5)
            .depthBorder()
            .padding(5)
            .sheet(item: $vm.typeToDelete) { item in
                deleteTypeConfirm
                    .presentationDetents([.medium, .large])
            }
            HStack{
                Spacer()
                CPButtonView(color: .green,
                             text: "Add",
                             enabled: true,
                             action: {
                    showAdd.toggle()
                })
                .frame(width: 150)
                .sheet(isPresented: $showAdd) {
                    addCookingMethod
                    .presentationDetents([.medium, .large])
                }
            }
            .padding(.horizontal)
            
        }
        .backgroundWithoutSafeSpace(.darkPurple)
        .navigationTitle("Cooking types")
    }
    
    private var deleteTypeConfirm: some View{
        VStack{
            Text(vm.typeToDelete?.name ?? "NO TYPE")
                .font(.CBTitle)
            HStack{
                CPButtonView(color: .gray,
                             text: "Cancel",
                             enabled: true,
                             action: {
                    vm.typeToDelete = nil
                })
                CPButtonView(color: .red,
                             text: "Delete",
                             enabled: true,
                             action: {
                    guard let t = vm.typeToDelete else {return}
                    vm.deleteType(type: t)
                })
                
            }
            Spacer()
        }
        .padding()
        .backgroundWithoutSafeSpace(.darkPurple)
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
                CPButtonView(color: .orange,
                             text: "Reset",
                             enabled: true,
                             action: {
                    vm.name = ""
                })

                CPButtonView(color: .green,
                             text: "Add",
                             enabled: true,
                             action: {
                    showAdd = false
                    vm.addCookingMethod()
                })
            }
            Spacer()
        }
        .padding()
        .backgroundWithoutSafeSpace(.darkPurple)
    }
}

struct CookingMethodsView_Previews: PreviewProvider {
    static var previews: some View {
        CookingMethodsView()
    }
}
