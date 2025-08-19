//
//  SettingProtocol.swift
//  Tiler
//
//  Created by Erik Linnarson on 2025-08-16.
//

import Foundation

protocol Setting: Hashable, Codable {
    static var defaultValue: Self { get }
}
