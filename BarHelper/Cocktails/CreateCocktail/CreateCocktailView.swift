//
//  CreateCocktailView.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 09.05.2023.
//

import SwiftUI
import Vision


struct CreateCocktailView: View {
    @EnvironmentObject private var router: Router
    @StateObject private var vm: CreateCocktailsViewModel
    @State private var showSheet = false
    
    init(editCocktail: DBCocktail){
        self._vm = .init(wrappedValue: .init(editCocktail: editCocktail))
    }
    
    init() {
        self._vm = .init(wrappedValue: .init())
    }
    
    init(_ viewModel: CreateCocktailsViewModel) {
        self._vm = .init(wrappedValue: viewModel)
    }
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView{
            VStack{
                imageView
                typeSelector
                nameTextField
                descriptionTextField
                addedIngredients
                confirmButton
            }
            .padding(.horizontal)
        }
        .backgroundWithoutSafeSpace(.darkPurple)
        .task {
            vm.setup(router: router)
        }
        .sheet(isPresented: $showSheet) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: .init(get: {
                UIImage()
            }, set: { image in
                vm.image = image
            }))
        }
    }
    
    private var nameTextField: some View{
        TextField("Cocktail Name", text: $vm.name)
            .cyberpunkStyle()
    }
    
    private var descriptionTextField: some View{
        CyberpunkTextField(text: $vm.description, placeholder: "Description")
    }
    
    private var confirmButton: some View{
        Group{
            if vm.mode == .create {
                Button("Add Cocktail") {
                    vm.add()
                }
                .cyberpunkStyle(.green)
            } else {
                Button("Save Cocktail") {
                    vm.save()
                }
                .cyberpunkStyle(.green)
            }
        }
        .frame(height: 80)
        .disabled(vm.name.isEmpty || vm.recipe.isEmpty)
    }
    
    private var imageView: some View {
        VStack{
            HStack{
                ForEach((1..<9)){ number in
                    Image(number.description)
                        .resizable()
                        .scaledToFit()
                        .onTapGesture {
                            vm.imagePlaceholer = number.description
                            if vm.image != nil{
                                vm.image = nil
                            }
                        }
                }
            }
            .frame(height: 80)
            HStack{
                Spacer()
                Group{
                    if let image = vm.image{
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                    }else{
                        Image(vm.imagePlaceholer)
                            .resizable()
                            .scaledToFit()
                    }
                }
                .frame(height: 150)
                .clipShape(Rectangle())
                .onTapGesture {
                    self.showSheet.toggle()
                }
                .onLongPressGesture {
                    guard let cgImage = UIPasteboard.general.image?.cgImage else {
                            return
                        }
                    let request = VNGenerateForegroundInstanceMaskRequest()
                    let handler = VNImageRequestHandler(cgImage: cgImage)
                    try? handler.perform([request])
                    guard let result = request.results?.first else {return}
                    guard let maskedImage = try? result.generateMaskedImage(
                        ofInstances: result.allInstances,
                                from: handler,
                                croppedToInstancesExtent: true
                    ) else {return}
                            
                    
                    let img = UIImage(ciImage: CIImage(cvPixelBuffer: maskedImage))
                    guard let data = img.pngData(), let uiImage = UIImage(data: data) else {return}
                    DispatchQueue.main.async {
                        self.vm.image = uiImage
                    }
                }
                Spacer()
            }
        }
        .padding()
        .background(Color.black)
        .padding(4)
        .depthBorder()
    }
    
    private var addedIngredients: some View {
        VStack{
            HStack{
                Text("Ingredients:")
                    .cyberpunkFont(.smallTitle)
                    .foregroundColor(.white)
                Spacer()
                Button {
                    router.push(Destination.IngredientsSelector($vm.recipe))
                } label: {
                    PlusView()
                        .frame(height: 50)
                }
                
            }
            ForEach(vm.recipe.sorted(by: { l, r in
                (l.key.name ?? "") < (r.key.name ?? "")
            }), id: \.key.id){ingredient, value in
                HStack{
                    
                    HStack{
                        Text(ingredient.metric ?? "")
                            .cyberpunkFont(.body)
                            .foregroundColor(.white.opacity(0.5))
                        Spacer()
                        Text(ingredient.name ?? "")
                            .cyberpunkFont(.smallTitle)
                            .foregroundColor(.white)
                            .minimumScaleFactor(0.1)
                        Spacer()
                    }
                    .padding(.horizontal, 40)
                    .overlay(HStack{
                        TextField("", text: .init(get: {
                            value.description
                        }, set: { newVal in
                            vm.recipe[ingredient] = Int(newVal) ?? 0
                        }) )
                        .keyboardType(.numberPad)
                        .cyberpunkFont(.body)
                        .foregroundColor(.pinkPurple)
                        .tint(.pinkPurple)
                        .padding(5)
                        .depthBorder()
                        .frame(width: 40)
                        Spacer()
                        Button {
                            self.vm.recipe.removeValue(forKey: ingredient)
                        } label: {
                            Rectangle()
                                .fill(Color.pinkPurple)
                                .frame(width: 20, height: 2)
                        }
                    })
                    .padding(14)
                    .border(Color.pinkPurple, width: 2)
                    
                    
                }
            }
        }
        .padding(8)
        .background(Color.black)
        .padding(5)
        .depthBorder()
    }
    
 
    
    @State private var showAddCookingMethod = false
    private var typeSelector: some View{
        Group {
            if vm.methods.isEmpty {
                VStack {
                    Text("No cocktail types")
                        .cyberpunkFont(.smallTitle)
                    Button {
                        showAddCookingMethod.toggle()
                    } label: {
                        PlusView()
                            .frame(width: 40, height: 40)
                    }
                }
            } else {
                LazyVGrid(columns: columns){
                    ForEach(vm.methods, id: \.id){type in
                        Button {
                            withAnimation() {
                                self.vm.cookType = type
                            }
                        } label: {
                            HStack{
                                Text(type.name ?? "type")
                                    .cyberpunkFont(.smallTitle)
                                    .foregroundColor(.white.opacity(vm.cookType == type ? 1 : 0.4))
                            }
                            .padding(.vertical, 5)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(5)
        .background(Color.black)
        .padding(4)
        .depthBorder()
        .sheet(isPresented: $showAddCookingMethod) {
            AddCookingMethodView()
                .presentationDetents([.medium, .large])
        }
    }
}



#Preview {
    CreateCocktailView()
        .previewWrapper()
}
