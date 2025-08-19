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
        .frame(minWidth: 600, minHeight: 400)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: toggleSidebar) {
                    Image(systemName: "sidebar.left")
                }
            }
        }
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
            }
            .padding(.bottom, 3)
        }
    }
    
    @ViewBuilder
    private var detailView: some View {
        switch viewModel.selectedTab {
        case .general:
            SettingsGeneralView(
                keybindingManager: viewModel.keybindingManager,
                settingsManager: viewModel.settingsManager
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
    
    func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
}
