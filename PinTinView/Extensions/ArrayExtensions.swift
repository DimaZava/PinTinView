//
//  ArrayExtensions.swift
//  PinTinView
//
//  Created by Dmitry Zawadsky on 13.07.2021.
//

import Foundation

extension Collection {
    
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
    
    subscript(safe offset: Int) -> Element? {
        offset >= 0 && offset < count ? self[index(startIndex, offsetBy: offset)] : nil
    }
}
