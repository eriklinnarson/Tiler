//
//  PermissionsManager.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-08-09.
//

import ApplicationServices
import Foundation
import OSLog

final class PermissionsManager {
    
    static let shared = PermissionsManager()
    
    private init() {
        requestAccessibilityPermission()
    }
    
    @Published private(set) var accessibilityPermissionsGranted: Bool?
    
    private var pollingTimer = Timer()
    private let pollingInterval: TimeInterval = 0.5
    
    /// Check for accessibility permissions without prompting the user
    @discardableResult
    func checkAccessibilityPermission() -> Bool {
        let isGranted = AXIsProcessTrusted()
        updatePublisher(withValue: isGranted)
        loggAccessibilityPermissions(isGranted)
        return isGranted
    }
    
    /// Check for accessibility permissions and prompt the user, if they're not granted
    @discardableResult
    func requestAccessibilityPermission() -> Bool {
        let options: [String: Any] = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as String: true]
        let isGranted = AXIsProcessTrustedWithOptions(options as CFDictionary)
        updatePublisher(withValue: isGranted)
        loggAccessibilityPermissions(isGranted)
        return isGranted
    }
    
    private func updatePublisher(withValue isPermissionsGranted: Bool) {
        if isPermissionsGranted {
            stopPolling()
        } else {
            startPolling()
        }
        
        accessibilityPermissionsGranted = isPermissionsGranted
    }
    
    private func loggAccessibilityPermissions(_ isGranted: Bool) {
        guard
            !isGranted,
            !pollingTimer.isValid
        else {
            return
        }
        
        Logger.permissionsManager.warning("Accessibility privileges not granted")
    }
    
    private func startPolling() {
        guard pollingTimer.isValid == false else {
            return
        }
        
        Logger.permissionsManager.info("Starting polling for accessibility permissions:")
        pollingTimer = Timer.scheduledTimer(
            timeInterval: pollingInterval,
            target: self,
            selector: #selector(self.pollForAccessibilitySettings),
            userInfo: nil,
            repeats: true
        )
    }
    
    @objc
    private func pollForAccessibilitySettings() {
        Logger.permissionsManager.info("Polling ...")
        checkAccessibilityPermission()
    }
    
    private func stopPolling() {
        guard pollingTimer.isValid else {
            return
        }
        
        Logger.permissionsManager.info("Stopping polling")
        pollingTimer.invalidate()
    }
}

private extension Logger {
    static let permissionsManager = Logger(subsystem: subsystem, category: "permissionsManager")
}
