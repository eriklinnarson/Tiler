//
//  NSApplication+MenuBarHeight.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-06-08.
//

import AppKit

extension TilerApp {
    static var menuBarHeight: CGFloat {
        NSApplication.shared.mainMenu?.menuBarHeight ?? 0
    }
}
