//
//  KeystrokeManager.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-07-05.
//

import Foundation

final class KeystrokeManager {
    @Published private(set) var mostRecentKeystroke: Keystroke? = nil
    
    private var ignoreKeystrokes = false
    private let lock = NSLock()
    
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
}
