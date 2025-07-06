//
//  Keystroke+Display.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-07-06.
//

import Foundation

extension Keystroke {
    var display: String {
        let modifiersDisplay = modifiers.display
        let keyCodeDisplay = keyCode.keyCodeDisplay.uppercased()
        
        return "\(modifiersDisplay)\(keyCodeDisplay)"
    }
}

private extension UInt16 {
    /// Keycodes: https://gist.github.com/swillits/df648e87016772c7f7e5dbed2b345066
    /// Symbols: https://gist.github.com/jlyonsmith/6992156f18c423fd1c5af068aa311fb5
    var keyCodeDisplay: String {
        switch self {
        case 0x4C, 0x24: "⏎"
        case 0x31: "␣"
        case 0x33: "⌫"
        case 0x75: "⌦"
        case 0x30: "⇥"
        case 0x7E: "↑"
        case 0x7D: "↓"
        case 0x7C: "→"
        case 0x7B: "←"
        default:
            keyCodeToString(self)
        }
    }
}
