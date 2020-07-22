//
//  ContentView.swift
//  CatPurrTest
//
//  Created by Roland Arnoldt on 7/19/20.
//

import SwiftUI
import CoreHaptics

struct ContentView: View {
    @ObservedObject var fur = Fur()
    var ignoreGestureRange = -300...300
    
    var body: some View {
        ZStack {
            FurView(fur: fur)
                .onAppear(perform: Purr.prepareHaptics)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    Purr.prepareHaptics()
                }
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            self.fur.petPoint = gesture.location
                        }
                        .onEnded { gesture in
                            self.fur.petPoint = nil
                            if !ignoreGestureRange.contains(Int(gesture.translation.height)) {
                                Purr.petSuccess()
                            }
                        }
                )
            
            HStack {
                Image(systemName: "hand.draw")
                Text("Pet Me")
            }
            .foregroundColor(.white)
            .font(.largeTitle)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
