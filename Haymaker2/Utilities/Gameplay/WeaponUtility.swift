//
//  WeaponUtility.swift
//  Haymaker2
//
//  Created by Mitchell Taitano on 8/13/22.
//

import Foundation

enum WeaponHand: String {
    case OneHand
    case TwoHand
    case MainHand
    case OffHand
    case None
}

class Weapon {
    
    var WeaponID: String = ""
    var WeaponImageString: String = ""
    var WeaponType: String = "''"
    var WeaponHand: WeaponHand = .None
    var WeaponRarity: Rarity = .Common
    var WeaponSkillType: AttackClass = .Fighting
    var WeaponMinimumSkill: Int = 0
    var WeaponCost: Int = 0
    var WeaponDurabilityHealth: Int = 0
    var WeaponDamageStatus: EquipmentDamageStatus = .None
    var PrimaryAttack: ParagonAttack
    var WeaponAttacks: [ParagonAttack]
    var WeaponAttributes: AttributesManager
    
    init() {
        self.WeaponID = ""
        self.WeaponImageString = ""
        self.WeaponType = ""
        self.WeaponHand = .None
        self.WeaponRarity = .Common
        self.WeaponSkillType = .Fighting
        self.WeaponMinimumSkill = 0
        self.WeaponCost = 0
        self.WeaponDurabilityHealth = 0
        self.WeaponDamageStatus = .None
        self.PrimaryAttack = ParagonAttack()
        self.WeaponAttacks = []
        self.WeaponAttributes = AttributesManager()
    }
    
    init(WeaponID: String = "", WeaponImageString: String, WeaponType: String, WeaponHand: WeaponHand = .None, WeaponRarity: Rarity = .Common, WeaponSkillType: AttackClass = .Fighting, WeaponMinimumSkill: Int = 0, WeaponCost: Int = 0, WeaponDurabilityHealth: Int = 0, WeaponDamageStatus: EquipmentDamageStatus = .None, WeaponAttacks: [ParagonAttack], WeaponAttributes: AttributesManager) {
        self.WeaponID = WeaponID
        self.WeaponImageString = WeaponImageString
        self.WeaponType = WeaponType
        self.WeaponHand = WeaponHand
        self.WeaponRarity = WeaponRarity
        self.WeaponSkillType = WeaponSkillType
        self.WeaponMinimumSkill = WeaponMinimumSkill
        self.WeaponCost = WeaponCost
        self.WeaponDurabilityHealth = WeaponDurabilityHealth
        self.WeaponDamageStatus = WeaponDamageStatus
        self.WeaponAttacks = WeaponAttacks
        self.WeaponAttributes = WeaponAttributes
        
        PrimaryAttack = WeaponAttacks[0]
        for nextAttack in WeaponAttacks {
            if nextAttack.isPrimaryAttack {
                PrimaryAttack = nextAttack
                break
            }
        }
    }
    
}

class WeaponSet {
    
    var AllWeapons: [Weapon] = []
    
    init() {
        
    }
    
    init(Weapons: [Weapon]) {
        self.AllWeapons = Weapons
    }
    
    func addWeaponToSet(WeaponToAdd: Weapon, ToHand: WeaponHand) -> Weapon {
        switch ToHand {
        case .MainHand:
            return WeaponToAdd
        case .TwoHand:
            return WeaponToAdd
        case .OneHand:
            return WeaponToAdd
        case .OffHand:
            return WeaponToAdd
        case .None:
            return WeaponToAdd
        }
    }
    
    func getTotalWeaponAttributes() -> AttributesManager {
        let TotalWeaponAttributes: AttributesManager = AttributesManager()
        for nextWeapon in AllWeapons {
            TotalWeaponAttributes.Health += nextWeapon.WeaponAttributes.Health
            TotalWeaponAttributes.Energy += nextWeapon.WeaponAttributes.Energy
            TotalWeaponAttributes.Speed += nextWeapon.WeaponAttributes.Speed
            TotalWeaponAttributes.Initiative += nextWeapon.WeaponAttributes.Initiative
            TotalWeaponAttributes.HealthRecovery += nextWeapon.WeaponAttributes.HealthRecovery
            TotalWeaponAttributes.EnergyRecovery += nextWeapon.WeaponAttributes.EnergyRecovery
            TotalWeaponAttributes.Fighting += nextWeapon.WeaponAttributes.Fighting
            TotalWeaponAttributes.Sharpshooting += nextWeapon.WeaponAttributes.Sharpshooting
            TotalWeaponAttributes.CombatMagic += nextWeapon.WeaponAttributes.CombatMagic
            TotalWeaponAttributes.Attack += nextWeapon.WeaponAttributes.Attack
            TotalWeaponAttributes.Damage += nextWeapon.WeaponAttributes.Damage
            TotalWeaponAttributes.MeleeDefense += nextWeapon.WeaponAttributes.MeleeDefense
            TotalWeaponAttributes.RangeDefense += nextWeapon.WeaponAttributes.RangeDefense
            TotalWeaponAttributes.Toughness += nextWeapon.WeaponAttributes.Toughness
            TotalWeaponAttributes.Willpower += nextWeapon.WeaponAttributes.Willpower
            TotalWeaponAttributes.StrengthTypes.append(contentsOf: nextWeapon.WeaponAttributes.StrengthTypes)
            TotalWeaponAttributes.WeaknessTypes.append(contentsOf: nextWeapon.WeaponAttributes.WeaknessTypes)
        }
        return TotalWeaponAttributes
    }
}
