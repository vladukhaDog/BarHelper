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
    
    @Binding private var cocktail: DBCocktail
    @State private var up = false
    
    
    
    init(cocktail: Binding<DBCocktail>){
        self._cocktail = cocktail
        
        
    }
    

    var body: some View {
        ScrollView{
            VStack{
                imageView
                text
                recipe
                buttons
            }
            .padding(.horizontal, 10)
        }
        .scrollBounceBehavior(.basedOnSize)
        .id(up)
        .backgroundWithoutSafeSpace(.darkPurple)
    }
    @State private var nav = false
    private var buttons: some View{
        HStack{

            
            Button("Delete") {
                self.cocktail.deletedByUser = true
                self.cocktail = self.cocktail
                self.cocktail.objectWillChange.send()
                self.presentationMode.wrappedValue.dismiss()
            }
            .cyberpunkStyle(.red)
            
            Button("Edit") {
#warning("DISABLED NAVIGATION")
//                Router.shared.push(.EditCocktail(.init(get: {
//                    self.cocktail
//                }, set: { new in
//                    DispatchQueue.main.async{
//                        self.cocktail = new
//                        self.cocktail.objectWillChange.send()
//                    }
//                })))
            }
            .cyberpunkStyle(.orange)
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
            Text(cocktail.cookingMethod?.name ?? "CookingMethod")
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
                        RecipeIngredientCell(ingredient: ingredient)
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
        return NavigationView{CocktailView(cocktail: .constant(cocktail))}.preferredColorScheme(.dark)
    }
}


struct RecipeIngredientCell: View{
    let ingredient: DBIngredientRecord
    @State private var showingAlternatives = false
    @Namespace private var animation
    var body: some View{
        VStack(alignment: .leading){
            Button {
                withAnimation {
                    showingAlternatives.toggle()
                }
            } label: {
                HStack{
                    if !showingAlternatives{
                        if ingredient.ingredient?.parentIngredient != nil || (ingredient.ingredient?.alternatives?.count ?? 0) > 0{
                            Text("*")
                                .font(.smallTitle)
                        }
                        Text(ingredient.ingredient?.name ?? "Booze")
                            .font(.smallTitle)
                            .multilineTextAlignment(.leading)
                            
                                            .minimumScaleFactor(0.99)
                            .matchedGeometryEffect(id: "UsedIngredient", in: animation)
                    }
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
            }
            .disabled(ingredient.ingredient?.parentIngredient == nil && (ingredient.ingredient?.alternatives?.count ?? 0) == 0)

            if showingAlternatives{
                alternatives
            }
        }
        .foregroundColor(.white)
    }
    
    private var alternatives: some View{
        VStack(alignment: .leading){
            if let parentIngredient = ingredient.ingredient?.parentIngredient ?? ingredient.ingredient,
               let ingredientsSet = parentIngredient.alternatives,
               let ingredients = ingredientsSet as? Set<DBIngredient>{
                let ingredientsSorted = ingredients.sorted { l, r in
                    ( l.name ?? "") < (r.name ?? "")
                }
                let array = ([parentIngredient] + ingredientsSorted)
                ForEach(array, id: \.id){ingredientAlternative in
                    if ingredient.ingredient == ingredientAlternative{
                        Text(ingredientAlternative.name ?? "Booze")
                            .font(.normal)
                            .multilineTextAlignment(.leading)
//                            .lineLimit(1)
                                            .minimumScaleFactor(0.9)
                            .matchedGeometryEffect(id: "UsedIngredient", in: animation)
                    }else{
                        Text(ingredientAlternative.name ?? "Booze")
                            .font(.normal)
                            .multilineTextAlignment(.leading)
                            .opacity(0.75)
                    }
                    
                }
            }
        }
    }
}
