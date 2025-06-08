//
//  StatusBarMenu.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-06-07.
//

import AppKit

final class StatusBarMenu: NSMenu {
    
    private var windowManager: WindowManager?
    
    func setup(windowManager: WindowManager) {
        self.windowManager = windowManager
        
        ScreenArea.allCases.forEach {
            let menuItem = menuBarItem(forScreenArea: $0)
            addItem(menuItem)
        }
        
        addItem(NSMenuItem.separator())
        
        Direction.allCases.forEach {
            let menuItem = menuBarItem(forShrinkDirection: $0)
            addItem(menuItem)
        }
        
        addItem(NSMenuItem.separator())
        
        Direction.allCases.forEach {
            let menuItem = menuBarItem(forExpandDirection: $0)
            addItem(menuItem)
        }
    }
    
    private func menuBarItem(forScreenArea screenArea: ScreenArea) -> NSMenuItem {
        let menuItem = NSMenuItem()
        
        menuItem.title = screenArea.localizedName
        menuItem.image = screenArea.nsImage
//        menuItem.keyEquivalent = ""
        menuItem.tag = screenArea.rawValue
        
        menuItem.action = #selector(didTapMenuItemForScreenArea(sender:))
        menuItem.target = self
        return menuItem
    }
    
    private func menuBarItem(forShrinkDirection shrinkDirection: Direction) -> NSMenuItem {
        let menuItem = NSMenuItem()
        
        menuItem.title = shrinkDirection.shrinkLocalizedName
        menuItem.image = shrinkDirection.nsImage
//        menuItem.keyEquivalent = ""
        menuItem.tag = shrinkDirection.rawValue
        
        menuItem.action = #selector(didTapMenuItemForShrinkDirection(sender:))
        menuItem.target = self
        return menuItem
    }
    
    private func menuBarItem(forExpandDirection expandDirection: Direction) -> NSMenuItem {
        let menuItem = NSMenuItem()
        
        menuItem.title = expandDirection.expandLocalizedName
        menuItem.image = expandDirection.nsImage
//        menuItem.keyEquivalent = ""
        menuItem.tag = expandDirection.rawValue
        
        menuItem.action = #selector(didTapMenuItemForExpandDirection(sender:))
        menuItem.target = self
        return menuItem
    }
    
    @objc private func didTapMenuItemForScreenArea(sender: NSMenuItem) {
        guard let screenAreaTapped = ScreenArea(rawValue: sender.tag) else {
            return
        }
        windowManager?.placeFrontmostWindow(in: screenAreaTapped)
    }
    
    @objc private func didTapMenuItemForShrinkDirection(sender: NSMenuItem) {
        guard let shrinkDirectionTapped = Direction(rawValue: sender.tag) else {
            return
        }
        windowManager?.shrinkFrontmostWindowTowards(shrinkDirectionTapped)
    }
    
    @objc private func didTapMenuItemForExpandDirection(sender: NSMenuItem) {
        guard let expandDirectionTapped = Direction(rawValue: sender.tag) else {
            return
        }
        windowManager?.expandFrontmostWindowTowards(expandDirectionTapped)
    }
}
