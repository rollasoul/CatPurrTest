//
//  FurView.swift
//  CatPurrTest
//
//  Created by Roland Arnoldt on 7/21/20.
//

import SwiftUI

struct FurView: View {
    
    @ObservedObject var fur: Fur
    
    var body: some View {
        GeometryReader { geometry in
            fur.AnimatedFur
            .stroke(style: StrokeStyle(lineWidth: 0.2, lineCap: .round, lineJoin: .round))
            .foregroundColor(.yellow)
            .background(Color.gray)
            .onAppear {
                fur.generateHairRoots(geometry: geometry)
            }
        }
    }
}

struct FurView_Previews: PreviewProvider {
    static var previews: some View {
        FurView(fur: Fur())
    }
}
