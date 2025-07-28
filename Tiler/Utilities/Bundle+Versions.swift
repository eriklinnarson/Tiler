//
//  Bundle+Versions.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-07-20.
//

import Foundation

extension Bundle {
    var appVersionDisplay: String? {
        infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildNumberDisplay: String? {
        infoDictionary?["CFBundleVersion"] as? String
    }
}
