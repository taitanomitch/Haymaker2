//
//  GearUtility.swift
//  Haymaker2
//
//  Created by Mitchell Taitano on 8/13/22.
//

import Foundation

enum GearType {
    case Helm
    case Chest
    case Shoulder
    case Leggings
    case Boots
    case Belt
    case Back
    case Ring
    case Neck
    case None
}

class Gear {
    
    var GearRarity: Rarity = .Common
    var Cost: Int = 0
    var GearHealth: Int = 0
    var EquipmentDamageStatus: EquipmentDamageStatus = .None
    var GearAttributes: AttributesManager
    var GearType: GearType = .None
    
    init() {
        GearAttributes = AttributesManager()
    }
    
    init(Name: String, ImageString: String, Cost: Int, Rarity: Rarity, GearHealth: Int) {
        self.GearRarity = Rarity
        self.Cost = Cost
        self.GearHealth = GearHealth
        self.GearAttributes = AttributesManager(Name: Name, ImageString: ImageString)
    }
}

class GearSet {
    
    var hasHelm: Bool = false
    var hasChest: Bool = false
    var hasShoulder: Bool = false
    var hasLeggings: Bool = false
    var hasBoots: Bool = false
    var hasBelt: Bool = false
    var hasBack: Bool = false
    var hasNone: Bool = true
    
    var AllGear: [Gear] = []
    
    init() {
        updateGearBooleans()
    }
    
    init(Gear: [Gear]) {
        self.AllGear = Gear
        updateGearBooleans()
    }
    
    func addGearToSet(GearToAdd: Gear) -> Gear {
        var GearReplaced: Bool = false
        var GearThatWasReplaced: Gear = Gear()
        for i in 0..<AllGear.count {
            if AllGear[i].GearType == GearToAdd.GearType {
                GearThatWasReplaced = AllGear[i]
                GearReplaced = true
                AllGear[i] = GearToAdd
            }
        }
        if !GearReplaced {
            AllGear.append(GearToAdd)
            switch GearToAdd.GearType {
            case .Helm: hasHelm = true
            case .Chest: hasChest = true
            case .Shoulder: hasShoulder = true
            case .Leggings: hasLeggings = true
            case .Boots: hasBoots = true
            case .Belt: hasBelt = true
            case .Back: hasBack = true
            default: hasNone = true
            }
        }
        return GearThatWasReplaced
    }
    
    func removeGearFromSet(Position: Int) {
        let gearToRemove =  AllGear.remove(at: Position)
        switch gearToRemove.GearType {
        case .Helm: hasHelm = false
        case .Chest: hasChest = false
        case .Shoulder: hasShoulder = false
        case .Leggings: hasLeggings = false
        case .Boots: hasBoots = false
        case .Belt: hasBelt = false
        case .Back: hasBack = false
        default: hasNone = true
        }
    }
    
    func getTotalGearAttributes() -> AttributesManager {
        let TotalGearAttributes: AttributesManager = AttributesManager()
        for nextGear in AllGear {
            TotalGearAttributes.Health += nextGear.GearAttributes.Health
            TotalGearAttributes.Energy += nextGear.GearAttributes.Energy
            TotalGearAttributes.Speed += nextGear.GearAttributes.Speed
            TotalGearAttributes.Initiative += nextGear.GearAttributes.Initiative
            TotalGearAttributes.HealthRecovery += nextGear.GearAttributes.HealthRecovery
            TotalGearAttributes.EnergyRecovery += nextGear.GearAttributes.EnergyRecovery
            TotalGearAttributes.Fighting += nextGear.GearAttributes.Fighting
            TotalGearAttributes.Sharpshooting += nextGear.GearAttributes.Sharpshooting
            TotalGearAttributes.CombatMagic += nextGear.GearAttributes.CombatMagic
            TotalGearAttributes.Attack += nextGear.GearAttributes.Attack
            TotalGearAttributes.Damage += nextGear.GearAttributes.Damage
            TotalGearAttributes.MeleeDefense += nextGear.GearAttributes.MeleeDefense
            TotalGearAttributes.RangeDefense += nextGear.GearAttributes.RangeDefense
            TotalGearAttributes.Toughness += nextGear.GearAttributes.Toughness
            TotalGearAttributes.Willpower += nextGear.GearAttributes.Willpower
            TotalGearAttributes.StrengthTypes.append(contentsOf: nextGear.GearAttributes.StrengthTypes)
            TotalGearAttributes.WeaknessTypes.append(contentsOf: nextGear.GearAttributes.WeaknessTypes)
        }
        return TotalGearAttributes
    }
    
    func updateGearBooleans() {
        for i in 0..<AllGear.count {
            switch AllGear[i].GearType {
            case .Helm: hasHelm = true
            case .Chest: hasChest = true
            case .Shoulder: hasShoulder = true
            case .Leggings: hasLeggings = true
            case .Boots: hasBoots = true
            case .Belt: hasBelt = true
            case .Back: hasBack = true
            default: hasNone = true
            }
        }
        hasNone = AllGear.count == 0
    }
}
