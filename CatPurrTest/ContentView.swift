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
    @State private var showingAlert = false
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            self.engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error: \(error.localizedDescription)")
        }
    }
    
    func complexSuccess() {
        // make sure the
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()
        
        // create one intense sharp tap
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 0, duration: 20)
        events.append(event)
        
        // convert into pattern
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
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
        .onTapGesture(perform: self.complexSuccess)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    self.petPoint = gesture.location
            }
            .onEnded { gesture in
                self.petPoint = nil
                
                if (gesture.translation.height > 300) {
                    self.showingAlert = true
                }
            }
        )
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("NICE PET!"), message: Text("MOAR PETS PLZ"), dismissButton: .default(Text("Got it!")))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
