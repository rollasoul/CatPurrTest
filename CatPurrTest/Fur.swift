//
//  Fur.swift
//  CatPurrTest
//
//  Created by Roland Arnoldt on 7/22/20.
//

import SwiftUI

class Fur: ObservableObject {
    @Published var petPoint: CGPoint?
    
    @Published var hairRoots: [CGPoint] = []
    
    func generateHairRoots(geometry: GeometryProxy) {
        var horizontalIndex = 0
        while ( horizontalIndex < Int(geometry.size.height)) {
            var verticalIndex = 0
            while (verticalIndex < Int(geometry.size.width)) {
                let x = verticalIndex + Int.random(in: -100...100)
                let y = horizontalIndex + Int.random(in: -100...100)

                self.hairRoots.append(CGPoint(x: x, y: y))

                verticalIndex += 5
            }

            horizontalIndex += 15
        }
    }
    
    var AnimatedFur: Path {
        
        let furPath = Path { path in
            // non animated fur with fixed lenght
            for point in hairRoots {
                let hairRootX = point.x
                let hairRootY = point.y
                var xShift = CGFloat(0.0)
                let yShift = CGFloat(50.0)
                
                // animate hair if touched
                if (petPoint != nil) {
                    let touchPoint = petPoint ?? CGPoint(x: 0, y: 0)
                    let touchRangeY = touchPoint.y - 30 ... touchPoint.y + 30
                    let touchRangeXLeft = touchPoint.x - 30 ... touchPoint.x
                    let touchRangeXRight = touchPoint.x ... touchPoint.x + 30
                    
                    // change position of hair tip
                    if touchRangeY.contains(hairRootY) {
                        switch hairRootX {
                            case touchRangeXLeft:
                                withAnimation {
                                    xShift = -15.0
                                }
                            case touchRangeXRight:
                                withAnimation {
                                    xShift = 15.0
                                }
                            default:
                                xShift = 0.0
                        }
                    }
                }
                
                // append root and tip to path, line in-between creates hair
                path.move(to: CGPoint(x: hairRootX, y: hairRootY))
                path.addLine(to: CGPoint(x: hairRootX + xShift, y: hairRootY + yShift))
                path.closeSubpath()
            }
        }
        return furPath
    }
    
    
}
