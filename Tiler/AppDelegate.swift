//
//  AppDelegate.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-07-05.
//

import AppKit
import OSLog

class AppDelegate: NSObject, NSApplicationDelegate {
    let statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    
    let windowManager: WindowManager
    let settingsManager: SettingsManager
    let keybindingManager: KeybindingManager
    let keystrokeManager: KeystrokeManager
    
    override init() {
        Self.logAppStart()
        
        let settingsStorageManager = SettingsStorageManager(userDefaults: .standard)
        let settingsManager = SettingsManager(storage: settingsStorageManager)
        let windowManager = WindowManager(settingsManager: settingsManager)
        let keybindingManager = KeybindingManager(settingsStorageManager: settingsStorageManager)
        let keystrokeManager = KeystrokeManager(keybindingManager: keybindingManager, windowManager: windowManager)
        
        self.windowManager = windowManager
        self.settingsManager = settingsManager
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
            keystrokeManager: keystrokeManager,
            settingsManager: settingsManager
        )
        statusBarItem.menu = statusBarMenu
    }
    
    private static func logAppStart() {
        let appVersion = Bundle.main.appVersionDisplay ?? ""
        let buildNumber = Bundle.main.buildNumberDisplay ?? ""
        Logger.appDelegate.info("App start, version: \(appVersion), build number: \(buildNumber)")
    }
}

private extension Logger {
    static let appDelegate = Logger(subsystem: subsystem, category: "appDelegate")
}
