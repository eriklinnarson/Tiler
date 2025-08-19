//
//  StatusBarMenu.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-06-07.
//

import AppKit
import Combine
import OSLog
import SwiftUI

final class StatusBarMenu: NSMenu {
    
    private var windowManager: WindowManager?
    private var keybindingManager: KeybindingManager?
    private var keystrokeManager: KeystrokeManager?
    private var settingsManager: SettingsManager?
    
    private let windowController = NSWindowController()
    private var cancellables = Set<AnyCancellable>()
    
    func setup(
        windowManager: WindowManager,
        keybindingManager: KeybindingManager,
        keystrokeManager: KeystrokeManager,
        settingsManager: SettingsManager
    ) {
        self.windowManager = windowManager
        self.keybindingManager = keybindingManager
        self.keystrokeManager = keystrokeManager
        self.settingsManager = settingsManager
        
        setupMenuButtons()
        setupObservers()
        
#if DEBUG
//        openDebugWindow()
#endif
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupObservers() {
        setupAccessibilityPermissionObserver()
        setupNotificationObserver()
    }
    
    private func setupAccessibilityPermissionObserver() {
        PermissionsManager.shared
            .$accessibilityPermissionsGranted
            .removeDuplicates()
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] accessibilityPermissionsGranted in
                if accessibilityPermissionsGranted {
                    self?.setupMenuButtons()
                } else {
                    self?.setupMenuForMissingAccessibilitySettings()
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didReceiveKeybindingsChangedNotification),
            name: .keybindingsChanged,
            object: nil
        )
    }
    
    @objc private func didReceiveKeybindingsChangedNotification() {
        Logger.statusBarMenu.info("Keybindings changed, updating status menu")
        setupMenuButtons()
    }
    
    private func setupMenuButtons() {
        removeAllItems()
        
        addItem(appNameMenuBarItem())
        
        ScreenArea.allCases.forEach {
            let menuItem = menuBarItem(for: .placeWindowIn($0))
            addItem(menuItem)
        }
        
        addItem(NSMenuItem.separator())
        addItem(NSMenuItem.labelItem("Smart resize"))
        
        Direction.allCases.forEach {
            let menuItem = menuBarItem(for: .smartResize($0))
            addItem(menuItem)
        }
        
        addItem(NSMenuItem.separator())
        addItem(NSMenuItem.labelItem("Shrink window"))
        
        Direction.allCases.forEach {
            let menuItem = menuBarItem(for: .shrinkWindow($0))
            addItem(menuItem)
        }
        
        addItem(NSMenuItem.separator())
        addItem(NSMenuItem.labelItem("Expand window"))
        
        Direction.allCases.forEach {
            let menuItem = menuBarItem(for: .expandWindow($0))
            addItem(menuItem)
        }
        
        addItem(NSMenuItem.separator())
        
        addItem(menuBarPreferences())
        addItem(menuBarQuit())
#if DEBUG
        addItem(openDebugWindowMenuItem())
#endif
    }
    
    private func setupMenuForMissingAccessibilitySettings() {
        removeAllItems()
        
        let titleItem = NSMenuItem()
        titleItem.title = "Tiler does not have the permissions required to tile your windows."
        
        let settingsButtonItem = NSMenuItem()
        settingsButtonItem.title = "Open settings"
        settingsButtonItem.action = #selector(openSystemSettings)
        settingsButtonItem.target = self
        let image = NSImage(systemSymbolName: "gearshape.fill", accessibilityDescription: nil)
        settingsButtonItem.image = image
        
        addItem(appNameMenuBarItem())
        addItem(titleItem)
        addItem(settingsButtonItem)
        addItem(menuBarQuit())
    }
    
    private func appNameMenuBarItem() -> NSMenuItem {
        let menuItem = NSMenuItem()
        menuItem.title = "Tiler"
        return menuItem
    }
    
    private func menuBarItem(for action: Action) -> NSMenuItem {
        let menuItem = NSMenuItem()
        
        let selector = switch action {
        case .placeWindowIn:
            #selector(didTapMenuItemForScreenArea(sender:))
        case .shrinkWindow:
            #selector(didTapMenuItemForShrinkDirection(sender:))
        case .expandWindow:
            #selector(didTapMenuItemForExpandDirection(sender:))
        case .smartResize:
            #selector(didTapMenuItemForSmartResize(sender:))
        }
        
        menuItem.title = action.localizedName
        menuItem.image = action.nsImage
        menuItem.tag = action.tag
        menuItem.action = selector
        menuItem.target = self
        
        if let keybinding = keybindingManager?.getKeybinding(for: action) {
            // Apply keyEquivalent only for having the keybinding visually show up in the menu.
            // This does not apply listeners for the keybinding, since the app will never be in the foreground.
            menuItem.keyEquivalentModifierMask = keybinding.modifiers
            menuItem.keyEquivalent = keyCodeToString(keybinding.keyCode)
        }
        return menuItem
    }
    
    private func menuBarPreferences() -> NSMenuItem {
        let menuItem = NSMenuItem()
        menuItem.title = "Preferences"
        menuItem.action = #selector(openPreferences)
        menuItem.target = self
        return menuItem
    }
    
    private func menuBarQuit() -> NSMenuItem {
        let menuItem = NSMenuItem()
        menuItem.title = "Quit"
        menuItem.action = #selector(quitApp)
        menuItem.target = self
        return menuItem
    }
    
    @objc private func didTapMenuItemForScreenArea(sender: NSMenuItem) {
        guard let screenAreaTapped = ScreenArea(rawValue: sender.tag) else {
            return
        }
        let action = Action.placeWindowIn(screenAreaTapped)
        Logger.statusBarMenu.info("Action called from menu: \(action.id)")
        windowManager?.execute(action)
    }
    
    @objc private func didTapMenuItemForShrinkDirection(sender: NSMenuItem) {
        guard let shrinkDirectionTapped = Direction(rawValue: sender.tag) else {
            return
        }
        let action = Action.shrinkWindow(shrinkDirectionTapped)
        Logger.statusBarMenu.info("Action called from menu: \(action.id)")
        windowManager?.execute(action)
    }
    
    @objc private func didTapMenuItemForExpandDirection(sender: NSMenuItem) {
        guard let expandDirectionTapped = Direction(rawValue: sender.tag) else {
            return
        }
        let action = Action.expandWindow(expandDirectionTapped)
        Logger.statusBarMenu.info("Action called from menu: \(action.id)")
        windowManager?.execute(action)
    }
    
    @objc private func didTapMenuItemForSmartResize(sender: NSMenuItem) {
        guard let smartResizeDirectionTapped = Direction(rawValue: sender.tag) else {
            return
        }
        let action = Action.smartResize(smartResizeDirectionTapped)
        Logger.statusBarMenu.info("Action called from menu: \(action.id)")
        windowManager?.execute(action)
    }
    
    @objc private func openPreferences() {
        guard
            let keystrokeManager,
            let keybindingManager,
            let settingsManager
        else {
            Logger.statusBarMenu.error("Improper setup")
            return
        }
        
        if windowController.window == nil {
            let hostingViewController = NSHostingController(
                rootView: SettingsView(
                    keystrokeManager: keystrokeManager,
                    keybindingManager: keybindingManager,
                    settingsManager: settingsManager
                )
            )
            let window = NSWindow(contentViewController: hostingViewController)
            window.title = "Tiler"
            windowController.window = window
        }
        
        windowController.showWindow(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc private func openSystemSettings() {
        guard let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility") else {
            Logger.statusBarMenu.error("Error when setting up deeplink to system settings.")
            return
        }
        
        NSWorkspace.shared.open(url)
    }
    
    @objc private func quitApp() {
        Logger.statusBarMenu.info("Quit app button pressed, closing down...")
        NSApplication.shared.terminate(self)
    }
    
#if DEBUG
    private let debugWindowController = NSWindowController()
    
    @objc
    func openDebugWindow() {
        guard let windowManager else { return }
        
        if debugWindowController.window == nil {
            let hostingViewController = NSHostingController(
                rootView: DebugWindow(windowManager: windowManager)
            )
            let window = NSWindow(contentViewController: hostingViewController)
            window.title = "Tiler - Debug Window"
            debugWindowController.window = window
        }
        debugWindowController.showWindow(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func openDebugWindowMenuItem() -> NSMenuItem {
        let menuItem = NSMenuItem()
        menuItem.title = "Open Debug Window"
        menuItem.image = NSImage(systemSymbolName: "hammer.fill", accessibilityDescription: nil)
        menuItem.action = #selector(openDebugWindow)
        menuItem.target = self
        return menuItem
    }
#endif
}

private extension Action {
    var tag: Int {
        switch self {
        case .placeWindowIn(let screenArea):
            screenArea.rawValue
        case .shrinkWindow(let direction):
            direction.rawValue
        case .expandWindow(let direction):
            direction.rawValue
        case .smartResize(let direction):
            direction.rawValue
        }
    }
}

extension NSMenuItem {
    static func labelItem(_ string: String) -> NSMenuItem {
        let menuItem = NSMenuItem()
        menuItem.title = string
        return menuItem
    }
}

private extension Logger {
    static let statusBarMenu = Logger(subsystem: subsystem, category: "statusBarMenu")
}
