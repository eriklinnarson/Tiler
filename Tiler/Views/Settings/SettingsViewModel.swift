//
//  SettingsViewModel.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-07-06.
//

import Combine
import SwiftUI

final class SettingsViewModel: ObservableObject {
    
    enum SettingsTab: String, CaseIterable, Identifiable {
        case general = "General"
        case windowSnapping = "Window Snapping"
        case windowResizing = "Window Resizing"
        
        var id: Self { self }
    }
    
    @Published var selectedTab: SettingsTab = .general
    
    var appVersionDisplay: String? {
        Bundle.main.appVersionDisplay
    }
    
    var buildNumberDisplay: String? {
        Bundle.main.buildNumberDisplay
    }
    
    let keystrokeManager: KeystrokeManager
    let keybindingManager: KeybindingManager
    
    init(keystrokeManager: KeystrokeManager, keybindingManager: KeybindingManager) {
        self.keystrokeManager = keystrokeManager
        self.keybindingManager = keybindingManager
    }
}
