//
//  BindingExtensions.swift
//  PinTinView
//
//  Created by Dmitry Zawadsky on 19.07.2021.
//

import SwiftUI

extension Binding {
    
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: {
                self.wrappedValue
            },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}
