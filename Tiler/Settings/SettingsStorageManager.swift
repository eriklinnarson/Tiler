//
//  SettingsStorageManager.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-07-13.
//

import Foundation
import OSLog

private extension Logger {
    static let settingsStorageManager = Logger(subsystem: subsystem, category: "settingsStorageManager")
}

final class SettingsStorageManager {
    private let userDefaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    func getActionKeybindings() -> [Keystroke: Action] {
        let defaultKeybindings = KeybindingManager.defaultKeybindings()
        
        guard let data = userDefaults.data(forKey: UserDefaults.Keys.actionKeybindings.rawValue) else {
            Logger.settingsStorageManager.info("No action keybindings found in UserDefaults, returning default bindings.")
            return defaultKeybindings
        }
        do {
            let keybindings = try decoder.decode([Keystroke: Action].self, from: data)
            return keybindings
        } catch {
            Logger.settingsStorageManager.error("Failed to decode action keybindings from UserDefaults.")
            return defaultKeybindings
        }
    }
    
    func setActionKeybindings(_ keybindings: [Keystroke: Action]) {
        do {
            let data = try encoder.encode(keybindings)
            userDefaults.set(data, forKey: UserDefaults.Keys.actionKeybindings.rawValue)
        } catch {
            Logger.settingsStorageManager.error("Failed to encode action keybindings.")
        }
    }
}
