//
//  FurView.swift
//  CatPurrTest
//
//  Created by Roland Arnoldt on 7/21/20.
//

import SwiftUI

struct FurView: View {
    @ObservedObject var cats: Cats
    @ObservedObject var fur: Fur
    @State private var showingCatChoiceSheet = false
    
    var body: some View {
        GeometryReader { geometry in
            fur.AnimatedFur
            .stroke(style: StrokeStyle(lineWidth: 0.2, lineCap: .round, lineJoin: .round))
                .foregroundColor(cats.loadedCats.isEmpty ? .yellow : cats.loadedCats.first(where: {$0.name == cats.chosenCat})?.cattributes.furAttributes.firstColor)
                .background(cats.loadedCats.isEmpty ? .gray : cats.loadedCats.first(where: {$0.name == cats.chosenCat})?.cattributes.furAttributes.secondColor)
            .onAppear {
                fur.generateHairRoots(geometry: geometry)
            }
            .onLongPressGesture {
                showingCatChoiceSheet = true
            }
            .sheet(isPresented: $showingCatChoiceSheet) {
                CatChoicesView(cats: cats, showingCatChoiceSheet: $showingCatChoiceSheet)
            }
        }
    }
}

struct FurView_Previews: PreviewProvider {
    static var previews: some View {
        FurView(cats: Cats(), fur: Fur())
    }
}
