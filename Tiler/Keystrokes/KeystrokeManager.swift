//
//  KeystrokeManager.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-07-05.
//

import AppKit
import OSLog

final class KeystrokeManager {
    @Published private(set) var mostRecentKeystroke: Keystroke? = nil
    
    let keybindingManager: KeybindingManager
    let windowManager: WindowManager
    
    private var ignoreKeystrokes = false
    private let lock = NSLock()
    private var keybindingEventTap: CFMachPort?
    
    init(keybindingManager: KeybindingManager, windowManager: WindowManager) {
        self.keybindingManager = keybindingManager
        self.windowManager = windowManager
        
        setupKeystrokeListener()
    }
    
    func keystrokeWasCalled(_ keystroke: Keystroke) {
        self.mostRecentKeystroke = keystroke
    }
    
    func getIgnoreKeystrokes() -> Bool {
        lock.lock()
        defer { lock.unlock() }
        return ignoreKeystrokes
    }
    
    func setIgnoreKeystrokes(_ ignoreKeystrokes: Bool) {
        lock.lock()
        self.ignoreKeystrokes = ignoreKeystrokes
        lock.unlock()
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
            Logger.keystrokeMangager.warning("Failed to setup keystroke listener, accessibility privileges might be disabled")
            return
        }
        
        keybindingEventTap = tap
        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)
        CFRunLoopAddSource(CFRunLoopGetMain(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: tap, enable: true)
    }
}

private extension Logger {
    static let keystrokeMangager = Logger(subsystem: subsystem, category: "keystrokeManager")
}
