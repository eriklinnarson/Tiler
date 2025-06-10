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
    var keybindingEventTap: CFMachPort?
    
    let windowManager = WindowManager()
    let keybindingManager = KeybindingManager()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        statusBarItem.button?.image = NSImage(
            systemSymbolName: "circle",
            accessibilityDescription: "circle"
        ) // TODO: Fix menu bar image
        
        let statusBarMenu = StatusBarMenu()
        statusBarMenu.setup(windowManager: windowManager)
        statusBarItem.menu = statusBarMenu
        
        setupKeystrokeListener()
    }
    
    private func setupKeystrokeListener() {
        let pointerToSelf = Unmanaged.passUnretained(self).toOpaque()
        let eventMask = (1 << CGEventType.keyDown.rawValue)
        
        guard let tap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(eventMask),
            callback: handleKeystrokeEvent,
            userInfo: pointerToSelf
        ) else {
            // TODO: Log error
            return
        }
        
        self.keybindingEventTap = tap
        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)
        CFRunLoopAddSource(CFRunLoopGetMain(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: tap, enable: true)
    }
}
