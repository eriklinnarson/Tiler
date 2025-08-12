//
//  ScreenArea+Image.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-06-07.
//

import SwiftUI
import AppKit

extension ScreenArea {
    var image: Image {
        Image(systemName: systemName)
    }
    
    var nsImage: NSImage? {
        NSImage(systemSymbolName: systemName, accessibilityDescription: nil)
    }
    
    private var systemName: String {
        switch self {
        case .fullScreen:
            "inset.filled.rectangle"
        case .leftHalf:
            "inset.filled.lefthalf.rectangle"
        case .rightHalf:
            "inset.filled.righthalf.rectangle"
        case .topHalf:
            "inset.filled.tophalf.rectangle"
        case .bottomHalf:
            "inset.filled.bottomhalf.rectangle"
        case .topLeft:
            "inset.filled.topleft.rectangle"
        case .bottomLeft:
            "inset.filled.bottomleft.rectangle"
        case .topRight:
            "inset.filled.topright.rectangle"
        case .bottomRight:
            "inset.filled.bottomright.rectangle"
        }
    }
}
