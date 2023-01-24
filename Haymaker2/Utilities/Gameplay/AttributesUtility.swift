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
    
    //MARK: - Resistance/Weakness Attributes
    var ImmuneTypes: [AttackType] = []
    var ImmuneTypesTurns: [Int] = []
    
    var ResistanceAndWeaknessTypes: [AttackType] = []
    var ResistanceAndWeaknessTypesTurns: [Int] = []
    
    var MeleeImmune: Bool = false
    var MeleeImmuneTurns: Int = 0
    
    var RangeImmune: Bool = false
    var RangeImmuneTurns: Int = 0
    
    init() {
        
    }
    
    init(Name: String) {
        self.Name = Name
        
        setUpResistanceWeaknessTypeArrays()
    }
    
    init(Name: String, ImageString: String) {
        self.Name = Name
        self.Image = ImageString
        
        setUpResistanceWeaknessTypeArrays()
    }
    
    init(ID: String, Image: String, Name: String, Health: Int, Energy: Int, Speed: Int, Initiative: Int, HealthRecovery: Int, EnergyRecovery: Int, Attack: Int, Damage: Int, Fighting: Int, Sharpshooting: Int, CombatMagic: Int, MeleeDefense: Int, RangeDefense: Int, Toughness: Int, Willpower: Int, ImmuneTypes: [AttackType], ImmuneTypesTurns: [Int], StrengthTypes: [AttackType], StrengthTypesTurns: [Int], WeaknessTypes: [AttackType], WeaknessTypesTurns: [Int], MeleeImmune: Bool, MeleeImmuneTurns: Int, RangeImmune: Bool, RangeImmuneTurns: Int) {
        
        setUpResistanceWeaknessTypeArrays()
    }
    
    func setUpResistanceWeaknessTypeArrays() {
        for nextType in AttackType.allCases {
            self.ImmuneTypes.append(nextType)
            self.ImmuneTypesTurns.append(0)
            
            self.ResistanceAndWeaknessTypes.append(nextType)
            self.ResistanceAndWeaknessTypesTurns.append(0)
        }
    }
    
    func decrementResistanceAndWeaknessTurns() {
        for i in 0..<ImmuneTypesTurns.count {
            if ImmuneTypesTurns[i] != 0 {
                if ImmuneTypesTurns[i] > 0 {
                    ImmuneTypesTurns[i] = ImmuneTypesTurns[i] - 1
                } else {
                    ImmuneTypesTurns[i] = ImmuneTypesTurns[i] + 1
                }
            }
        }
        
        for i in 0..<ResistanceAndWeaknessTypesTurns.count {
            if ResistanceAndWeaknessTypesTurns[i] != 0 {
                if ResistanceAndWeaknessTypesTurns[i] > 0 {
                    ResistanceAndWeaknessTypesTurns[i] = ResistanceAndWeaknessTypesTurns[i] - 1
                } else {
                    ResistanceAndWeaknessTypesTurns[i] = ResistanceAndWeaknessTypesTurns[i] + 1
                }
            }
        }
        
        MeleeImmuneTurns = MeleeImmuneTurns - 1
        RangeImmuneTurns = RangeImmuneTurns - 1
        
        if MeleeImmuneTurns <= 0 {
            MeleeImmuneTurns = 0
            MeleeImmune = false
        } else {
            MeleeImmune = true
        }
        if RangeImmuneTurns <= 0 {
            RangeImmuneTurns = 0
            RangeImmune = false
        } else {
            RangeImmune = true
        }
    }
}
