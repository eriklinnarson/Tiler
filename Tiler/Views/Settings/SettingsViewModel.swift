//
//  SettingsViewModel.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-07-06.
//

import Combine
import SwiftUI

final class SettingsViewModel: ObservableObject {
    @Published private(set) var mostRecentKeystroke: Keystroke?
    
    private let keystrokeListener: KeystrokeListener
    private var cancellables = Set<AnyCancellable>()
    
    init(keystrokeListener: KeystrokeListener) {
        self.keystrokeListener = keystrokeListener
        
        setupPublisher()
    }
    
    private func setupPublisher() {
        keystrokeListener
            .$keystroke
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.mostRecentKeystroke = $0
            }
            .store(in: &cancellables)
    }
}
