//
//  ShapeExtensions.swift
//  PinTinView
//
//  Created by Dmitry Zawadsky on 13.07.2021.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Shape {
    
    //    /// Fills and adds border to shapre as it was selected
    //    ///
    //    /// - Parameters:
    //    ///   - content: The color or gradient to use when filling this shape.
    //    ///   - border: The color or gradient to use when bordering this shape.
    //    /// - Returns: A shape filled with the color or gradient you supply.
    //    @inlinable public func select<S>(_ content: S = Color.gray as! S,
    //                                     border: S = Color.gray as! S) -> some View where S : ShapeStyle {
    //        fill(content)
    //            .border(border, width: 1)
    //    }
    
    /// Fills and adds border to shapre as it was selected
    ///
    /// - Parameters:
    ///   - content: The color or gradient to use when filling this shape.
    ///   - border: The color or gradient to use when bordering this shape.
    /// - Returns: A shape filled with the color or gradient you supply.
    dynamic func select(_ isSelected: Bool = false) -> some View {
        ZStack {
            fill(isSelected ? Color.blue : Color.clear)
                .frame(width: isSelected ? 20 : 0, height: isSelected ? 20 : 0, alignment: .center)
                .animation(.interpolatingSpring(mass: 1, stiffness: 350, damping: 20, initialVelocity: 10))
        }
    }
}
