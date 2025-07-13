//
//  Keystroke.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-07-05.
//

import AppKit

struct Keystroke: Hashable, Codable {
    let keyCode: UInt16
    var modifiers: NSEvent.ModifierFlags {
        NSEvent.ModifierFlags(rawValue: modifiersRaw)
    }
    
    private var modifiersRaw: UInt
    
    init(keyCode: UInt16, modifiers: NSEvent.ModifierFlags) {
        self.keyCode = keyCode
        self.modifiersRaw = modifiers.rawValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(keyCode)
        hasher.combine(modifiers.rawValue)
    }
}
