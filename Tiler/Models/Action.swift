//
//  Action.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-06-10.
//

import AppKit

enum Action: Equatable {
    case placeWindowIn(ScreenArea)
    case shrinkWindow(Direction)
    case expandWindow(Direction)
    
    var localizedName: String {
        switch self {
        case .placeWindowIn(let screenArea):
            screenArea.localizedName
        case .shrinkWindow(let direction):
            direction.shrinkLocalizedName
        case .expandWindow(let direction):
            direction.expandLocalizedName
        }
    }
    
    var nsImage: NSImage? {
        switch self {
        case .placeWindowIn(let screenArea):
            screenArea.nsImage
        case .shrinkWindow(let direction):
            direction.nsImage
        case .expandWindow(let direction):
            direction.nsImage
        }
    }
}
