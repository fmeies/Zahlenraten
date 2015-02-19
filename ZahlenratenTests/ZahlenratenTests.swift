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
        game.reset(10, upperBoundary: 100)
        game.result = 47
        XCTAssert(game.status == 0, "Pass")

        var dataProvider: [UInt : UInt] = [101: 4, 9: 4, 10: 1, 100: 2, 47: 3]
        for (number, expected) in dataProvider {
            game.guess(number)
            XCTAssert(game.status == expected, "Pass")
        }
    }

    func testBoundaries() {
        var game: Game = Game()

        var dataProvider: [UInt : UInt] = [0: 0, 1: 1, 2: 2, 10: 10]
        for (lower, upper) in dataProvider {
            game.reset(lower, upperBoundary: upper)
            game.guess(lower)
            XCTAssert(game.status == 3, "Pass")
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
