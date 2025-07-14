//
//  keyCodeToString.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-07-05.
//

import Carbon
import OSLog

extension Logger {
    static let keyCodeToString = Logger(subsystem: subsystem, category: "keyCodeToString")
}

func keyCodeToString(_ keyCode: CGKeyCode) -> String {
    // TODO: Jag är rätt säker på att `.takeRetainedValue` är rätt här, om man följer "Create/Copy"-regeln
    // https://stackoverflow.com/questions/29048826/when-to-use-takeunretainedvalue-or-takeretainedvalue-to-retrieve-unmanaged-o
    // https://nshipster.com/unmanaged/
    let source = TISCopyCurrentASCIICapableKeyboardLayoutInputSource().takeRetainedValue()
    let layoutData = TISGetInputSourceProperty(source, kTISPropertyUnicodeKeyLayoutData)
    let dataRef = unsafeBitCast(layoutData, to: CFData.self)
    let keyLayout = unsafeBitCast(CFDataGetBytePtr(dataRef), to: UnsafePointer<UCKeyboardLayout>.self)
    
    var deadKeyState: UInt32 = 0
    var actualStringLength = 0
    var unicodeString = [UniChar](repeating: 0, count: 255)
    
    let status = UCKeyTranslate(keyLayout,
                                keyCode,
                                UInt16(kUCKeyActionDown),
                                0,
                                UInt32(LMGetKbdType()),
                                0,
                                &deadKeyState,
                                255,
                                &actualStringLength,
                                &unicodeString)
    
    if status != 0 {
        Logger.keyCodeToString.error("Failed to convert keyCode to string. KeyCode \(keyCode), status: \(status)")
    }
    
    return NSString(characters: unicodeString, length: actualStringLength) as String
}
