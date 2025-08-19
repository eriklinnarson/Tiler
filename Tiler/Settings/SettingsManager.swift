//
//  SettingsManager.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-08-16.
//

import Combine
import Foundation

final class SettingsManager {
    @Published private(set) var windowResizingAmount: WindowResizingAmount
    
    private let storage: SettingsStorageManager
    
    init(storage: SettingsStorageManager) {
        self.storage = storage
        
        windowResizingAmount = storage.getWindowResizingAmount()
    }
    
    func getWindowResizingAmount() -> WindowResizingAmount {
        storage.getWindowResizingAmount()
    }
    
    func setWindowResizingAmount(_ newAmount: WindowResizingAmount) throws {
        try storage.setWindowResizingAmount(newAmount)
        windowResizingAmount = newAmount
    }
}
