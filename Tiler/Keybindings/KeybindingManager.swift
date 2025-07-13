//
//  KeystrokeManager.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-06-10.
//

import AppKit

final class KeybindingManager {
    
    @Published
    private(set) var keybindMappings: [Keystroke: Action] = KeybindingManager.defaultKeybindings()
    
    func getAction(for keystroke: Keystroke) -> Action? {
        let matchingKeybinding = keybindMappings.keys.first {
            keystroke.withoutUnwatedModifiers() == $0
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
    
    func setKeybinding(_ keystroke: Keystroke, for action: Action) {
        deleteAllKeybindings(to: action)
        keybindMappings[keystroke.withoutUnwatedModifiers()] = action
        postKeybindingsChangedNotification()
    }
    
    func removeKeybinding(forAction action: Action) {
        deleteAllKeybindings(to: action)
    }
    
    private func deleteAllKeybindings(to action: Action) {
        let keys = keybindMappings
            .filter {
                $0.value == action
            }.map {
                $0.key
            }
        
        keys.forEach {
            keybindMappings.removeValue(forKey: $0)
        }
    }
    
    private func postKeybindingsChangedNotification() {
        NotificationCenter.default.post(name: .keybindingsChanged, object: nil)
    }
}

private extension Keystroke {
    func withoutUnwatedModifiers() -> Self {
        var modifiers = self.modifiers
        modifiers.remove(.numericPad)
        modifiers.remove(.function)
        return Keystroke(keyCode: keyCode, modifiers: modifiers)
    }
}
