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
            
            // MARK: - Smart resize
            .init(
                keyCode: 123, // left arrow
                modifiers: [.control, .option, .command]
            ): .smartResize(.left),
            .init(
                keyCode: 124, // right arrow
                modifiers: [.control, .option, .command]
            ): .smartResize(.right),
            .init(
                keyCode: 125, // down arrow
                modifiers: [.control, .option, .command]
            ): .smartResize(.down),
            .init(
                keyCode: 126, // up arrow
                modifiers: [.control, .option, .command]
            ): .smartResize(.up),
        ]
    }
}
