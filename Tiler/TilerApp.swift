//
//  TilerApp.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-06-07.
//

import SwiftUI

@main
struct TilerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    let statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let windowManager = WindowManager()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        statusBarItem.button?.image = NSImage(systemSymbolName: "circle", accessibilityDescription: "circle") // TODO: Fix menu bar image
        let statusBarMenu = StatusBarMenu()
        statusBarMenu.setup(windowManager: windowManager)
        statusBarItem.menu = statusBarMenu
    }
}
