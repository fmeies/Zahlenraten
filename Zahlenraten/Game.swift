//
//  Game.swift
//  Zahlenraten
//
//  Created by Frank Meies on 25.01.15.
//  Copyright (c) 2015 Frank Meies. All rights reserved.
//

import Foundation

class Game{

	var status : UInt = 0
	var moves: UInt = 0
	var lowerBoundary : UInt = 0
	var upperBoundary : UInt = 0
	var result : UInt = 0

	func reset(_ lowerBoundary: UInt, upperBoundary: UInt){
		status = 0
		moves = 0
		self.lowerBoundary = lowerBoundary
		self.upperBoundary = upperBoundary
		let dist = UInt32(upperBoundary - lowerBoundary + 1)
		result = UInt(arc4random_uniform(dist)) + lowerBoundary
	}

	func guess(_ value: UInt){
		if value < lowerBoundary || value > upperBoundary {
			status = 4
			return
		}

		if value < result {
			status = 1
		} else if value > result {
			status = 2
		} else if value == result {
			status = 3
		}
		moves += 1
	}
}
