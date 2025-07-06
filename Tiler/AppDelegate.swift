//
//  AppDelegate.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-07-05.
//

import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    let statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    var keybindingEventTap: CFMachPort?
    
    let windowManager = WindowManager()
    let keybindingManager = KeybindingManager()
    let keystrokeListener = KeystrokeListener()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        statusBarItem.button?.image = NSImage(
            systemSymbolName: "circle",
            accessibilityDescription: "circle"
        ) // TODO: Fix menu bar image
        
        let statusBarMenu = StatusBarMenu()
        statusBarMenu.setup(
            windowManager: windowManager,
            keybindingManager: keybindingManager,
            keystrokeListener: keystrokeListener
        )
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
        
        keybindingEventTap = tap
        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)
        CFRunLoopAddSource(CFRunLoopGetMain(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: tap, enable: true)
    }
}
