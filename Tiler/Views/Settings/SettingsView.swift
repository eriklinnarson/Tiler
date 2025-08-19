//
//  SettingsView.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-07-05.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject private var viewModel: SettingsViewModel
    
    init(
        keystrokeManager: KeystrokeManager,
        keybindingManager: KeybindingManager,
        settingsManager: SettingsManager
    ) {
        self._viewModel = StateObject(
            wrappedValue: SettingsViewModel(
                keystrokeManager: keystrokeManager,
                keybindingManager: keybindingManager,
                settingsManager: settingsManager
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
        .safeAreaInset(edge: .bottom) {
            VStack {
                if let appVersionDisplay = viewModel.appVersionDisplay {
                    Text("Version \(appVersionDisplay)")
                }
#if DEBUG
                if let buildNumberDisplay = viewModel.buildNumberDisplay {
                    Text("Build number: \(buildNumberDisplay)")
                }
#endif
            }
            .padding(.bottom, 3)
        }
    }
    
    @ViewBuilder
    private var detailView: some View {
        switch viewModel.selectedTab {
        case .general:
            SettingsGeneralView(
                keybindingManager: viewModel.keybindingManager
            )
        case .windowSnapping:
            SettingsWindowSnappingView(
                keybindingManager: viewModel.keybindingManager,
                keystrokeManager: viewModel.keystrokeManager
            )
        case .windowResizing:
            SettingsWindowResizingView(
                keybindingManager: viewModel.keybindingManager,
                keystrokeManager: viewModel.keystrokeManager,
                settingsManager: viewModel.settingsManager
            )
        }
    }
}
