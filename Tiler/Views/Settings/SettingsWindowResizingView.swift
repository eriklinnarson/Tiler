//
//  SettingsWindowResizingView.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-07-06.
//

import SwiftUI

struct SettingsWindowResizingView: View {
        
    @StateObject private var viewModel: SettingsWindowResizingViewModel
    
    init(
        keybindingManager: KeybindingManager,
        keystrokeManager: KeystrokeManager,
        settingsManager: SettingsManager
    ) {
        _viewModel = StateObject(
            wrappedValue: .init(
                keybindingManager: keybindingManager,
                keystrokeManager: keystrokeManager,
                settingsManager: settingsManager
            )
        )
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            resizingAmountSection
            
            Divider()
                .padding(.vertical)
            
            smartResizeSection
            
            Divider()
                .padding(.vertical)
            
            shrinkWindowSection
            
            Divider()
                .padding(.vertical)
            
            expandWindowSection
        }
        .onDisappear(perform: viewModel.onViewDisappear)
        .settingsPageStyling()
    }
    
    private var resizingAmountSection: some View {
        VStack(alignment: .leading) {
            Text("Window resizing amount")
                .font(.title)
            
            Text("Set how many pixels each resizing action will be.")
                .font(.body)
            
            HStack {
                Stepper(
                    value: $viewModel.windowResizingConstantTextField,
                    in: 10...300,
                    step: 10
                ) {
                    EmptyView()
                }
                Text("\(viewModel.windowResizingConstantTextField) pixels")
            }
        }
    }
    
    private var smartResizeSection: some View {
        VStack(alignment: .leading) {
            Text("Smart resize window")
                .font(.title)
            Text("Shrink or expand in one action. If the window is already aligned to the edge of the screen in the desired direction, it will shrink. Otherwise it will expand.")
                .font(.body)
            actionListBuilder {
                Action.smartResize($0)
            }
        }
    }
    
    private var shrinkWindowSection: some View {
        VStack(alignment: .leading) {
            Text("Shrink window")
                .font(.title)
            actionListBuilder {
                Action.shrinkWindow($0)
            }
        }
    }
    
    private var expandWindowSection: some View {
        VStack(alignment: .leading) {
            Text("Expand window")
                .font(.title)
            actionListBuilder {
                Action.expandWindow($0)
            }
        }
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
