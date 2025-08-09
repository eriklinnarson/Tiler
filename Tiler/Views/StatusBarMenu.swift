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

private extension Logger {
    static let statusBarMenu = Logger(subsystem: subsystem, category: "statusBarMenu")
}

final class StatusBarMenu: NSMenu {
    
    private var windowManager: WindowManager?
    private var keybindingManager: KeybindingManager?
    private var keystrokeManager: KeystrokeManager?
    private var windowController: NSWindowController?
    
    private var cancellables = Set<AnyCancellable>()
    
    func setup(
        windowManager: WindowManager,
        keybindingManager: KeybindingManager,
        keystrokeManager: KeystrokeManager
    ) {
        self.windowManager = windowManager
        self.keybindingManager = keybindingManager
        self.keystrokeManager = keystrokeManager
        self.windowController = NSWindowController()
        
        setupMenuButtons()
        setupObservers()
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
            .sink { accessibilityPermissionsGranted in
                if accessibilityPermissionsGranted {
                    // TODO: setup menu items
                } else {
                    // TODO: show prompt for accessibility permissions
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
        
        ScreenArea.allCases.forEach {
            let menuItem = menuBarItem(for: .placeWindowIn($0))
            addItem(menuItem)
        }
        
        addItem(NSMenuItem.separator())
        
        Direction.allCases.forEach {
            let menuItem = menuBarItem(for: .shrinkWindow($0))
            addItem(menuItem)
        }
        
        addItem(NSMenuItem.separator())
        
        Direction.allCases.forEach {
            let menuItem = menuBarItem(for: .expandWindow($0))
            addItem(menuItem)
        }
        
        addItem(NSMenuItem.separator())
        
        addItem(menuBarPreferences())
        addItem(menuBarQuit())
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
    
    @objc private func openPreferences() {
        guard let windowController, let keystrokeManager, let keybindingManager else {
            Logger.statusBarMenu.error("Improper setup")
            return
        }
        
        if windowController.window == nil {
            let hostingViewController = NSHostingController(
                rootView: SettingsView(
                    keystrokeManager: keystrokeManager,
                    keybindingManager: keybindingManager
                )
            )
            let window = NSWindow(contentViewController: hostingViewController)
            window.title = "Tiler"
            windowController.window = window
        }
        
        windowController.showWindow(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc private func quitApp() {
        NSApplication.shared.terminate(self)
    }
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
        }
    }
}
