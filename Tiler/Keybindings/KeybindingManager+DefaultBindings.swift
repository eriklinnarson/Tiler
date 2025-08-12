//
//  KeybindingManager+DefaultBindings.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-06-10.
//

import Foundation

extension KeybindingManager {
    static func defaultKeybindings() -> [Keystroke: Action] {
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
            .init(
                keyCode: 125, // down arrow
                modifiers: [.control, .option]
            ): .placeWindowIn(.bottomHalf),
            .init(
                keyCode: 126, // up arrow
                modifiers: [.control, .option]
            ): .placeWindowIn(.topHalf),
            
            // MARK: - Shrink window
            .init(
                keyCode: 123, // left arrow
                modifiers: [.control, .option, .shift]
            ): .shrinkWindow(.left),
            .init(
                keyCode: 124, // right arrow
                modifiers: [.control, .option, .shift]
            ): .shrinkWindow(.right),
            .init(
                keyCode: 125, // down arrow
                modifiers: [.control, .option, .shift]
            ): .shrinkWindow(.down),
            .init(
                keyCode: 126, // up arrow
                modifiers: [.control, .option, .shift]
            ): .shrinkWindow(.up),
            
            // MARK: - Expand window
            .init(
                keyCode: 123, // left arrow
                modifiers: [.control, .option, .command]
            ): .expandWindow(.left),
            .init(
                keyCode: 124, // right arrow
                modifiers: [.control, .option, .command]
            ): .expandWindow(.right),
            .init(
                keyCode: 125, // down arrow
                modifiers: [.control, .option, .command]
            ): .expandWindow(.down),
            .init(
                keyCode: 126, // up arrow
                modifiers: [.control, .option, .command]
            ): .expandWindow(.up),
        ]
    }
}
