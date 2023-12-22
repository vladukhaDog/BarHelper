//
//  CreateCocktailView.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 09.05.2023.
//

import SwiftUI



struct CreateCocktailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject private var vm: CreateCocktailsViewModel
    @State private var showSheet = false
    init(editCocktail: Binding<DBCocktail?> = .constant(nil)){
        self._vm = .init(wrappedValue: .init(editCocktail: editCocktail))
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
        .navigationTitle(vm.toEditCocktail == nil ? "New Cocktail" : "Edit Cocktail")
        .sheet(isPresented: $showSheet) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: .init(get: {
                UIImage()
            }, set: { image in
                vm.image = image
            }))
        }
    }
    
    private var nameTextField: some View{
        TextField("", text: $vm.name, prompt: Text("Cocktail Name"))
            .font(.CBTitle)
            .foregroundColor(.white)
            .tint(.white)
            .padding(5)
            .background(Color.darkPurple)
            .depthBorder()
    }
    
    private var descriptionTextField: some View{
        CPTextEditor(text: $vm.description, placeholder: "Description")
    }
    
    private var confirmButton: some View{
        Group{
            if vm.toEditCocktail == nil{
                CPButtonView(color: .green,
                             text: "Add Cocktail",
                             enabled: (!vm.name.isEmpty &&
                                       !vm.recipe.isEmpty
                                      )) {
                    vm.add()
                    self.presentationMode.wrappedValue.dismiss()
                }
            }else{
                CPButtonView(color: .green,
                             text: "Save Cocktail",
                             enabled: true) {
                    vm.save()
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .frame(height: 80)
    }
    
    private var imageView: some View{
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
                    self.vm.image = UIPasteboard.general.image
                }
                Spacer()
            }
        }
        .padding()
        .background(Color.black)
        .padding(4)
        .depthBorder()
    }
    
    private var addedIngredients: some View{
        VStack{
            HStack{
                Text("Ingredients:")
                    .font(.smallTitle)
                    .foregroundColor(.white)
                Spacer()
                
                NavigationLink(value: Destination.Ingredients($vm.recipe)) {
                    PlusView()
                        .frame(height: 40)
                }
                
            }
            ForEach(vm.recipe.sorted(by: { l, r in
                (l.key.name ?? "") < (r.key.name ?? "")
            }), id: \.key.id){ingredient, value in
                HStack{
                    
                    HStack{
                        Text(ingredient.metric ?? "")
                            .font(.normal)
                            .foregroundColor(.white.opacity(0.5))
                        Spacer()
                        Text(ingredient.name ?? "")
                            .font(.smallTitle)
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
                        .font(.normal)
                        .foregroundColor(.pinkPurple)
                        .tint(.pinkPurple)
                        .padding(5)
                        .depthBorder()
                        .frame(width: 40)
                        Spacer()
                        Button {
                            //                            withAnimation {
                            self.vm.recipe.removeValue(forKey: ingredient)
                            //                            }
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
    
 
    
    private var typeSelector: some View{
        Group {
            if vm.types.isEmpty {
                VStack {
                    Text("No cocktail types")
                        .font(.smallTitle)
                    Button {
                        Router.shared.path.removeLast()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            Router.shared.path
                                .append(.CookingTypes)
                        }
                    } label: {
                        PlusView()
                            .frame(width: 40, height: 40)
                    }
                }
            } else {
                LazyVGrid(columns: columns){
                    ForEach(vm.types, id: \.id){type in
                        Button {
                            withAnimation() {
                                self.vm.cookType = type
                            }
                        } label: {
                            HStack{
                                Text(type.name ?? "type")
                                    .font(.smallTitle)
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
    }
}



struct CreateCocktailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            CreateCocktailView()
            
        }
        .preferredColorScheme(.dark)
    }
}


//ForEach(vm.cocktails, id: \.id){cocktail in
//    VStack{
//        Text(cocktail.name ?? "aa")
//        if let recipeSet = cocktail.recipe, let recipe = (recipeSet as? Set<DBIngredientRecord>){
//            ForEach(recipe.sorted(by: { l, r in
//                (l.ingredient?.name ?? "") > (r.ingredient?.name ?? "")
//            })){ ingredient in
//                HStack{
//                    Text(ingredient.ingredient?.name ?? "name")
//                    Text(ingredient.ingredientValue.description)
//                }
//            }
//        }
//    }
//}
