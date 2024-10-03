//
//  EditCookingMethodView.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 03.10.2024.
//

import SwiftUI

extension EditCookingMethodView where VM == EditCookingMethodViewModel {
    init(_ method: CookingMethod) {
        self.init(vm: EditCookingMethodViewModel(method))
    }
}

/// Bottom sheet with more information about the method, editable text fields and deletion
struct EditCookingMethodView<VM>: View where VM: EditCookingMethodViewModelProtocol {
    @StateObject private var vm: VM
    @Environment(\.presentationMode) var presentationMode
    
    internal init(vm: VM) {
        self._vm = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        VStack {
            TextField("",
                      text: $vm.methodName,
                      prompt: Text("Method name"))
                .cyberpunkStyle()
            CPTextEditor(text: $vm.description, placeholder: "Method description")
            HStack {
                Button("Delete") {
                    self.vm.deleteMethod()
                    self.presentationMode.wrappedValue.dismiss()
                }
                .cyberpunkStyle(.red)
                Button("Cancel") {
                    self.presentationMode.wrappedValue.dismiss()
                }
                .cyberpunkStyle(.mint)
            }
            Group {
                if vm.methodName != (vm.method.name ?? "") ||
                    vm.description != (vm.method.desc ?? "") {
                    Button("Save") {
                        self.vm.editMethod()
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    .cyberpunkStyle(.green)
                    .transition(.opacity
                        .combined(with:
                                .scale(0.8, anchor: .top))
                    )
                }
            }
            
            Spacer()
        }
        .padding()
        .presentationCornerRadius(0)
        .backgroundWithoutSafeSpace(.darkPurple)
        .depthBorderUp(noBottom: true)
        .animation(.bouncy(duration: 0.3, extraBounce: 0.1), value: vm.methodName)
        .animation(.bouncy(duration: 0.3, extraBounce: 0.1), value: vm.description)
    }
}

#Preview {
    @Previewable @State var open: Bool = true
    Color.darkPurple
        .onTapGesture {
            open.toggle()
        }
        .sheet(isPresented: $open) {
            EditCookingMethodView(MockData.mockCookingMethod())
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
}
