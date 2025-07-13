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
        let placeWindowActions = ScreenArea.allCases.map { Action.placeWindowIn($0) }
        let rowModels = placeWindowActions.map {
            viewModel.rowModel(forAction: $0)
        }
        
        ScrollView {
            ActionKeybindingListView(
                models: rowModels,
                rowViewBuilder: actionKeybindingRowBuilder(_:)
            )
            .onDisappear(perform: viewModel.onViewDisappear)
        }
    }
    
    @ViewBuilder
    func actionKeybindingRowBuilder(_ rowModel: ActionKeybindingRowModel) -> some View {
        let isSelected = rowModel.action == viewModel.selectedActionForRecordKeybinding
        
        ActionKeybindingRowView(
            model: rowModel,
            isSelected: isSelected,
            onDidSelect: viewModel.didSelectAction(_:),
            onDidRemove: viewModel.didTapRemoveKeybinding(forAction:)
        )
    }
}
