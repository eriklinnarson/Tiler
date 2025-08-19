//
//  SettingsWindowSnappingViewModel.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-07-12.
//

import SwiftUI
import Combine
import OSLog

struct ActionKeybindingRowModel: Identifiable {
    let action: Action
    let keybinding: Keystroke?
    
    var id: String { action.id }
}

class SettingsPageViewModel: ObservableObject {
    private let keybindingManager: KeybindingManager
    private let keystrokeManager: KeystrokeManager
    
    fileprivate var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var selectedActionForRecordKeybinding: Action?
    @Published private var keybindings: [Keystroke: Action] = [:]
    
    init(
        keybindingManager: KeybindingManager,
        keystrokeManager: KeystrokeManager
    ) {
        self.keybindingManager = keybindingManager
        self.keystrokeManager = keystrokeManager
        
        setupSubscribers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func rowModel(forAction action: Action) -> ActionKeybindingRowModel {
        let keybinding = keybindings.first {
            $0.value == action
        }?.key
        
        return ActionKeybindingRowModel(action: action, keybinding: keybinding)
    }

    
    func didSelectAction(_ action: Action) {
        if action == selectedActionForRecordKeybinding {
            Logger.settingsPageViewModel.info("Action deselected for keybinding recording: \(action.id)")
            disableKeybindingRecording()
        } else {
            Logger.settingsPageViewModel.info("Action selected for keybinding recording: \(action.id)")
            keystrokeManager.setIgnoreKeystrokes(true)
            selectedActionForRecordKeybinding = action
        }
    }
    
    func disableKeybindingRecording() {
        selectedActionForRecordKeybinding = nil
        keystrokeManager.setIgnoreKeystrokes(false)
    }
    
    func didTapRemoveKeybinding(forAction action: Action) {
        Logger.settingsPageViewModel.info("Button for remove action tapped: \(action.id)")
        keybindingManager.removeKeybinding(forAction: action)
        selectedActionForRecordKeybinding = nil
    }
    
    func onViewDisappear() {
        selectedActionForRecordKeybinding = nil
        keystrokeManager.setIgnoreKeystrokes(false)
    }
    
    fileprivate func setupSubscribers() {
        keystrokeManager
            .$mostRecentKeystroke
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
        disableKeybindingRecording()
    }

    @objc func appWillResignActive(_ notification: Notification) {
        onViewDisappear()
    }
}

class SettingsWindowResizingViewModel: SettingsPageViewModel {
    @Published private(set) var windowResizingAmount: WindowResizingAmount?
    @Published var windowResizingConstantTextField: Int
    
    private let settingsManager: SettingsManager
    
    init(
        keybindingManager: KeybindingManager,
        keystrokeManager: KeystrokeManager,
        settingsManager: SettingsManager
    ) {
        self.settingsManager = settingsManager
        windowResizingConstantTextField = settingsManager.getWindowResizingAmount().constant
        
        super.init(
            keybindingManager: keybindingManager,
            keystrokeManager: keystrokeManager
        )
    }
    
    func setWindowResizingAmount(_ newValue: WindowResizingAmount) {
        do {
            try settingsManager.setWindowResizingAmount(newValue)
            Logger.settingsPageViewModel.info("WindowResizingAmount updated: \(newValue.constant)")
        } catch {
            Logger.settingsPageViewModel.error("Failed to update WindowResizingAmount")
            // TODO: Present Alert
        }
    }
    
    override func setupSubscribers() {
        super.setupSubscribers()
        
        settingsManager
            .$windowResizingAmount
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .assign(to: &$windowResizingAmount)
        
        $windowResizingConstantTextField
            .dropFirst()
            .removeDuplicates()
            .compactMap { $0 }
            .sink { [weak self] newValue in
                self?.setWindowResizingAmount(.init(constant: newValue))
            }
            .store(in: &cancellables)
    }
}

private extension Logger {
    static let settingsPageViewModel = Logger(subsystem: subsystem, category: "settingsPageViewModel")
}
