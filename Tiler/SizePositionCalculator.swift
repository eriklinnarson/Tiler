//
//  SizePositionCalculator.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-06-07.
//

import Foundation
import AppKit

final class SizePositionCalculator {
    var resizeIncrement = 50.0
    
    func calculateShrink(
        towards direction: Direction,
        currentWindowPlacement: WindowPlacement
    ) -> WindowPlacement {
        let currentWindowPosition = currentWindowPlacement.position
        let currentWindowSize = currentWindowPlacement.size
        
        var newPosition = currentWindowPosition
        var newSize = currentWindowSize
        
        switch direction {
        case .left:
            newSize = CGSize(
                width: currentWindowSize.width - resizeIncrement,
                height: currentWindowSize.height
            )
        case .right:
            newSize = CGSize(
                width: currentWindowSize.width - resizeIncrement,
                height: currentWindowSize.height
            )
            newPosition = CGPoint(
                x: currentWindowPosition.x + resizeIncrement,
                y: currentWindowPosition.y
            )
        case .up:
            newSize = CGSize(
                width: currentWindowSize.width,
                height: currentWindowSize.height - resizeIncrement
            )
        case .down:
            newSize = CGSize(
                width: currentWindowSize.width,
                height: currentWindowSize.height - resizeIncrement
            )
            newPosition = CGPoint(
                x: currentWindowPosition.x,
                y: currentWindowPosition.y + resizeIncrement
            )
        }
        
        return WindowPlacement(position: newPosition, size: newSize)
    }
    
    func calculateExpansion(
        towards direction: Direction,
        currentWindowPlacement: WindowPlacement
    ) -> WindowPlacement {
        let currentWindowPosition = currentWindowPlacement.position
        let currentWindowSize = currentWindowPlacement.size
        
        var newPosition = currentWindowPosition
        var newSize = currentWindowSize
        
        switch direction {
        case .left:
            newSize = CGSize(
                width: currentWindowSize.width + resizeIncrement,
                height: currentWindowSize.height
            )
            newPosition = CGPoint(
                x: currentWindowPosition.x - resizeIncrement,
                y: currentWindowPosition.y
            )
        case .right:
            newSize = CGSize(
                width: currentWindowSize.width + resizeIncrement,
                height: currentWindowSize.height
            )
        case .up:
            newSize = CGSize(
                width: currentWindowSize.width,
                height: currentWindowSize.height + resizeIncrement
            )
            newPosition = CGPoint(
                x: currentWindowPosition.x,
                y: currentWindowPosition.y - resizeIncrement
            )
        case .down:
            newSize = CGSize(
                width: currentWindowSize.width,
                height: currentWindowSize.height + resizeIncrement
            )
        }
        
        /// Prevent overflowing towards left.
        /// Right overflowing is handled in `WindowManager`.
        newPosition = CGPoint(
            x: max(0, newPosition.x),
            y: max(0, newPosition.y)
        )
        
        return WindowPlacement(position: newPosition, size: newSize)
    }
}
