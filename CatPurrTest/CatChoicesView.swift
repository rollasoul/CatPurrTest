//
//  CatChoicesView.swift
//  CatPurrTest
//
//  Created by Roland Arnoldt on 8/2/20.
//

import SwiftUI

struct CatChoicesView: View {
    @ObservedObject var cats: Cats
    @Binding var showingCatChoiceSheet: Bool
    @State private var imagePlaceholder = Image(systemName: "xmark.icloud")
    
    func loadCattributes(cat: String) {
        switch cat {
        case "Ari FancyBeast":
            cats.loadedCats.append(AriFancybeast().cat)
        case "Tama Hornpoopsie":
            cats.loadedCats.append(TamaHornpoopsie().cat)
        case "Swift Celestial":
            cats.loadedCats.append(SwiftCelestial().cat)
        default:
            cats.loadedCats.append(AriFancybeast().cat)
        }
    }
    
    var body: some View {
        VStack {
            Text("Choose your Kitty")
                .font(.largeTitle)
                .padding()
            ForEach(cats.collection, id: \.self) {cat in
                Button(action: {
                    cats.chosenCat = cat
                    loadCattributes(cat: cat)
                    showingCatChoiceSheet = false
                }) {
                    HStack {
                        imagePlaceholder
                        Text(cat)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.secondary)
                    .clipShape(Capsule())
                }
            }
        }
        .onAppear {
            loadAPIData(cats: cats)
            print("cats: \(cats.collection)")
        }
    }
}

//struct CatChoicesView_Previews: PreviewProvider {
//    static var previews: some View {
//        CatChoicesView(cats: Cats(), showingCatChoiceSheet: $showingCatChoiceSheet)
//    }
//}
