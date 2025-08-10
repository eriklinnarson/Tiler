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
}
