//
//  handleKeystrokeEvent.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-06-10.
//

import AppKit

func handleKeystrokeEvent(
    proxy: CGEventTapProxy,
    type: CGEventType,
    cgEvent: CGEvent,
    userInfo: UnsafeMutableRawPointer?
) -> Unmanaged<CGEvent>? {
    guard let nsEvent = NSEvent(cgEvent: cgEvent), nsEvent.type == .keyDown else {
        // Let all other keystrokes pass
        return Unmanaged.passUnretained(cgEvent)
    }
    
    guard let userInfo else {
        assertionFailure("userInfo not set")
        return Unmanaged.passUnretained(cgEvent)
    }
    
    let appDelegate = Unmanaged<AppDelegate>.fromOpaque(userInfo).takeUnretainedValue()
    
    let keyCode = nsEvent.keyCode
    let modifiers = nsEvent.modifierFlags.intersection(.deviceIndependentFlagsMask)
    let keystroke = Keystroke(keyCode: keyCode, modifiers: modifiers)
    
    guard let keyboundAction = appDelegate.keybindingManager.getAction(for: keystroke) else {
        // Action was not keybound, let the event pass through
        return Unmanaged.passUnretained(cgEvent)
    }
    
    appDelegate.windowManager.execute(keyboundAction)
    
    // Consume the tap event
    return nil    
}
