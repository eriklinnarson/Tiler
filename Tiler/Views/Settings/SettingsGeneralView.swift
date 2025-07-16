//
//  SettingsGeneralView.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-07-15.
//

import SwiftUI

struct SettingsGeneralView: View {
    @StateObject private var viewModel: SettingsGeneralViewModel
    
    init(keybindingManager: KeybindingManager) {
        _viewModel = StateObject(wrappedValue: .init(keybindingManager: keybindingManager))
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Restore all settings and keybindings to default.")
                Spacer()
                restoreSettingsButton
            }
        }
        .settingsPageStyling()
        .confirmationDialog("Restore settings?", isPresented: $viewModel.showRestoreSettingsConfirmation) {
            Button(role: .destructive, action: viewModel.didTapConfirmRestoreSettings) {
                Text("Confirm")
            }
            Button(role: .cancel, action: viewModel.didTapCancelRestoreSettings) {
                Text("Cancel")
            }
        }
    }
    
    private var restoreSettingsButton: some View {
        Button(action: viewModel.didTapRestoreSettings) {
            Text("Restore")
        }
    }
}
