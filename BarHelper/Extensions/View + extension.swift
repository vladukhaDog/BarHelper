//
//  View + extension.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 11.05.2023.
//

import Foundation
import SwiftUI

struct Ext_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            Spacer()
            Color.darkPurple
                .depthBorderUp()
                .padding()
                .frame(width: 100, height: 100)
            Spacer()
            HStack{
                Spacer()
            }
        }
        .backgroundWithoutSafeSpace(Color.darkPurple)
    }
}
extension View{
    
    func navigationBarTitleTextColor(_ color: Color) -> some View {
        let uiColor = UIColor(color)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor , .font: UIFont(name: "CyberpunkWaifus", size: 22) ?? .systemFont(ofSize: 22)]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor , .font: UIFont(name: "CyberpunkWaifus", size: 22) ?? .systemFont(ofSize: 22)]
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "CyberpunkWaifus", size: 25) ?? .systemFont(ofSize: 22)], for: .normal)
        return self
    }
    
    func backgroundWithoutSafeSpace(_ color: Color) -> some View{
        ZStack{
            color.ignoresSafeArea()
            self
        }
    }
    func depthBorder(width: Double = 5.0) -> some View{
        let dopacity = 0.1
        let lopacity = 0.02
        return ZStack{
            self
                .overlay(VStack(spacing: 0){
                    Rectangle()
                        .fill(Color.black)
                        .frame(height: width)
                        .opacity(dopacity)
                    HStack(spacing: 0){
                        Rectangle()
                            .fill(Color.black)
                            .frame(width: width)
                            .opacity(dopacity)
                        Spacer()
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: width)
                            .opacity(lopacity)
                    }
                    
                    Rectangle()
                        .fill(Color.white)
                        .frame(height: width)
                        .opacity(lopacity)
                })
               
        }
    }
    
    func depthBorderUp(noBottom: Bool = false) -> some View{
        let width = 5.0
        let dopacity = 0.02
        let lopacity = 0.1
        return ZStack{
            self
                .overlay(VStack(spacing: 0){
                    Rectangle()
                        .fill(Color.white)
                        .frame(height: width)
                        .opacity(dopacity)
                    HStack(spacing: 0){
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: width)
                            .opacity(dopacity)
                        Spacer()
                        Rectangle()
                            .fill(Color.black)
                            .frame(width: width)
                            .opacity(lopacity)
                    }
                    
                    if !noBottom{
                        Rectangle()
                            .fill(Color.black)
                            .frame(height: width)
                            .opacity(lopacity)
                    }
                })
               
        }
    }
        
    
}
