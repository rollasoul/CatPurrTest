//
//  ContentView.swift
//  CatPurrTest
//
//  Created by Roland Arnoldt on 7/19/20.
//

import SwiftUI
import CoreHaptics

struct ContentView: View {
    @State private var engine: CHHapticEngine?
    @State private var petPoint: CGPoint?
    @State private var hairRoots: [CGPoint] = []
    @State private var purrResourceId: CHHapticAudioResourceID?
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            self.engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error: \(error.localizedDescription)")
        }
    }
    
    func petSuccess() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        guard let purrUrl = Bundle.main.url(forResource: "purr", withExtension: "m4a") else {
            return
        }
        
        // create a dull, strong haptic
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0)
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        
        // create a curve that fades from 1 to 0 over one second
        let start = CHHapticParameterCurve.ControlPoint(relativeTime: 0, value: 1)
        let middle = CHHapticParameterCurve.ControlPoint(relativeTime: 1, value: 1)
        let end = CHHapticParameterCurve.ControlPoint(relativeTime: 3, value: 0)
        
        // use that curve to control the haptic strength
        let parameter = CHHapticParameterCurve(parameterID: .hapticIntensityControl, controlPoints: [start, middle, end], relativeTime: 0)
        
        do {
            if (self.purrResourceId != nil) {
                try engine?.unregisterAudioResource(self.purrResourceId!)
            }
            self.purrResourceId = try engine?.registerAudioResource(purrUrl, options: [:])
            
            // create a continuous haptic event starting immediately
            let events = [
                CHHapticEvent(audioResourceID: self.purrResourceId!, parameters: [], relativeTime: 0, duration: 3),
                CHHapticEvent(eventType: .hapticContinuous, parameters: [sharpness, intensity], relativeTime: 0, duration: 3)
            ]
            
            // convert into pattern
            let pattern = try CHHapticPattern(events: events, parameterCurves: [parameter])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("didnt work: \(error.localizedDescription)")
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                for point in self.hairRoots {
                    let x = point.x
                    let y = point.y
                    var xShift = CGFloat(0.0);
                    
                    if (self.petPoint != nil) {
                        if (y < self.petPoint!.y + 30 && y > self.petPoint!.y - 30) {
                            if (x > self.petPoint!.x - 30 && x < self.petPoint!.x) {
                                xShift = -10.0
                            }
                            if (x < self.petPoint!.x + 30 && x > self.petPoint!.x) {
                                xShift = 10.0
                            }
                        }
                    }
                    
                    path.move(to: CGPoint(x: x, y: y))
                    path.addLine(to: CGPoint(x: x + xShift, y: y + 40))
                    path.closeSubpath()
                }
            }
            .stroke(lineWidth: 2.0)
            .onAppear {
                var r = 0
                while (r < Int(geometry.size.height)) {
                    var c = 0
                    while (c < Int(geometry.size.width)) {
                        let x = c + Int.random(in: -5...5)
                        let y = r + Int.random(in: -5...5)
                        
                        self.hairRoots.append(CGPoint(x: x, y: y))
                        
                        c += 2
                    }
                    
                    r += 25
                }
            }
        }
        .onAppear(perform: self.prepareHaptics)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    self.petPoint = gesture.location
            }
            .onEnded { gesture in
                self.petPoint = nil
                
                if (gesture.translation.height > 300) {
                    self.petSuccess()
                }
            }
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
