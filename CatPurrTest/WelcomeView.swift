//
//  WelcomeView.swift
//  CatPurrTest
//
//  Created by Roland Arnoldt on 7/24/20.
//

import SwiftUI

struct WelcomeView: View {
    @ObservedObject var fur: Fur
    @Binding var hideWelcomeView: Bool
    
    var body: some View {
        VStack {
            Group {
                Text("Hello, 🐈 Lovers!")
                    .font(.headline)
                
                Text("We are JOYLAB, bringing joy to the world with all kinds of art, tech and design. And we love cats. So do you, that's a great match!")
                
                Text("Now here is how to use CatPurr in 3 seconds: Turn on some Netflix or whatever you like, place your phone on your chest and pet the cat.")
            }
            .font(.headline)
            .foregroundColor(.secondary)
            .padding()
            
            Button("meow!") {
                hideWelcomeView = true
                UserDefaults.standard.set(hideWelcomeView, forKey: "hideWelcomeView")
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.gray)
            .clipShape(Capsule())
            .shadow(radius: 5)
        }
    }
}

//struct WelcomeView_Previews: PreviewProvider {
//    static var fur = Fur()
//    static var hideWelcomeScreen = false
//
//    static var previews: some View {
//        WelcomeView(fur: fur, hideWelcomeView: )
//    }
//}
