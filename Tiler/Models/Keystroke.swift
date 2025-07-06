//
//  Keystroke.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-07-05.
//

import AppKit

struct Keystroke: Hashable {
    let keyCode: UInt16
    let modifiers: NSEvent.ModifierFlags
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(keyCode)
        hasher.combine(modifiers.rawValue)
    }
}
