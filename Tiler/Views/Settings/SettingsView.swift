//
//  SettingsView.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-07-05.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject private var viewModel: SettingsViewModel
    
    init(keystrokeListener: KeystrokeListener, keybindingManager: KeybindingManager) {
        self._viewModel = StateObject(
            wrappedValue: SettingsViewModel(
                keystrokeListener: keystrokeListener,
                keybindingManager: keybindingManager
            )
        )
    }
    
    var body: some View {
        NavigationSplitView {
            sideBar
                .frame(minWidth: 150)
        } detail: {
            detailView
        }
        .navigationSplitViewStyle(.balanced)
        .frame(minWidth: 600, minHeight: 400)
    }
    
    var sideBar: some View {
        List(selection: $viewModel.selectedTab) {
            ForEach(SettingsViewModel.SettingsTab.allCases) {
                Text($0.rawValue)
            }
        }
    }
    
    @ViewBuilder
    private var detailView: some View {
        switch viewModel.selectedTab {
        case .windowSnapping:
            SettingsWindowSnappingView(
                keybindingManager: viewModel.keybindingManager,
                keystrokeListener: viewModel.keystrokeListener
            )
        case .windowResizing:
            SettingsWindowResizingView(
                keybindingManager: viewModel.keybindingManager,
                keystrokeListener: viewModel.keystrokeListener
            )
        }
    }
}
