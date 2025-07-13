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
        HStack(spacing: 7.5) {
            action.image
            Text(action.localizedName)
            
            Spacer()
            
            keybindingView
                .onTapGesture {
                    onDidSelect(action)
                }
            
            removeKeybindingButton
        }
    }
    
    private var keybindingView: some View {
        Text(keybindingDisplay)
            .frame(minWidth: 150, alignment: .center)
            .padding(.vertical, 2)
            .background {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(
                        isSelected ? .blue : .clear,
                        lineWidth: 4
                    )
                    .fill(Color.white)
                    .shadow(radius: 1, x: 1, y: 1)
                    .animation(.easeInOut(duration: 0.2), value: isSelected)
            }
    }
    
    private var removeKeybindingButton: some View {
        Button {
            print("remove keybinding")
        } label: {
            Image(systemName: "x.circle.fill")
                .font(.body)
        }
        .buttonStyle(.plain)
    }
}
