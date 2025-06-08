//
//  Direction+Image.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-06-08.
//

import SwiftUI
import AppKit

extension Direction {
    var image: Image {
        Image(systemName: systemName)
    }
    
    var nsImage: NSImage? {
        NSImage(systemSymbolName: systemName, accessibilityDescription: "TODO")
    }
    
    private var systemName: String {
        switch self {
        case .left:
            "chevron.left.2"
        case .right:
            "chevron.right.2"
        case .up:
            "chevron.up.2"
        case .down:
            "chevron.down.2"
        }
    }
}
