//
//  ShakeEffect.swift
//  PinTinView
//
//  Created by Dmitry Zawadsky on 19.07.2021.
//

import SwiftUI

struct ShakeEffect: GeometryEffect {
    
    var position: CGFloat
    var animatableData: CGFloat {
        get { position }
        set { position = newValue }
    }
    
    init(shakes: Int) {
        position = CGFloat(shakes)
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: -10 * sin(position * 2 * .pi), y: 0))
    }
}
