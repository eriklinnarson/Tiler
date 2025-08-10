//
//  ResourcesTests.swift
//  TilerTests
//
//  Created by Erik Linnarson on 2025-08-10.
//

import XCTest

@testable import Tiler

final class ResourcesTests: XCTestCase {
    
    func test_menuBarIcon_exists() {
        let menuBarIcon = Resources.menuBarIcon
        
        XCTAssertNotNil(menuBarIcon)
    }
}
