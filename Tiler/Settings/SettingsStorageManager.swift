//
//  SettingsStorageManager.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-07-13.
//

import Foundation
import OSLog

final class SettingsStorageManager {
    enum StorageError: Error {
        case unableToSaveChange
    }
    
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
    
    // TODO: This method should throw and possible error displayed to user
    func setActionKeybindings(_ keybindings: [Keystroke: Action]) {
        do {
            let data = try encoder.encode(keybindings)
            userDefaults.set(data, forKey: UserDefaults.Keys.actionKeybindings.rawValue)
        } catch {
            Logger.settingsStorageManager.error("Failed to encode action keybindings.")
        }
    }
    
    func getWindowResizingAmount() -> WindowResizingAmount {
        guard let data = userDefaults.data(forKey: UserDefaults.Keys.windowResizingAmount.rawValue) else {
            Logger.settingsStorageManager.info("No WindowResizingAmount found in UserDefaults, returning default value")
            return WindowResizingAmount.defaultValue
        }
        
        do {
            let windowResizingAmount = try decoder.decode(WindowResizingAmount.self, from: data)
            return windowResizingAmount
        } catch {
            Logger.settingsStorageManager.error("Failed to decode WindowResizingAmount")
            return WindowResizingAmount.defaultValue
        }
    }
    
    func setWindowResizingAmount(_ newValue: WindowResizingAmount) throws(StorageError) {
        do {
            let data = try encoder.encode(newValue)
            userDefaults.set(data, forKey: UserDefaults.Keys.windowResizingAmount.rawValue)
        } catch {
            Logger.settingsStorageManager.error("Failed to encode WindowResizingAmount")
            throw .unableToSaveChange
        }
    }
}

private extension Logger {
    static let settingsStorageManager = Logger(subsystem: subsystem, category: "settingsStorageManager")
}
