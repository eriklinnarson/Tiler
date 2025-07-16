//
//  SettingsGeneralViewModel.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-07-15.
//

import OSLog

private extension Logger {
    static let settingsGeneralViewModel = Logger(subsystem: subsystem, category: "settingsGeneralViewModel")
}

final class SettingsGeneralViewModel: ObservableObject {
    let keybindingManager: KeybindingManager
    
    @Published var showRestoreSettingsConfirmation = false
    
    init(keybindingManager: KeybindingManager) {
        self.keybindingManager = keybindingManager
    }
    
    func didTapRestoreSettings() {
        showRestoreSettingsConfirmation = true
    }
    
    func didTapConfirmRestoreSettings() {
        Logger.settingsGeneralViewModel.info("Restore settings confirmed")
        keybindingManager.restoreKeybindingsToDefault()
    }
    
    func didTapCancelRestoreSettings() {
        Logger.settingsGeneralViewModel.info("Restore settings cancelled")
    }
}
