//
//  CocktailView.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 10.05.2023.
//

import SwiftUI

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}

struct CocktailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var cocktail: DBCocktail
    private let updatedCocktail: ((DBCocktail) -> ())?
    private let deleteCocktail: ((DBCocktail) -> ())?
    @State private var up = false
    
    
    
    init(cocktail: DBCocktail, didUpdate: ((DBCocktail) -> ())? = nil, deleteCocktail: ((DBCocktail) -> ())? = nil){
        self.deleteCocktail = deleteCocktail
        self.updatedCocktail = didUpdate
        self._cocktail = .init(initialValue: cocktail)
        
        
    }
    
    private func didUpdateCocktail(_ newCocktail: DBCocktail){
        DispatchQueue.main.async {
            self.cocktail = newCocktail
            up.toggle()
        }
        self.updatedCocktail?(newCocktail)
    }
    
    var body: some View {
        VStack{


            imageView
            text
            recipe
            buttons
        }
        .padding(.horizontal, 10)
        .id(up)
        .backgroundWithoutSafeSpace(.darkPurple)
    }
    @State private var nav = false
    private var buttons: some View{
        HStack{
            NavigationLink(isActive: $nav) {
                CreateCocktailView(editCocktail: cocktail, didEditCocktail: didUpdateCocktail)
            } label: {
                EmptyView()
            }
            .hidden()
            if self.deleteCocktail != nil{
                CBButtonView(color: .red, text: "Delete", enabled: true) {
                    self.deleteCocktail?(cocktail)
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
            CBButtonView(color: .orange, text: "Edit", enabled: true) {
                nav.toggle()
            }
        }
        .padding()
        .background(Color.black)
        .depthBorder()
        .padding(5)
    }
    
    private var text: some View{
        VStack(alignment: .leading, spacing: 20){
            HStack{
                Spacer()
            }
            Text(cocktail.cookingType?.name ?? "CookingType")
                .font(.smallTitle)
                .multilineTextAlignment(.leading)
            Text(cocktail.desc ?? "CocktailDescription")
                .multilineTextAlignment(.leading)
                .font(.normal)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(10)
        .frame(maxWidth: .infinity)
        .background(Color.black)
        .padding(5)
        .depthBorder()
    }
    
    private var recipe: some View{
        Group{
            if let recipeSet = cocktail.recipe,
               let recipe = recipeSet as? Set<DBIngredientRecord>{
                let recipeSorted = recipe.sorted { l, r in
                    if (l.ingredientValue) == (r.ingredientValue){
                        return ((l.ingredient?.name ?? "") > (r.ingredient?.name ?? ""))
                    }else{
                        return (l.ingredientValue) > (r.ingredientValue)
                    }
                }
                VStack{
                    ForEach(recipeSorted){ingredient in
                        HStack{
                            Text(ingredient.ingredient?.name ?? "Booze")
                                .font(.smallTitle)
                                .multilineTextAlignment(.leading)
                            Spacer()
                                .overlay(
                                    Line()
                                        .stroke(
                                            Color.white,
                                            style: StrokeStyle(
                                                lineWidth: 2,
                                                lineCap: .square,
                                                lineJoin: .miter,
                                                miterLimit: 0,
                                                dash: [2, 10],
                                                dashPhase: 0
                                            )
                                        )
                                        .frame(height: 2)
                                        .padding(.horizontal, 8)
                                )
                            Text(ingredient.ingredientValue.description)
                                .font(.smallTitle)
                                .multilineTextAlignment(.trailing)
                            Text(ingredient.ingredient?.metric ?? "ml")
                                .font(.normal)
                        }
                        .foregroundColor(.white)
                    }
                }
                .padding()
                .background(Color.black)
                .padding(5)
                .depthBorder()
                
            }
        }
    }
    
    private var imageView: some View{
        HStack{
            Group{
                if let imageName = cocktail.image?.fileName,
                   let imageData = try? Data(contentsOf: FileManager.default.temporaryDirectory.appendingPathComponent(imageName)),
                   let image = UIImage(data: imageData){
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                }else{
                    Image("1")
                        .resizable()
                        .scaledToFit()
                }
            }
            .frame(maxWidth: 150, maxHeight: 150)
            .clipShape(Rectangle())
            Text(cocktail.name ?? "CocktailName")
                .font(.CBTitle)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity)
        .padding(5)
        .background(Color.black)
        .padding(5)
        .depthBorder()
    }
}

struct CocktailView_Previews: PreviewProvider {
    
    static var previews: some View {
        let cocktail: DBCocktail
        cocktail = .init(context: DBManager.shared.backgroundContext)
        cocktail.name = "Cocktail name"
        cocktail.desc = "Description lognga nfksjelfnajck nbjfkaewljndkvsjernva ejk"
        let ingredientRecord = DBIngredientRecord(context: DBManager.shared.backgroundContext)
        let ingredient = DBIngredient(context: DBManager.shared.backgroundContext)
        ingredient.name = "Ingredient name"
        ingredientRecord.ingredient = ingredient
        ingredientRecord.ingredientValue = 30
        cocktail.addToRecipe(ingredientRecord)
        return NavigationView{CocktailView(cocktail: cocktail)}.preferredColorScheme(.dark)
    }
}
