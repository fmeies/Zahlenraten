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
    var untergrenze : UInt = 0
    var obergrenze : UInt = 0
    var result : UInt = 0
    
    func reset(untergrenze: UInt, obergrenze: UInt){
        status = 0
        moves = 0
        self.untergrenze = untergrenze
        self.obergrenze = obergrenze
        result = UInt(arc4random_uniform(obergrenze - untergrenze + 1))
    }
    
    func guess(value: UInt){
        if (value < untergrenze || value > obergrenze){
            status = 4
            return
        }
        
        if(value < result){
            status = 1
        } else if(value > result){
            status = 2
        } else if (value == result){
            status = 3
        }
        ++moves
    }
}
