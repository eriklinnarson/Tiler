//
//  SettingsWindowSnappingViewModel.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-07-12.
//

import SwiftUI
import Combine

class SettingsPageViewModel: ObservableObject {
    let keybindingManager: KeybindingManager
    let keystrokeListener: KeystrokeListener
    
    @Published private(set) var selectedAction: Action?
    @Published private(set) var mostRecentKeystroke: Keystroke?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(keybindingManager: KeybindingManager, keystrokeListener: KeystrokeListener) {
        self.keybindingManager = keybindingManager
        self.keystrokeListener = keystrokeListener
        
        setupSubscribers()
    }
    
    func didSelectAction(_ action: Action) {
        if action == selectedAction {
            selectedAction = nil
        } else {
            mostRecentKeystroke = nil
            selectedAction = action
        }
    }
    
    func keybinding(for screenArea: ScreenArea) -> Keystroke? {
        keybindingManager.getKeybinding(for: .placeWindowIn(screenArea))
    }
    
    func keybindingDisplay(for action: Action) -> String {
        if let mostRecentKeystroke, selectedAction == action {
            return mostRecentKeystroke.display
        } else if let keybinding = keybindingManager.getKeybinding(for: action) {
            return keybinding.display
        } else {
            return "Not bound"
        }
    }
    
    private func setupSubscribers() {
        keystrokeListener
            .$keystroke
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.didReceiveKeystroke($0)
            }
            .store(in: &cancellables)
    }
    
    private func didReceiveKeystroke(_ keystroke: Keystroke?) {
        guard let keystroke else {
            return
        }
        
        mostRecentKeystroke = keystroke
        
        guard let selectedAction else {
            return
        }
        
        keybindingManager.setKeybinding(keystroke, for: selectedAction)
    }
}
