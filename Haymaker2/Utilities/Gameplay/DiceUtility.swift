//
//  DiceUtility.swift
//  Haymaker2
//
//  Created by Mitchell Taitano on 8/10/22.
//

import Foundation

class DiceUtility {
    
    func FlipCoin() -> Bool {
        return Bool.random()
    }
    
    func Roll_D2() -> Int {
        return Int.random(in: 1...2)
    }
    
    func Roll_D4() -> Int {
        return Int.random(in: 1...4)
    }
    
    func Roll_D6() -> Int {
        return Int.random(in: 1...6)
    }
    
    func Roll_D8() -> Int {
        return Int.random(in: 1...8)
    }
    
    func Roll_D10() -> Int {
        return Int.random(in: 1...10)
    }
    
    func Roll_D12() -> Int {
        return Int.random(in: 1...12)
    }
    
    func Roll_D20() -> Int {
        return Int.random(in: 1...20)
    }
    
    func Roll_DNUM(DieToRoll: String) -> Int {
        let components: [String] = DieToRoll.components(separatedBy: CharacterSet(charactersIn: "d"))
        let numberOfDie: Int = Int(components[0])!
        let dieNumberToRoll: Int = Int(components[1])!
        var sum: Int = 0
        for _ in 0..<numberOfDie {
            sum += Int.random(in: 1...dieNumberToRoll)
        }
        return sum
    }
}
