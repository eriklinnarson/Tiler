//
//  KeystrokeManager.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-06-10.
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

final class KeybindingManager {
    lazy var keybindMappings: [Keystroke: Action] = defaultKeybindings()
    
    func getAction(for keystroke: Keystroke) -> Action? {
        let matchingKeybinding = keybindMappings.keys.first {
            var pressedModifiers = keystroke.modifiers
            pressedModifiers.remove(.numericPad)
            pressedModifiers.remove(.function)
            
            return keystroke.keyCode == $0.keyCode &&
            pressedModifiers == $0.modifiers
        }
        
        guard let matchingKeybinding, let action = keybindMappings[matchingKeybinding] else {
            return nil
        }
                
        return action
    }
    
    func getKeybinding(for action: Action) -> Keystroke? {
        let firstMatch = keybindMappings.first { _, value in
            value == action
        }
        
        return firstMatch?.key
    }
}
