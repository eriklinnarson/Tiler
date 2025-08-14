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
    
    func idealSize(
        of screenArea: ScreenArea,
        in screen: NSRect,
        withMenuBarHeight menuBarHeight: CGFloat = TilerApp.menuBarHeight
    ) -> CGSize {
        var width: Double {
            switch screenArea {
            case .fullScreen, .topHalf, .bottomHalf:
                return screen.width
            case .leftHalf, .rightHalf, .topLeft, .bottomLeft, .topRight, .bottomRight:
                return screen.width / 2
            }
        }
        
        var height: Double {
            switch screenArea {
            case .fullScreen, .leftHalf, .rightHalf:
                return screen.height - menuBarHeight
            case .topLeft, .topRight, .topHalf, .bottomHalf, .bottomLeft, .bottomRight:
                return (screen.height - menuBarHeight) / 2
            }
        }
        
        return CGSize(width: width, height: height)
    }
    
    func idealPosition(
        of screenArea: ScreenArea,
        in screen: NSRect,
        withMenuBarHeight menuBarHeight: CGFloat = TilerApp.menuBarHeight
    ) -> CGPoint {
        var x: Int {
            switch screenArea {
            case .fullScreen, .leftHalf, .topHalf, .bottomHalf, .topLeft, .bottomLeft:
                return 0
            case .rightHalf, .topRight, .bottomRight:
                return Int(screen.width / 2)
            }
        }
        
        var y: Int {
            switch screenArea {
            case .fullScreen, .leftHalf, .topHalf, .rightHalf, .topLeft, .topRight:
                return Int(menuBarHeight)
            case .bottomHalf, .bottomLeft, .bottomRight:
                return Int(((screen.height - menuBarHeight) / 2) + menuBarHeight)
            }
        }
        
        return CGPoint(x: x, y: y)
    }
}
