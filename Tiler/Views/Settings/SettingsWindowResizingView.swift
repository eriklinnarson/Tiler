//
//  SettingsWindowResizingView.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-07-06.
//

import SwiftUI

struct SettingsWindowResizingView: View {
    
    @StateObject private var viewModel: SettingsPageViewModel
    
    init(keybindingManager: KeybindingManager, keystrokeManager: KeystrokeManager) {
        _viewModel = StateObject(
            wrappedValue: .init(
                keybindingManager: keybindingManager,
                keystrokeManager: keystrokeManager
            )
        )
    }
    
    var body: some View {
        VStack {
            shrinkActionsList
            Divider()
                .padding(.vertical)
            expandActionsList
        }
        .onDisappear(perform: viewModel.onViewDisappear)
        .settingsPageStyling()
    }
    
    @ViewBuilder
    var shrinkActionsList: some View {
        let placeWindowActions = Direction.allCases.map { Action.shrinkWindow($0) }
        let rowModels = placeWindowActions.map {
            viewModel.rowModel(forAction: $0)
        }
        
        ActionKeybindingListView(
            models: rowModels,
            rowViewBuilder: actionKeybindingRowBuilder(_:)
        )
    }
    
    @ViewBuilder
    var expandActionsList: some View {
        let placeWindowActions = Direction.allCases.map { Action.expandWindow($0) }
        let rowModels = placeWindowActions.map {
            viewModel.rowModel(forAction: $0)
        }
        
        ActionKeybindingListView(
            models: rowModels,
            rowViewBuilder: actionKeybindingRowBuilder(_:)
        )
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
