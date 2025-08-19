//
//  SettingsGeneralViewModel.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-07-15.
//

import OSLog

final class SettingsGeneralViewModel: ObservableObject {
    let keybindingManager: KeybindingManager
    let settingsManager: SettingsManager
    
    @Published var showRestoreSettingsConfirmation = false
    
    init(keybindingManager: KeybindingManager, settingsManager: SettingsManager) {
        self.keybindingManager = keybindingManager
        self.settingsManager = settingsManager
    }
    
    func didTapRestoreSettings() {
        showRestoreSettingsConfirmation = true
    }
    
    func didTapConfirmRestoreSettings() {
        Logger.settingsGeneralViewModel.info("Restore settings confirmed")
        keybindingManager.restoreKeybindingsToDefault()
        do {
            try settingsManager.restoreToDefaultSettings()
        } catch {
            Logger.settingsGeneralViewModel.error("Failed to restore settings to default")
        }
    }
    
    func didTapCancelRestoreSettings() {
        Logger.settingsGeneralViewModel.info("Restore settings cancelled")
    }
}

private extension Logger {
    static let settingsGeneralViewModel = Logger(subsystem: subsystem, category: "settingsGeneralViewModel")
}
