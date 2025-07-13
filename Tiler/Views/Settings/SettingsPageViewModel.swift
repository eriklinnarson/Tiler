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
}

class SettingsPageViewModel: ObservableObject {
    private let actions: [Action]
    private let keybindingManager: KeybindingManager
    private let keystrokeListener: KeystrokeListener
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var selectedActionForRecordKeybinding: Action?
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func didSelectAction(_ action: Action) {
        if action == selectedActionForRecordKeybinding {
            selectedActionForRecordKeybinding = nil
            keystrokeListener.setIgnoreKeystrokes(false)
        } else {
            keystrokeListener.setIgnoreKeystrokes(true)
            selectedActionForRecordKeybinding = action
        }
    }
    
    func didTapRemoveKeybinding(forAction action: Action) {
        keybindingManager.removeKeybinding(forAction: action)
        selectedActionForRecordKeybinding = nil
    }
    
    func onViewDisappear() {
        selectedActionForRecordKeybinding = nil
        keystrokeListener.setIgnoreKeystrokes(false)
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
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillResignActive),
            name: NSApplication.willResignActiveNotification,
            object: nil
        )
    }
    
    private func didReceiveKeystroke(_ keystroke: Keystroke?) {
        guard let keystroke, let selectedActionForRecordKeybinding else {
            return
        }
        
        keybindingManager.setKeybinding(keystroke, for: selectedActionForRecordKeybinding)
    }

    @objc func appWillResignActive(_ notification: Notification) {
        onViewDisappear()
    }
}
