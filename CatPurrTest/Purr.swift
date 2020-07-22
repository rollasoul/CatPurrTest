//
//  Purr.swift
//  CatPurrTest
//
//  Created by Roland Arnoldt on 7/22/20.
//

import SwiftUI
import CoreHaptics

struct Purr {
    static var engine: CHHapticEngine?
    static var purrResourceId: CHHapticAudioResourceID?
    
    // prepare haptics engine
    static func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            // reset engine and audio-id in case app comes back into foreground
            if engine != nil {
                engine?.stop()
                self.engine = nil
                purrResourceId = nil
            }
            self.engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error: \(error.localizedDescription)")
        }
    }
    
    // vibrate in a purring pattern
    static func petSuccess() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        guard let purrUrl = Bundle.main.url(forResource: "purr", withExtension: "m4a") else { return }
        
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
}
