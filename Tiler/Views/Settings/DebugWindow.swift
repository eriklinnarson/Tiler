//
//  DebugWindow.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-08-12.
//

#if DEBUG
import SwiftUI

struct DebugWindow: View {
    let windowManager: WindowManager
    
    var body: some View {
        DebugWindowContentView(windowManager: windowManager)
            .frame(width: 200, height: 200)
    }
}

private struct DebugWindowContentView: View {
    let windowManager: WindowManager
    
    @State private var windowOrigin: CGPoint = .zero
    @State private var timer: Timer?
    @State private var pinnedToScreenInDirections = [Direction]()

    var body: some View {
        VStack {
            Text("Position: \(Int(windowOrigin.x)), \(Int(windowOrigin.y))")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .onAppear {
            timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { _ in
                windowOrigin = windowManager.frontMostWindowPosition() ?? .zero
                pinnedToScreenInDirections = windowManager.screenAlignedInDirections()
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
        .safeAreaInset(edge: .bottom) {
            let symbol = pinnedToScreenInDirections.contains(.down) ? "✅" : "❌"
            Text(symbol)
        }
        .safeAreaInset(edge: .leading) {
            let symbol = pinnedToScreenInDirections.contains(.left) ? "✅" : "❌"
            Text(symbol)
        }
        .safeAreaInset(edge: .top) {
            let symbol = pinnedToScreenInDirections.contains(.up) ? "✅" : "❌"
            Text(symbol)
        }
        .safeAreaInset(edge: .trailing) {
            let symbol = pinnedToScreenInDirections.contains(.right) ? "✅" : "❌"
            Text(symbol)
        }
    }
}

#endif
