//
//  ZahlenratenTests.swift
//  ZahlenratenTests
//
//  Created by Frank Meies on 24.01.15.
//  Copyright (c) 2015 Frank Meies. All rights reserved.
//

import UIKit
import XCTest

class ZahlenratenTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGame() {
        var game: Game = Game()
        game.reset(10, obergrenze: 100)
        game.result = 47
        XCTAssert(game.status == 0, "Pass")
        game.guess(101)
        XCTAssert(game.status == 4, "Pass")
        game.guess(9)
        XCTAssert(game.status == 4, "Pass")
        game.guess(10)
        XCTAssert(game.status == 1, "Pass")
        game.guess(100)
        XCTAssert(game.status == 2, "Pass")
        game.guess(47)
        XCTAssert(game.status == 3, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
