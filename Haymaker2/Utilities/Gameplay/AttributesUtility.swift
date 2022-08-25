//
//  AttributesUtility.swift
//  Haymaker2
//
//  Created by Mitchell Taitano on 8/13/22.
//

import Foundation

class AttributesManager {
    
    //MARK: - Identifier Attributes
    var ID: String = ""
    var Image: String = ""
    var Name: String = ""
    
    //MARK: - Core Attributes
    var Health: Int = 0
    var Energy: Int = 0
    var Speed: Int = 0
    var Initiative: Int = 0
    var HealthRecovery: Int = 0
    var EnergyRecovery: Int = 0
    
    //MARK: - Attack Attributes
    var Attack: Int = 0
    var Damage: Int = 0
    var Fighting: Int = 0
    var Sharpshooting: Int = 0
    var CombatMagic: Int = 0
    
    //MARK: - Defense Attributes
    var MeleeDefense: Int = 0
    var RangeDefense: Int = 0
    var Toughness: Int = 0
    var Willpower: Int = 0
    
    //MARK: - Strength/Weakness Attributes
    var ImmuneTypes: [AttackType] = []
    var ImmuneTypesTurns: [Int] = []
    
    var StrengthTypes: [AttackType] = []
    var StrengthTypesTurns: [Int] = []
    
    var WeaknessTypes: [AttackType] = []
    var WeaknessTypesTurns: [Int] = []
    
    var MeleeImmune: Bool = false
    var MeleeImmuneTurns: Int = 0
    
    var RangeImmune: Bool = false
    var RangeImmuneTurns: Int = 0
    
    init() {
        
    }
    
    init(Name: String) {
        self.Name = Name
    }
    
    init(Name: String, ImageString: String) {
        self.Name = Name
        self.Image = ImageString
    }
    
    init(ID: String, Image: String, Name: String, Health: Int, Energy: Int, Speed: Int, Initiative: Int, HealthRecovery: Int, EnergyRecovery: Int, Attack: Int, Damage: Int, Fighting: Int, Sharpshooting: Int, CombatMagic: Int, MeleeDefense: Int, RangeDefense: Int, Toughness: Int, Willpower: Int, ImmuneTypes: [AttackType], ImmuneTypesTurns: [Int], StrengthTypes: [AttackType], StrengthTypesTurns: [Int], WeaknessTypes: [AttackType], WeaknessTypesTurns: [Int], MeleeImmune: Bool, MeleeImmuneTurns: Int, RangeImmune: Bool, RangeImmuneTurns: Int) {
        
    }
    
    func decrementStrengthWeaknessTurns() {
        for i in 0..<ImmuneTypesTurns.count {
            ImmuneTypesTurns[i] = ImmuneTypesTurns[i] - 1
            if ImmuneTypesTurns[i] <= 0 {
                ImmuneTypesTurns[i] = 0
            }
        }
        for i in 0..<StrengthTypesTurns.count {
            StrengthTypesTurns[i] = StrengthTypesTurns[i] - 1
            if StrengthTypesTurns[i] <= 0 {
                StrengthTypesTurns[i] = 0
            }
        }
        for i in 0..<WeaknessTypesTurns.count {
            WeaknessTypesTurns[i] = WeaknessTypesTurns[i] - 1
            if WeaknessTypesTurns[i] <= 0 {
                WeaknessTypesTurns[i] = 0
            }
        }
        MeleeImmuneTurns = MeleeImmuneTurns - 1
        RangeImmuneTurns = RangeImmuneTurns - 1
        
        if MeleeImmuneTurns <= 0 {
            MeleeImmuneTurns = 0
        }
        if RangeImmuneTurns <= 0 {
            RangeImmuneTurns = 0
        }
        
        for i in (ImmuneTypesTurns.count - 1)...0 {
            if ImmuneTypesTurns[i] <= 0 {
                ImmuneTypes.remove(at: i)
                ImmuneTypesTurns.remove(at: i)
            }
        }
        for i in (StrengthTypesTurns.count - 1)...0 {
            if StrengthTypesTurns[i] <= 0 {
                StrengthTypes.remove(at: i)
                StrengthTypesTurns.remove(at: i)
            }
        }
        for i in (WeaknessTypesTurns.count - 1)...0 {
            if WeaknessTypesTurns[i] <= 0 {
                WeaknessTypes.remove(at: i)
                WeaknessTypesTurns.remove(at: i)
            }
        }
        if MeleeImmuneTurns <= 0 {
            MeleeImmune = false
        }
        if RangeImmuneTurns <= 0 {
            RangeImmune = false
        }
    }
    
    func combineWithAttributeManager(AttributesToAdd: AttributesManager) -> AttributesManager {
        let newAttributeManager: AttributesManager = AttributesManager()
        newAttributeManager.Health = self.Health + AttributesToAdd.Health
        newAttributeManager.Energy = self.Energy + AttributesToAdd.Energy
        newAttributeManager.Speed = self.Speed + AttributesToAdd.Speed
        newAttributeManager.Initiative = self.Initiative + AttributesToAdd.Initiative
        newAttributeManager.HealthRecovery = self.HealthRecovery + AttributesToAdd.HealthRecovery
        newAttributeManager.EnergyRecovery = self.EnergyRecovery + AttributesToAdd.EnergyRecovery
        newAttributeManager.Fighting = self.Fighting + AttributesToAdd.Fighting
        newAttributeManager.Sharpshooting = self.Sharpshooting + AttributesToAdd.Sharpshooting
        newAttributeManager.CombatMagic = self.CombatMagic + AttributesToAdd.CombatMagic
        newAttributeManager.Attack = self.Attack + AttributesToAdd.Attack
        newAttributeManager.Damage = self.Damage + AttributesToAdd.Damage
        newAttributeManager.MeleeDefense = self.MeleeDefense + AttributesToAdd.MeleeDefense
        newAttributeManager.RangeDefense = self.RangeDefense + AttributesToAdd.RangeDefense
        newAttributeManager.Toughness = self.Toughness + AttributesToAdd.Toughness
        newAttributeManager.Willpower = self.Willpower + AttributesToAdd.Willpower
        var combinedImmuneTypes: [AttackType] = self.ImmuneTypes
        combinedImmuneTypes.append(contentsOf: AttributesToAdd.ImmuneTypes)
        var combinedStrengthTypes: [AttackType] = self.StrengthTypes
        combinedStrengthTypes.append(contentsOf: AttributesToAdd.StrengthTypes)
        var combinedWeaknessTypes: [AttackType] = self.StrengthTypes
        combinedWeaknessTypes.append(contentsOf: AttributesToAdd.WeaknessTypes)
        newAttributeManager.ImmuneTypes = combinedImmuneTypes
        newAttributeManager.StrengthTypes = combinedStrengthTypes
        newAttributeManager.WeaknessTypes = combinedWeaknessTypes
        newAttributeManager.MeleeImmune = self.MeleeImmune || AttributesToAdd.MeleeImmune
        newAttributeManager.RangeImmune = self.RangeImmune || AttributesToAdd.RangeImmune
        return newAttributeManager
    }
}
