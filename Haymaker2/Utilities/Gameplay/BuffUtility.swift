//
//  BuffUtility.swift
//  Haymaker2
//
//  Created by Mitchell Taitano on 8/25/22.
//

import Foundation

class Buff {
    
    var BuffName: String = ""
    var BuffTurns: Int = 0
    var BuffAttributes: AttributesManager = AttributesManager()
    
    init() {
        
    }
    
    init(BuffName: String, BuffTurns: Int, BuffAttributes: AttributesManager) {
        self.BuffName = BuffName
        self.BuffTurns = BuffTurns
        self.BuffAttributes = BuffAttributes
    }
    
    func decrementBuffTurns() {
        BuffTurns = BuffTurns - 1
        if BuffTurns <= 0 {
            
        }
    }
}
