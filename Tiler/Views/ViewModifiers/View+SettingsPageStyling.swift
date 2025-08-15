//
//  View+SettingsPageStyling.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-07-15.
//

import SwiftUI

extension View {
    func settingsPageStyling() -> some View {
        modifier(SettingsPageStylingViewModifer())
    }
}

struct SettingsPageStylingViewModifer: ViewModifier {
    func body(content: Content) -> some View {
        ScrollView {
            content
                .padding()
        }
        .font(.title2)
    }
}
