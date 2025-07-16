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
    
    let keystrokeListener: KeystrokeListener
    let keybindingManager: KeybindingManager
    
    init(keystrokeListener: KeystrokeListener, keybindingManager: KeybindingManager) {
        self.keystrokeListener = keystrokeListener
        self.keybindingManager = keybindingManager
    }
}
