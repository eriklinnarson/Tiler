//
//  AppDelegate.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-07-05.
//

import AppKit
import OSLog

private extension Logger {
    static let appDelegate = Logger(subsystem: subsystem, category: "appDelegate")
}

class AppDelegate: NSObject, NSApplicationDelegate {
    let statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    var keybindingEventTap: CFMachPort?
    
    let windowManager: WindowManager
    let settingsStorageManager: SettingsStorageManager
    let keybindingManager: KeybindingManager
    let keystrokeManager: KeystrokeManager
    
    override init() {
        let windowManager = WindowManager()
        let settingsStorageManager = SettingsStorageManager(userDefaults: .standard)
        let keybindMappings = KeybindingManager(settingsStorageManager: settingsStorageManager)
        let keystrokeManager = KeystrokeManager()
        
        self.windowManager = windowManager
        self.settingsStorageManager = settingsStorageManager
        self.keybindingManager = keybindMappings
        self.keystrokeManager = keystrokeManager
        
        super.init()
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        statusBarItem.button?.image = NSImage(
            systemSymbolName: "circle",
            accessibilityDescription: "circle"
        ) // TODO: Fix menu bar image
        
        logAppStart()
        
        let statusBarMenu = StatusBarMenu()
        statusBarMenu.setup(
            windowManager: windowManager,
            keybindingManager: keybindingManager,
            keystrokeManager: keystrokeManager
        )
        statusBarItem.menu = statusBarMenu
        
        setupKeystrokeListener()
    }
    
    private func logAppStart() {
        let appVersion = Bundle.main.appVersionDisplay ?? ""
        let buildNumber = Bundle.main.buildNumberDisplay ?? ""
        Logger.appDelegate.info("App start, version: \(appVersion), build number: \(buildNumber)")
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
            return
        }
        
        keybindingEventTap = tap
        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)
        CFRunLoopAddSource(CFRunLoopGetMain(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: tap, enable: true)
    }
}
