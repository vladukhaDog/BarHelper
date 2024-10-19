//
//  AddCookingMethodView.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 06.10.2024.
//

import SwiftUI

extension AddCookingMethodView where VM == AddCookingMethodViewModel {
    init() {
        self.init(vm: AddCookingMethodViewModel())
    }
}

struct AddCookingMethodView<VM>: View where VM: AddCookingMethodViewModelProtocol {
    @StateObject private var vm: VM
    @Environment(\.presentationMode) var presentationMode
    @FocusState private var nameIsFocused: Bool
    
    internal init(vm: VM) {
        self._vm = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        VStack {
            TextField("",
                      text: $vm.methodName,
                      prompt: Text("Method name"))
            .cyberpunkStyle(focusState: $nameIsFocused)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    nameIsFocused = true
                }
            }
            CyberpunkTextField(text: $vm.description, placeholder: "Method description")
            
            Button("Save") {
                self.vm.addMethod()
                self.presentationMode.wrappedValue.dismiss()
            }
            .cyberpunkStyle(.green)
            .disabled(vm.methodName.isEmpty)
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

private final class MockViewModel: AddCookingMethodViewModelProtocol {
    @Published var methodName: String = ""
    @Published var description: String = ""
    func addMethod() {
    }
}

#Preview {
    @Previewable @State var open: Bool = true
    Color.darkPurple
        .onTapGesture {
            open.toggle()
        }
        .sheet(isPresented: $open) {
            AddCookingMethodView(vm: MockViewModel())
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
}
