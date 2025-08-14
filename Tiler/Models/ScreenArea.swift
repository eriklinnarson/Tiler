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
    case bottomHalf
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
    
    var id: Self { self }
}
