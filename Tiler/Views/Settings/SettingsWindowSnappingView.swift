//
//  SettingsWindowSnappingView.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-07-06.
//

import SwiftUI

struct SettingsWindowSnappingView: View {
    
    @StateObject private var viewModel: SettingsPageViewModel
    
    init(keybindingManager: KeybindingManager, keystrokeListener: KeystrokeListener) {
        _viewModel = StateObject(
            wrappedValue: .init(
                keybindingManager: keybindingManager,
                keystrokeListener: keystrokeListener
            )
        )
    }
    
    var body: some View {
        VStack {
            ForEach(ScreenArea.allCases) { screenArea in
                keyBindingCard(screenArea: screenArea)
            }
        }
        .padding()
        .frame(maxHeight: .infinity, alignment: .topLeading)
        .font(.title2)
    }
    
    func keyBindingCard(screenArea: ScreenArea) -> some View {
        KeybindingSettingsCard(
            action: .placeWindowIn(screenArea),
            keybindingDisplay: viewModel.keybindingDisplay(for: .placeWindowIn(screenArea)),
            isSelected: viewModel.selectedAction == .placeWindowIn(screenArea),
            onDidSelect: viewModel.didSelectAction(_:)
        )
    }
}
