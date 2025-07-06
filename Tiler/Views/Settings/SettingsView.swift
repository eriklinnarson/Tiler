//
//  SettingsView.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-07-05.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject private var viewModel: SettingsViewModel
    
    init(keystrokeListener: KeystrokeListener) {
        self._viewModel = StateObject(
            wrappedValue: SettingsViewModel(
                keystrokeListener: keystrokeListener
            )
        )
    }
    
    var body: some View {
        Group {
            Text("Most recent: \(viewModel.mostRecentKeystroke?.display ?? "")")
        }
        .frame(minWidth: 400, minHeight: 400)
    }
}
