//
//  ScreenArea.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-06-07.
//

import Foundation

@objc
enum ScreenArea: Int, CaseIterable, Identifiable, Codable {
    
    case fullScreen
    case leftHalf
    case rightHalf
    case topHalf
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
    
    var id: Self { self }
    
    func cgPosition(
        in screen: NSRect,
        menuBarHeight: CGFloat = TilerApp.menuBarHeight
    ) -> CGPoint {
        var x: Int {
            switch self {
            case .fullScreen, .leftHalf, .topHalf, .topLeft, .bottomLeft:
                return 0
            case .rightHalf, .topRight, .bottomRight:
                return Int(screen.width / 2)
            }
        }
        
        var y: Int {
            switch self {
            case .fullScreen, .leftHalf, .topHalf, .rightHalf, .topLeft, .topRight:
                return Int(menuBarHeight)
            case .bottomLeft, .bottomRight:
                return Int(((screen.height - menuBarHeight) / 2) + menuBarHeight)
            }
        }
        
        return CGPoint(x: x, y: y)
    }
    
    func cgSize(
        in screen: NSRect,
        menuBarHeight: CGFloat = TilerApp.menuBarHeight
    ) -> CGSize {
        var width: Double {
            switch self {
            case .fullScreen, .topHalf:
                return screen.width
            case .leftHalf, .rightHalf, .topLeft, .bottomLeft, .topRight, .bottomRight:
                return screen.width / 2
            }
        }
        
        var height: Double {
            switch self {
            case .fullScreen:
                return screen.height
            case .leftHalf, .rightHalf:
                return screen.height - menuBarHeight
            case .topLeft, .topRight, .topHalf, .bottomLeft, .bottomRight:
                return (screen.height - menuBarHeight) / 2
            }
        }
        
        return CGSize(width: width, height: height)
    }
}
