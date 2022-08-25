//
//  MoneyUtility.swift
//  Haymaker2
//
//  Created by Mitchell Taitano on 8/15/22.
//

import Foundation

class CurrencyManager {
    
    var GameCurrencyName: String = "Gold"
    
    func getRepairCostForWeapon(WeaponToRepair: Weapon) -> Int {
        switch WeaponToRepair.WeaponDamageStatus {
        case .None:
            return 0
        case .Broken:
            return (WeaponToRepair.WeaponCost / 4)
        case .Damaged:
            return (WeaponToRepair.WeaponCost / 2)
        case .Destroyed:
            return WeaponToRepair.WeaponCost
        }
        
    }
    
}
