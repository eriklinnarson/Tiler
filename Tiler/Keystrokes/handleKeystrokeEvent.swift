//
//  handleKeystrokeEvent.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-06-10.
//

import AppKit
import OSLog

private extension Logger {
    static let keyStrokeEvent = Logger(subsystem: subsystem, category: "keyStrokeEvent")
}

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
        Logger.keyStrokeEvent.error("userInfo not set")
        return Unmanaged.passUnretained(cgEvent)
    }
    
    let appDelegate = Unmanaged<AppDelegate>.fromOpaque(userInfo).takeUnretainedValue()
    
    let keyCode = nsEvent.keyCode
    let modifiers = nsEvent.modifierFlags.intersection(.deviceIndependentFlagsMask)
    let keystroke = Keystroke(keyCode: keyCode, modifiers: modifiers)
    
    appDelegate.keystrokeManager.keystrokeWasCalled(keystroke)
    
    let ignoreKeystrokes = appDelegate.keystrokeManager.getIgnoreKeystrokes()
    
    guard let keyboundAction = appDelegate.keybindingManager.getAction(for: keystroke) else {
        // Action was not keybound, let the event pass through.
        // However, if the user is recording a keybinding in settings, we still consume the event.
        // This removes the blip-sound when no app responds to the event.
        if ignoreKeystrokes {
            Logger.keyStrokeEvent.info("Keystroke not keybound, but recording in progress. Consuming event: \(keystroke.display)")
            return nil
        } else {
            return Unmanaged.passUnretained(cgEvent)
        }
    }
    
    if ignoreKeystrokes == false {
        Logger.keyStrokeEvent.info("Action called through keybinding (\(keystroke.display)): \(keyboundAction.id)")
        appDelegate.windowManager.execute(keyboundAction)
    }
    
    // Consume the tap event
    return nil    
}
