//
//  Direction+LocalizedName.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-06-07.
//

import Foundation

extension Direction {
    var localizedName: String {
        switch self {
        case .left:
            "Left"
        case .right:
            "Right"
        case .up:
            "Up"
        case .down:
            "Down"
        }
    }
}
