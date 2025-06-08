//
//  Direction+LocalizedName.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-06-07.
//

import Foundation

extension Direction {
    var shrinkLocalizedName: String {
        switch self {
        case .left:
            "Shrink towards left"
        case .right:
            "Shrink towards right"
        case .up:
            "Shrink upwards"
        case .down:
            "Shrink downwards"
        }
    }
    
    var expandLocalizedName: String {
        switch self {
        case .left:
            "Grow towards left"
        case .right:
            "Grow towards right"
        case .up:
            "Grow upwards"
        case .down:
            "Grow downwards"
        }
    }
}
