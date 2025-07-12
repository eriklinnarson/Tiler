//
//  KeybindingSettingsCard.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-07-12.
//

import SwiftUI

struct KeybindingSettingsCard: View {
    let action: Action
    let keybindingDisplay: String
    let isSelected: Bool
    let onDidSelect: (Action) -> Void
    
    var body: some View {
        HStack {
            action.image
            Text(action.localizedName)
            Spacer()
            keybindingView
                .onTapGesture(count: 2) {
                    onDidSelect(action)
                }
        }
        .background(isSelected ? .blue : .clear)
    }
    
    private var keybindingView: some View {
        Text(keybindingDisplay)
    }
}
