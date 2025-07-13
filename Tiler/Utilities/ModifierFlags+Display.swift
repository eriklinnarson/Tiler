//
//  ModifierFlags+Display.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-07-06.
//

import AppKit

extension NSEvent.ModifierFlags {
    var display: String {
        var result = ""
        
        if self.contains(.capsLock) {
            result.append("")
        }
        
        if self.contains(.shift) {
            result.append("⇧")
        }
        
        if self.contains(.control) {
            result.append("⌃")
        }
        
        if self.contains(.option) {
            result.append("⌥")
        }
        
        if self.contains(.command) {
            result.append("⌘")
        }
        
//        if self.contains(.numericPad) {
//            
//        }
//        
//        if self.contains(.help) {
//
//        }
        
        if self.contains(.function) {
            result.append("fn")
        }
        
        if self.contains(.capsLock) {
            result.append("⇪")
        }
        
        return result
    }
}
