//
//  KeystrokeListener.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-07-05.
//

import Foundation

final class KeystrokeListener {
    @Published private(set) var keystroke: Keystroke? = nil
    
    func keystrokeWasCalled(_ keystroke: Keystroke) {
        self.keystroke = keystroke
    }
}
