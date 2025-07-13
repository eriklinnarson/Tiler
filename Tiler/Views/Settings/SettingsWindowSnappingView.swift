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
                actions: ScreenArea.allCases.map { Action.placeWindowIn($0) },
                keybindingManager: keybindingManager,
                keystrokeListener: keystrokeListener
            )
        )
    }
    
    var body: some View {
        VStack(spacing: 10) {
            ForEach(viewModel.keybindingCardModels) { cardModel in
                let isSelected = cardModel.action == viewModel.selectedAction
                
                KeybindingSettingsCard(
                    model: cardModel,
                    isSelected: isSelected,
                    onDidSelect: viewModel.didSelectAction(_:),
                    onDidRemove: viewModel.didTapRemoveKeybinding(forAction:)
                )
            }
        }
        .padding()
        .frame(maxHeight: .infinity, alignment: .topLeading)
        .font(.title2)
        .onDisappear(perform: viewModel.onViewDisappear)
    }
}
