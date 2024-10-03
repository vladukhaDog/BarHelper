//
//  EditCookingMethodView.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 03.10.2024.
//

import SwiftUI

struct EditCookingMethodView: View {
    private let method: CookingMethod
    init(_ method: CookingMethod) {
        self.method = method
    }
    
    var body: some View {
        VStack{
            Text(method.name ?? "NO TYPE")
                .cyberpunkFont(.title)
            HStack{
                Button("Cancel") {
                    
                }
                    .cyberpunkStyle(.gray)
                Button("Delete") {
                    //                    guard let t = vm.methodToView else {return}
                    //                    vm.deleteMethod(method: t)
                }
                    .cyberpunkStyle(.red)
                
            }
            Spacer()
        }
        .padding()
        .backgroundWithoutSafeSpace(.darkPurple)
    }
}

#Preview {
    Color.darkPurple
        .sheet(isPresented: .constant(true)) {
            EditCookingMethodView(MockData.mockCookingMethod())
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
}
