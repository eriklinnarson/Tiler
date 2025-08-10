//
//  Resources.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-08-10.
//

import AppKit

struct Resources {
    static var menuBarIcon: NSImage? {
        let image = NSImage(named: "menuBarIcon")
        image?.isTemplate = true
        return image
    }
    
#if DEBUG
    static var menuBarIconDebug: NSImage? {
        let debugImage = NSImage(named: "menuBarIconDebug")
        debugImage?.isTemplate = true
        return debugImage
    }
#endif
}
