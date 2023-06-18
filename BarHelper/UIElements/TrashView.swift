//
//  TrashView.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 18.06.2023.
//

import SwiftUI

struct TrashView: View {
    @State private var lineSize = 0.0
    var body: some View {
        VStack{
            border
                .opacity(0.8)
                .overlay(
                    TrashShape()
                        .stroke(currentColor, lineWidth: lineSize)                            .padding(lineSize * 4)
                )
        }
        .aspectRatio(0.9, contentMode: .fit)
        .background(
            GeometryReader(content: { proxy in
                Color.clear
                    .onAppear{
                        lineSize = proxy.size.width/20
                    }
                    .onChange(of: proxy.size.width) { newValue in
                        lineSize = proxy.size.width/20
                    }
            })
        )
    }
    private var currentColor: Color{
        Color(uiColor: UIColor.systemRed)
    }
    
    private var border: some View{
        VStack{
            horizontalLine
            Spacer()
            horizontalLine
        }
        .overlay(HStack{
            verticalLine
            Spacer()
            verticalLine
        })
        
    }
    
    private var verticalLine: some View{
        
        VStack(spacing: 0){
            Color.clear
                .aspectRatio(1.0, contentMode: .fit)
            currentColor
            Color.clear
                .aspectRatio(1.0, contentMode: .fit)
        }
        .frame(width: lineSize)
        
    }
    
    private var horizontalLine: some View{
        
        HStack(spacing: 0){
            Color.clear
                .aspectRatio(1.0, contentMode: .fit)
            currentColor
            Color.clear
                .aspectRatio(1.0, contentMode: .fit)
        }
        .frame(height: lineSize)
        
    }
}

struct TrashView_Previews: PreviewProvider {
    static var previews: some View {
        TrashView()
            .backgroundWithoutSafeSpace(.darkPurple)
    }
}

struct TrashShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width/10
        let h = rect.height/12
        
        //Lid
        path.move(to: CGPoint(x: rect.minX, y: h*2))
        path.addLine(to: CGPoint(x: rect.maxX, y: h*2))
        //hand
        path.move(to: CGPoint(x: w*3, y: h*2))
        path.addLine(to: CGPoint(x: w*3, y: rect.minY))
        path.addLine(to: CGPoint(x: w*7, y: rect.minY))
        path.addLine(to: CGPoint(x: w*7, y: h*2))
        
        //bin
        path.move(to: CGPoint(x: w*1.5, y: h*2))
        path.addLine(to: CGPoint(x: w*1.5, y: h*12))
        path.addLine(to: CGPoint(x: w*8.5, y: h*12))
        path.addLine(to: CGPoint(x: w*8.5, y: h*2))
        
        //middle line
        path.move(to: CGPoint(x: w*5, y: h*4))
        path.addLine(to: CGPoint(x: w*5, y: h*10))
        
        //left line
        path.move(to: CGPoint(x: w*3, y: h*4))
        path.addLine(to: CGPoint(x: w*3, y: h*10))
        
        //right line
        path.move(to: CGPoint(x: w*7, y: h*4))
        path.addLine(to: CGPoint(x: w*7, y: h*10))
        return path
    }
}
