//
//  StatusBarMenu.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-06-07.
//

import AppKit
import SwiftUI

final class StatusBarMenu: NSMenu {
    
    private var windowManager: WindowManager?
    private var keybindingManager: KeybindingManager?
    private var keystrokeListener: KeystrokeListener?
    private var windowController: NSWindowController?
    
    func setup(
        windowManager: WindowManager,
        keybindingManager: KeybindingManager,
        keystrokeListener: KeystrokeListener
    ) {
        self.windowManager = windowManager
        self.keybindingManager = keybindingManager
        self.keystrokeListener = keystrokeListener
        self.windowController = NSWindowController()
        
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
        windowManager?.execute(.placeWindowIn(screenAreaTapped))
    }
    
    @objc private func didTapMenuItemForShrinkDirection(sender: NSMenuItem) {
        guard let shrinkDirectionTapped = Direction(rawValue: sender.tag) else {
            return
        }
        windowManager?.execute(.shrinkWindow(shrinkDirectionTapped))
    }
    
    @objc private func didTapMenuItemForExpandDirection(sender: NSMenuItem) {
        guard let expandDirectionTapped = Direction(rawValue: sender.tag) else {
            return
        }
        windowManager?.execute(.expandWindow(expandDirectionTapped))
    }
    
    @objc private func openPreferences() {
        guard let windowController, let keystrokeListener else {
            assertionFailure("WindowController not setup.")
            return
        }
        
        if windowController.window == nil {
            let hostingViewController = NSHostingController(rootView: SettingsView(keystrokeListener: keystrokeListener))
            let window = NSWindow(contentViewController: hostingViewController)
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
