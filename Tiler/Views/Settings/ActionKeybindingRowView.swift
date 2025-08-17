//
//  KeybindingSettingsCard.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-07-12.
//

import SwiftUI

struct ActionKeybindingRowView: View {
    let model: ActionKeybindingRowModel
    let isSelected: Bool
    let onDidSelect: (Action) -> Void
    let onDidRemove: (Action) -> Void
    
    var keybindingDisplay: String {
        model.keybinding?.display ?? "-"
    }
    
    var body: some View {
        HStack(spacing: 7.5) {
            model.action.image
            Text(model.action.localizedName)
            
            Spacer()
            
            keybindingView
                .onTapGesture {
                    onDidSelect(model.action)
                }
            
            removeKeybindingButton
        }
    }
    
    @ViewBuilder
    private var keybindingView: some View {
        let hasKeybinding = model.keybinding != nil
        
        Text(keybindingDisplay)
            .foregroundStyle(hasKeybinding ? Color.primary : Color.gray)
            .frame(minWidth: 150, alignment: .center)
            .padding(.vertical, 2)
            .background {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(
                        isSelected ? .blue : .clear,
                        lineWidth: 4
                    )
                    .fill(Color(NSColor.windowBackgroundColor))
                    .shadow(radius: 1, x: 1, y: 1)
                    .animation(.easeInOut(duration: 0.2), value: isSelected)
            }
    }
    
    @ViewBuilder
    private var removeKeybindingButton: some View {
        let buttonHidden = model.keybinding == nil
        
        Button {
            onDidRemove(model.action)
        } label: {
            Image(systemName: "x.circle.fill")
                .font(.body)
        }
        .buttonStyle(.plain)
        .opacity(buttonHidden ? 0 : 1)
        .disabled(buttonHidden)
        .animation(
            buttonHidden ? nil : .default, // Animate when the button appears, but not dissapear
            value: buttonHidden
        )
    }
}
