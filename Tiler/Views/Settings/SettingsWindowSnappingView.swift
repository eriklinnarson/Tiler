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
        VStack {
            ForEach(viewModel.keybindingCardModels) { cardModel in
                let isSelected = cardModel.action == viewModel.selectedAction
                
                KeybindingSettingsCard(
                    action: cardModel.action,
                    keybindingDisplay: cardModel.keybindingDisplay,
                    isSelected: isSelected,
                    onDidSelect: viewModel.didSelectAction(_:)
                )
            }
        }
        .padding()
        .frame(maxHeight: .infinity, alignment: .topLeading)
        .font(.title2)
    }
}
