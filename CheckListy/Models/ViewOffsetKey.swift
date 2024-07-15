//
//  ViewOffsetKey.swift
//  CheckListy
//
//  Created by Breno Lucas on 15/07/24.
//

import Foundation
import SwiftUI

struct ViewOffsetKey: PreferenceKey {
    
    typealias Value = CGFloat
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
    
}
