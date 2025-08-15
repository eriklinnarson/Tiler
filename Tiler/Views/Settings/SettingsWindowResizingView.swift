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
        VStack(alignment: .leading) {
            Text("Smart resize window")
                .font(.title)
            actionListBuilder {
                Action.smartResize($0)
            }
            
            Divider()
                .padding(.vertical)
            
            Text("Shrink window")
                .font(.title)
            actionListBuilder {
                Action.shrinkWindow($0)
            }
            
            Divider()
                .padding(.vertical)
            
            Text("Expand window")
                .font(.title)
            actionListBuilder {
                Action.expandWindow($0)
            }
        }
        .onDisappear(perform: viewModel.onViewDisappear)
        .settingsPageStyling()
    }
    
    @ViewBuilder
    private func actionListBuilder(_ actionBuilder: (Direction) -> Action) -> some View {
        let actions = Direction.allCases.map {
            actionBuilder($0)
        }
        let rowModels = actions.map {
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
