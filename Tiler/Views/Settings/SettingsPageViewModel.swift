//
//  SettingsWindowSnappingViewModel.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-07-12.
//

import SwiftUI
import Combine

struct KeybindingCardModel: Identifiable {
    let action: Action
    let keybinding: Keystroke?
    
    var id: String { action.id }
    
    var keybindingDisplay: String {
        keybinding?.display ?? "-"
    }
}

class SettingsPageViewModel: ObservableObject {
    private let actions: [Action]
    private let keybindingManager: KeybindingManager
    private let keystrokeListener: KeystrokeListener
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var selectedAction: Action?
    @Published private var keybindings: [Keystroke: Action] = [:]
    
    var keybindingCardModels: [KeybindingCardModel] {
        actions.map { action in
            let keybinding = keybindings.first {
                $0.value == action
            }?.key
            
            return KeybindingCardModel(action: action, keybinding: keybinding)
        }
    }
    
    init(
        actions: [Action],
        keybindingManager: KeybindingManager,
        keystrokeListener: KeystrokeListener
    ) {
        self.actions = actions
        self.keybindingManager = keybindingManager
        self.keystrokeListener = keystrokeListener
        
        setupSubscribers()
    }
    
    func didSelectAction(_ action: Action) {
        if action == selectedAction {
            selectedAction = nil
        } else {
            selectedAction = action
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
        
        keybindingManager
            .$keybindMappings
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.keybindings = $0
            }
            .store(in: &cancellables)
    }
    
    private func didReceiveKeystroke(_ keystroke: Keystroke?) {
        guard let keystroke, let selectedAction else {
            return
        }
        
        keybindingManager.setKeybinding(keystroke, for: selectedAction)
    }
}
