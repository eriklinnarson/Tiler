//
//  KeybindingManager+DefaultBindings.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-06-10.
//

import Foundation

// TODO: Add remaining default keybindings
extension KeybindingManager {
    func defaultKeybindings() -> [Keystroke: Action] {
        [
            // MARK: - Place window in area
            .init(
                keyCode: 36, // enter
                modifiers: [.control, .option]
            ): .placeWindowIn(.fullScreen),
            .init(
                keyCode: 123, // left arrow
                modifiers: [.control, .option]
            ): .placeWindowIn(.leftHalf),
            .init(
                keyCode: 124, // right arrow
                modifiers: [.control, .option]
            ): .placeWindowIn(.rightHalf),
            
            // MARK: - Shrink window
            .init(
                keyCode: 123, // left arrow
                modifiers: [.control, .option, .shift]
            ): .shrinkWindow(.left),
            .init(
                keyCode: 124, // right arrow
                modifiers: [.control, .option, .shift]
            ): .shrinkWindow(.right),
            
            // MARK: - Expand window
            .init(
                keyCode: 123, // left arrow
                modifiers: [.control, .option, .command]
            ): .expandWindow(.left),
            .init(
                keyCode: 124, // right arrow
                modifiers: [.control, .option, .command]
            ): .expandWindow(.right),
        ]
    }
}
