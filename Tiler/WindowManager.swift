//
//  WindowManager.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-06-07.
//

import ApplicationServices
import AppKit
import OSLog

private extension Logger {
    static let windowManager = Logger(subsystem: subsystem, category: "windowManager")
}

final class WindowManager {
    
    let sizePositionCalculator = SizePositionCalculator()
    
    func execute(_ action: Action) {
        switch action {
        case .placeWindowIn(let screenArea):
            placeFrontmostWindow(in: screenArea)
        case .shrinkWindow(let direction):
            shrinkFrontmostWindowTowards(direction)
        case .expandWindow(let direction):
            expandFrontmostWindowTowards(direction)
        }
    }
    
    private func placeFrontmostWindow(in screenArea: ScreenArea) {
        guard let window = getFrontmostWindow() else {
            return
        }
        
        guard let screenSize = getScreenSize() else {
            return
        }
        
        let windowPosition = screenArea.cgPosition(in: screenSize)
        let windowSize = screenArea.cgSize(in: screenSize)
        
        applyWindowPlacement(
            WindowPlacement(position: windowPosition, size: windowSize),
            window: window,
            screenSize: screenSize
        )
    }
    
    private func shrinkFrontmostWindowTowards(_ shrinkDirection: Direction) {
        guard let window = getFrontmostWindow() else {
            return
        }
        
        guard let currentWindowPlacement = getWindowPlacement(of: window) else {
            return
        }
        
        guard let screenSize = getScreenSize() else {
            return
        }
        
        let desiredNewWindowPlacement = sizePositionCalculator.calculateShrink(
            towards: shrinkDirection,
            currentWindowPlacement: currentWindowPlacement
        )
        
        applyWindowPlacement(
            desiredNewWindowPlacement,
            window: window,
            screenSize: screenSize
        )
    }
    
    private func expandFrontmostWindowTowards(_ expandDirection: Direction) {
        guard let window = getFrontmostWindow() else {
            return
        }
        
        guard let currentWindowPlacement = getWindowPlacement(of: window) else {
            return
        }
        
        guard let screenSize = getScreenSize() else {
            return
        }
        
        let desiredNewWindowPlacement = sizePositionCalculator.calculateExpansion(
            towards: expandDirection,
            currentWindowPlacement: currentWindowPlacement
        )
        
        applyWindowPlacement(
            desiredNewWindowPlacement,
            window: window,
            screenSize: screenSize
        )
    }
    
    private func getFrontmostWindow() -> AXUIElement? {
        let frontmostApp = NSWorkspace.shared.frontmostApplication
        
        guard let pid = frontmostApp?.processIdentifier else {
            Logger.windowManager.error("Failed to get PID for frontmost app")
            return nil
        }
        
        let app = AXUIElementCreateApplication(pid)
        var windowRef: CFTypeRef?
        let result = AXUIElementCopyAttributeValue(
            app,
            kAXMainWindowAttribute as CFString,
            &windowRef
        )
        
        guard result == .success, let windowRef else {
            PermissionsManager.shared.checkAccessibilityPermission()
            return nil
        }
        
        let window = windowRef as! AXUIElement
        
        return window
    }
    
    private func getWindowPlacement(of window: AXUIElement) -> WindowPlacement? {
        guard let currentPosition = getCurrentPosition(of: window) else {
            return nil
        }
        
        guard let currentSize = getCurrentSize(of: window) else {
            return nil
        }
        
        return WindowPlacement(position: currentPosition, size: currentSize)
    }
    
    private func applyWindowPlacement(
        _ windowPlacement: WindowPlacement,
        window: AXUIElement,
        screenSize: NSRect
    ) {
        var desiredPosition = windowPlacement.position
        
        setPosition(desiredPosition, to: window)
        setSize(windowPlacement.size, to: window)
        
        guard let updatedSize = getCurrentSize(of: window) else {
            return
        }
        
        var positionNeedsAdjusting = false
        
        let rightEdge = desiredPosition.x + updatedSize.width
        let overFlowRight = rightEdge - screenSize.width
        if overFlowRight > 0 {
            var adjustedX = desiredPosition.x - overFlowRight
            adjustedX = max(adjustedX, 0)
            desiredPosition.x = adjustedX
            positionNeedsAdjusting = true
        }
        
        let bottomEdge = desiredPosition.y + updatedSize.height
        let overFlowBottom = bottomEdge - screenSize.height
        if overFlowBottom > 0 {
            var adjustedY = desiredPosition.y - overFlowBottom
            adjustedY = max(adjustedY, 0)
            desiredPosition.y = adjustedY
            positionNeedsAdjusting = true
        }
        
        if positionNeedsAdjusting {
            setPosition(desiredPosition, to: window)
        }
    }
    
    private func getCurrentSize(of element: AXUIElement) -> CGSize? {
        var sizeRef: CFTypeRef?
        var size: CGSize = .zero
        let result = AXUIElementCopyAttributeValue(
            element,
            kAXSizeAttribute as CFString,
            &sizeRef
        )
        
        guard result == .success, let sizeRef else {
            Logger.windowManager.error("Failed to get current size of window")
            return nil
        }
        
        AXValueGetValue(sizeRef as! AXValue, .cgSize, &size)

        return size
    }
    
    private func getCurrentPosition(of element: AXUIElement) -> CGPoint? {
        var positionRef: CFTypeRef?
        var position: CGPoint = .zero
        let result = AXUIElementCopyAttributeValue(
            element,
            kAXPositionAttribute as CFString,
            &positionRef
        )
        
        guard result == .success, let positionRef else {
            Logger.windowManager.error("Failed to get current position of window")
            return nil
        }
        
        AXValueGetValue(positionRef as! AXValue, .cgPoint, &position)

        return position
    }
    
    private func setSize(_ windowSize: CGSize, to window: AXUIElement) {
        var windowSize = windowSize
        guard let axValueSize = AXValueCreate(.cgSize, &windowSize) else {
            Logger.windowManager.error("Failed to set size of window")
            return
        }
        AXUIElementSetAttributeValue(window, kAXSizeAttribute as CFString, axValueSize)
    }
    
    private func setPosition(_ windowPosition: CGPoint, to window: AXUIElement) {
        var windowPosition = windowPosition
        guard let axValuePosition = AXValueCreate(.cgPoint, &windowPosition) else {
            Logger.windowManager.error("Failed to set position of window")
            return
        }
        AXUIElementSetAttributeValue(window, kAXPositionAttribute as CFString, axValuePosition)
    }
    
    private func getScreenSize() -> NSRect? {
        let screenSize = NSScreen.main?.frame
        if screenSize == nil {
            Logger.windowManager.error("Failed to get screen size")
        }
        return screenSize
    }
}
