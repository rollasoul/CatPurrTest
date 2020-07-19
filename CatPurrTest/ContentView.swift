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
        HStack {
            Image(systemName: "ant")
                .padding()
                .font(.headline)
            Text("purr")
                .font(.headline)
                .padding()
                .font(.headline)
                .onAppear(perform: prepareHaptics)
                .onTapGesture(perform: complexSuccess)
        }
        .padding()
        .font(.headline)
        .background(Color.yellow)
        .clipShape(Capsule())
        .shadow(radius: 10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
