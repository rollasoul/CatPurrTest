//
//  Cattributes.swift
//  CatPurrTest
//
//  Created by Roland Arnoldt on 8/2/20.
//

import Foundation
import SwiftUI
import CoreHaptics

class Cats: ObservableObject {
    @Published var collection: [String] = []
    @Published var chosenCat: String = ""
    @Published var loadedCats: [Cat] = []
}

struct Cat {
    var name: String
    var cattributes: Cattributes
    
    struct Cattributes {
        var haptics: hapticProperty
        var purrResource: String
        var furAttributes: furProperty
    }
    
    struct hapticProperty {
        var sharpness: Float
        var intensity: Float
        var pattern: String
    }

    struct furProperty {
        var firstColor: Color
        var secondColor: Color
        var shape: String
    }
}

// some example cats to test with

struct AriFancybeast {
    static var name = "Ari Fancybeast"
    
    static var firstColor = Color.green
    static var secondColor = Color.pink
    static var shape = "stroke"
    
    static var sharpness: Float = 1.0
    static var intensity: Float = 1.0
    static var pattern = "continuous"
    
    static var purrResource = "purr.m4a"
    
    var cat = Cat(name: name, cattributes: Cat.Cattributes.init(haptics: Cat.hapticProperty.init(sharpness: sharpness, intensity: intensity, pattern: pattern), purrResource: purrResource, furAttributes: Cat.furProperty.init(firstColor: firstColor, secondColor: secondColor, shape: shape)))
}

struct TamaHornpoopsie {
    static var name = "Tama Hornpoopsie"
    
    static var firstColor = Color.blue
    static var secondColor = Color.red
    static var shape = "stroke"
    
    static var sharpness: Float = 1.0
    static var intensity: Float = 1.0
    static var pattern = "continuous"
    
    static var purrResource = "purr.m4a"
    
    var cat = Cat(name: name, cattributes: Cat.Cattributes.init(haptics: Cat.hapticProperty.init(sharpness: sharpness, intensity: intensity, pattern: pattern), purrResource: purrResource, furAttributes: Cat.furProperty.init(firstColor: firstColor, secondColor: secondColor, shape: shape)))
}

struct SwiftCelestial {
    static var name = "Swift Celestial"
    
    static var firstColor = Color.yellow
    static var secondColor = Color.orange
    static var shape = "stroke"
    
    static var sharpness: Float = 1.0
    static var intensity: Float = 1.0
    static var pattern = "continuous"
    
    static var purrResource = "purr.m4a"
    
    var cat = Cat(name: name, cattributes: Cat.Cattributes.init(haptics: Cat.hapticProperty.init(sharpness: sharpness, intensity: intensity, pattern: pattern), purrResource: purrResource, furAttributes: Cat.furProperty.init(firstColor: firstColor, secondColor: secondColor, shape: shape)))
}
