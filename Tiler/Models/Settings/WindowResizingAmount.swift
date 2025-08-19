//
//  WindowResizingAmount.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-08-16.
//

import Foundation

struct WindowResizingAmount: Setting {
    let constant: Int
    
    static var defaultValue: WindowResizingAmount {
        WindowResizingAmount(constant: 50)
    }
}
