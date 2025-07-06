//
//  TilerApp.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-06-07.
//

import SwiftUI

@main
struct TilerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
