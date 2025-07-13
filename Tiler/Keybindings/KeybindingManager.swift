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
    
    func setKeybinding(_ keystroke: Keystroke, for action: Action) {
        deleteAllKeybindings(to: action)
        keybindMappings[keystroke] = action
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
