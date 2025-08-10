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
    
    let windowManager: WindowManager
    let settingsStorageManager: SettingsStorageManager
    let keybindingManager: KeybindingManager
    let keystrokeManager: KeystrokeManager
    
    override init() {
        Self.logAppStart()
        
        let windowManager = WindowManager()
        let settingsStorageManager = SettingsStorageManager(userDefaults: .standard)
        let keybindingManager = KeybindingManager(settingsStorageManager: settingsStorageManager)
        let keystrokeManager = KeystrokeManager(keybindingManager: keybindingManager, windowManager: windowManager)
        
        self.windowManager = windowManager
        self.settingsStorageManager = settingsStorageManager
        self.keybindingManager = keybindingManager
        self.keystrokeManager = keystrokeManager
        
        super.init()
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
#if DEBUG
        let menuBarIcon = Resources.menuBarIconDebug
#else
        let menuBarIcon = Resources.menuBarIcon
#endif
        
        if menuBarIcon == nil {
            Logger.appDelegate.error("Could not find menuBarIcon")
        }
        
        statusBarItem.button?.image = menuBarIcon
        
        let statusBarMenu = StatusBarMenu()
        statusBarMenu.setup(
            windowManager: windowManager,
            keybindingManager: keybindingManager,
            keystrokeManager: keystrokeManager
        )
        statusBarItem.menu = statusBarMenu
    }
    
    private static func logAppStart() {
        let appVersion = Bundle.main.appVersionDisplay ?? ""
        let buildNumber = Bundle.main.buildNumberDisplay ?? ""
        Logger.appDelegate.info("App start, version: \(appVersion), build number: \(buildNumber)")
    }
}
