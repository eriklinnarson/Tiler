//
//  ScreenArea+LocalizedName.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-06-07.
//

import Foundation

extension ScreenArea {
    var localizedName: String {
        switch self {
        case .fullScreen:
            "Full screen"
        case .leftHalf:
            "Left half"
        case .rightHalf:
            "Right half"
        case .topHalf:
            "Top half"
        case .topLeft:
            "Top left"
        case .bottomLeft:
            "Bottom left"
        case .topRight:
            "Top right"
        case .bottomRight:
            "Bottom Right"
        }
    }
}
