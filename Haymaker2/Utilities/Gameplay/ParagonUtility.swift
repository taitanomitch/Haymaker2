//
//  Paragon.swift
//  Haymaker2
//
//  Created by Mitchell Taitano on 8/10/22.
//

import Foundation

class Paragon: NSObject {
    
    var Battlecry: String = ""
    var Race: ParagonRace = .None
    
    var ParagonCardHand: [ParagonCard] = []
    var ParagonStatusManager: StatusManager
    
    var ParagonBaseAttributes: AttributesManager //Atributes from Paragon alone
    var ParagonWeaponAttributes: AttributesManager //Attributes Given By Weapons
    var ParagonGearAttributes: AttributesManager //Attributes Given By Gear
    var ParagonTotalAttributes: AttributesManager //Attributes from Base + Gear + Weapons
    
    var ParagonCombatAttributes: AttributesManager //Total Attributes Used For Combat (Damage dealt to the Paragon will be applied here)
    var ParagonTemporaryAttributes: AttributesManager //Attributes gained during combat
    var ParagonTemporaryAttributesWithBuffsDebuffs: AttributesManager //Attributes gained during combat + Buff and Debuff Attributes
    
    var ParagonBuffs: [Buff] = []
    var ParagonBuffAttributes: AttributesManager //Attributes from all Buffs
    var ParagonDebuffs: [Buff] = []
    var ParagonDebuffAttributes: AttributesManager //Attributes from all Debuffs
    
    var ParagonAttackSetFromBase: AttackSet
    var ParagonAttackSetFromWeapon: AttackSet
    var ParagonAttackSetFromClass: AttackSet
    var ParagonAttackSet: AttackSet
    var ParagonAttacksPerTurn: Int = 0
    
    var ParagonWeapons: WeaponSet = WeaponSet()
    var ParagonGear: GearSet = GearSet()
    var ParagonItems: ItemSet = ItemSet()
    
    var XP: Int = 0
    var XPReward: Int = 0
    var Currency: Int = 0
    var CurrencyReward: Int = 0
    
    init(Name: String) {
        ParagonBaseAttributes = AttributesManager(Name: Name)
        ParagonWeaponAttributes = AttributesManager()
        ParagonGearAttributes = AttributesManager()
        ParagonTotalAttributes = AttributesManager()
        ParagonCombatAttributes = AttributesManager()
        ParagonTemporaryAttributes = AttributesManager()
        ParagonTemporaryAttributesWithBuffsDebuffs = AttributesManager()
        ParagonBuffAttributes = AttributesManager()
        ParagonDebuffAttributes = AttributesManager()
        ParagonStatusManager = StatusManager()
        ParagonAttackSet = AttackSet()
        ParagonAttackSetFromBase = AttackSet()
        ParagonAttackSetFromWeapon = AttackSet()
        ParagonAttackSetFromClass = AttackSet()
        ParagonAttacksPerTurn = 1
    }
    
    
    //MARK: - Get Functions
    func getAttackValueForAttack(AttackUsed: Int) -> Int {
        return ParagonAttackSet.getAttackValueForAttack(Attack: AttackUsed) + ParagonCombatAttributes.Attack + ParagonTemporaryAttributes.Attack
    }
    
    func getTotalBaseDamageForAttack(AttackUsed: Int) -> Int {
        return ParagonAttackSet.getAttackValueForAttack(Attack: AttackUsed) + ParagonCombatAttributes.Damage + ParagonTemporaryAttributes.Damage
    }
    
    func getMeleeDefense() -> Int {
        return ParagonCombatAttributes.MeleeDefense + ParagonTemporaryAttributes.MeleeDefense
    }
    
    func getRangeDefense() -> Int {
        return ParagonCombatAttributes.RangeDefense + ParagonTemporaryAttributes.RangeDefense
    }
    
    func getMentalDefense() -> Int {
        return ParagonCombatAttributes.Willpower + ParagonTemporaryAttributes.Willpower
    }
    
    func getDamageResistance() -> Int {
        return ParagonCombatAttributes.Toughness + ParagonTemporaryAttributes.Toughness
    }
    
    
    //MARK: - Start & End Combat Functions
    func functionsForStartOfCombat() {
        prepareCombatAttributes()
    }
    
    func functionsForEndOfCombat() {
        
    }
    
    func prepareCombatAttributes() {
        ParagonCombatAttributes = ParagonTotalAttributes
        ParagonTemporaryAttributes = AttributesManager()
        ParagonStatusManager = StatusManager()
    }
    
    func prepareBuffsAndDebuffs() {
        ParagonBuffs = []
        ParagonDebuffs = []
    }
    
    
    //MARK: - Start & End Turn Functions
    func functionsForStartOfTurn() {
        resetAttackBonuses()
        resetDefenseBonuses()
        self.ParagonStatusManager.decrementStatusCounters(SelfInflicted: true)
        self.ParagonTemporaryAttributes.decrementStrengthWeaknessTurns()
        for i in 0..<ParagonBuffs.count {
            ParagonBuffs[i].BuffAttributes.decrementStrengthWeaknessTurns()
        }
        for i in 0..<ParagonDebuffs.count {
            ParagonDebuffs[i].BuffAttributes.decrementStrengthWeaknessTurns()
        }
    }
    
    func functionsForEndOfTurn() {
        self.ParagonStatusManager.ReceivedDamageSinceLastTurn = false
        self.ParagonStatusManager.decrementStatusCounters(SelfInflicted: false)
    }
    
    
    //MARK: - Reset Functions
    func resetAttackBonuses() {
        self.ParagonTemporaryAttributes.Attack = 0
        self.ParagonTemporaryAttributes.Damage = 0
    }
    
    func resetDefenseBonuses() {
        self.ParagonTemporaryAttributes.MeleeDefense = 0
        self.ParagonTemporaryAttributes.RangeDefense = 0
        self.ParagonTemporaryAttributes.Toughness = 0
        self.ParagonTemporaryAttributes.Willpower = 0
        self.ParagonStatusManager.ImmuneToMeleeAttacksTemporary = false
        self.ParagonStatusManager.ImmuneToRangedAttacksTemporary = false
        self.ParagonStatusManager.ImmuneToMentalAttacksTemporary = false
    }
    
    
    //MARK: - Calculate Attribute Functions
    func calculateWeaponAttributes() {
        ParagonWeaponAttributes = ParagonWeapons.getTotalWeaponAttributes()
    }
    
    func calculateGearAttributes() {
        ParagonGearAttributes = ParagonGear.getTotalGearAttributes()
    }
    
    func calculateTotalAttributes() {
        ParagonTotalAttributes =  combineAttributeManagers(AttributeManagersArray: [ParagonBaseAttributes, ParagonGearAttributes, ParagonWeaponAttributes])
    }
    
    func calculateTemporaryAttributesWithBuffsDebuffs() {
        calculateBuffDebuffAttributes()
        ParagonTemporaryAttributesWithBuffsDebuffs = combineAttributeManagers(AttributeManagersArray: [ParagonTemporaryAttributes, ParagonBuffAttributes])
        ParagonTemporaryAttributesWithBuffsDebuffs = combineAttributeManagerWithDebuffs(Attributes: ParagonTemporaryAttributesWithBuffsDebuffs, DebuffAttributes: ParagonDebuffAttributes)
    }
    
    func calculateBuffDebuffAttributes() {
        combineBuffAttributes(Buffs: ParagonBuffs)
        combineDebuffAttributes(Buffs: ParagonDebuffs)
    }
    
    
    //MARK: - Combining Attack Functions
    func combineAllAttacksIntoAttackSet() {
        ParagonAttackSet = AttackSet()
        ParagonAttackSet.addAttacksToAttackSet(ParagonAttacks: ParagonAttackSetFromBase.Attacks, ForParagon: self)
        ParagonAttackSet.addAttacksToAttackSet(ParagonAttacks: ParagonAttackSetFromWeapon.Attacks, ForParagon: self)
        ParagonAttackSet.addAttacksToAttackSet(ParagonAttacks: ParagonAttackSetFromClass.Attacks, ForParagon: self)
    }
    
    
    //MARK: - Combining Attribute Functions
    func combineBuffAttributes(Buffs: [Buff]) {
        var allBuffAttributesArray: [AttributesManager] = []
        for i in 0..<Buffs.count {
            let nextAttribute = Buffs[i].BuffAttributes
            allBuffAttributesArray.append(nextAttribute)
        }
        ParagonBuffAttributes = combineAttributeManagers(AttributeManagersArray: allBuffAttributesArray)
    }
    
    func combineDebuffAttributes(Buffs: [Buff]) {
        var allBuffAttributesArray: [AttributesManager] = []
        for i in 0..<Buffs.count {
            let nextAttribute = Buffs[i].BuffAttributes
            allBuffAttributesArray.append(nextAttribute)
        }
        ParagonDebuffAttributes = combineAttributeManagers(AttributeManagersArray: allBuffAttributesArray)
    }
    
    func combineAttributeManagerWithDebuffs(Attributes: AttributesManager, DebuffAttributes: AttributesManager) -> AttributesManager {
        let newAttributeManager: AttributesManager = AttributesManager()
        newAttributeManager.Health = Attributes.Health
        newAttributeManager.Energy = Attributes.Energy
        newAttributeManager.Speed = Attributes.Speed
        newAttributeManager.Initiative = Attributes.Initiative
        newAttributeManager.HealthRecovery = Attributes.HealthRecovery
        newAttributeManager.EnergyRecovery = Attributes.EnergyRecovery
        newAttributeManager.Fighting = Attributes.Fighting
        newAttributeManager.Sharpshooting = Attributes.Sharpshooting
        newAttributeManager.CombatMagic = Attributes.CombatMagic
        newAttributeManager.Attack = Attributes.Attack
        newAttributeManager.Damage = Attributes.Damage
        newAttributeManager.MeleeDefense = Attributes.MeleeDefense
        newAttributeManager.RangeDefense = Attributes.RangeDefense
        newAttributeManager.Toughness = Attributes.Toughness
        newAttributeManager.Willpower = Attributes.Willpower
        newAttributeManager.ImmuneTypes = Attributes.ImmuneTypes
        newAttributeManager.ImmuneTypesTurns = Attributes.ImmuneTypesTurns
        newAttributeManager.StrengthTypes = Attributes.StrengthTypes
        newAttributeManager.StrengthTypesTurns = Attributes.StrengthTypesTurns
        newAttributeManager.WeaknessTypes = Attributes.WeaknessTypes
        newAttributeManager.WeaknessTypesTurns = Attributes.WeaknessTypesTurns
        newAttributeManager.MeleeImmune = Attributes.MeleeImmune
        newAttributeManager.MeleeImmuneTurns = Attributes.MeleeImmuneTurns
        newAttributeManager.RangeImmune = Attributes.RangeImmune
        newAttributeManager.RangeImmuneTurns = Attributes.RangeImmuneTurns
        
        newAttributeManager.Health -= DebuffAttributes.Health
        newAttributeManager.Energy -= DebuffAttributes.Energy
        newAttributeManager.Speed -= DebuffAttributes.Speed
        newAttributeManager.Initiative -= DebuffAttributes.Initiative
        newAttributeManager.HealthRecovery -= DebuffAttributes.HealthRecovery
        newAttributeManager.EnergyRecovery -= DebuffAttributes.EnergyRecovery
        newAttributeManager.Fighting -= DebuffAttributes.Fighting
        newAttributeManager.Sharpshooting -= DebuffAttributes.Sharpshooting
        newAttributeManager.CombatMagic -= DebuffAttributes.CombatMagic
        newAttributeManager.Attack -= DebuffAttributes.Attack
        newAttributeManager.Damage -= DebuffAttributes.Damage
        newAttributeManager.MeleeDefense -= DebuffAttributes.MeleeDefense
        newAttributeManager.RangeDefense -= DebuffAttributes.RangeDefense
        newAttributeManager.Toughness -= DebuffAttributes.Toughness
        newAttributeManager.Willpower -= DebuffAttributes.Willpower
        
        for i in 0..<DebuffAttributes.ImmuneTypes.count {
            if newAttributeManager.ImmuneTypes.contains(DebuffAttributes.ImmuneTypes[i]) {
                for j in 0..<newAttributeManager.ImmuneTypes.count {
                    if newAttributeManager.ImmuneTypes[j] == DebuffAttributes.ImmuneTypes[i] {
                        newAttributeManager.ImmuneTypesTurns[j] -= DebuffAttributes.ImmuneTypesTurns[i]
                    }
                }
            }
        }
        
        for i in (newAttributeManager.ImmuneTypes.count-1)...0 {
            if newAttributeManager.ImmuneTypesTurns[i] <= 0 {
                newAttributeManager.ImmuneTypes.remove(at: i)
                newAttributeManager.ImmuneTypesTurns.remove(at: i)
            }
        }
        
        for i in 0..<DebuffAttributes.StrengthTypes.count {
            if !newAttributeManager.StrengthTypes.contains(DebuffAttributes.StrengthTypes[i]) {
                if DebuffAttributes.WeaknessTypes.contains(DebuffAttributes.StrengthTypes[i]) {
                    for j in 0..<DebuffAttributes.WeaknessTypes.count {
                        if DebuffAttributes.WeaknessTypes[j] == DebuffAttributes.StrengthTypes[i] {
                            DebuffAttributes.WeaknessTypesTurns[j] += DebuffAttributes.StrengthTypesTurns[i]
                        }
                    }
                } else {
                    DebuffAttributes.WeaknessTypes.append(DebuffAttributes.StrengthTypes[i])
                    DebuffAttributes.WeaknessTypesTurns.append(DebuffAttributes.StrengthTypesTurns[i])
                }
            } else {
                for j in 0..<newAttributeManager.StrengthTypes.count {
                    if newAttributeManager.StrengthTypes[j] == DebuffAttributes.StrengthTypes[i] {
                        newAttributeManager.StrengthTypesTurns[j] -= DebuffAttributes.StrengthTypesTurns[i]
                        if newAttributeManager.StrengthTypesTurns[j] < 0 {
                            let WeaknessTurnsToAdd = newAttributeManager.StrengthTypesTurns[j]
                            if DebuffAttributes.WeaknessTypes.contains(DebuffAttributes.StrengthTypes[i]) {
                                for j in 0..<DebuffAttributes.WeaknessTypes.count {
                                    if DebuffAttributes.WeaknessTypes[j] == DebuffAttributes.StrengthTypes[i] {
                                        DebuffAttributes.WeaknessTypesTurns[j] += WeaknessTurnsToAdd
                                    }
                                }
                            } else {
                                DebuffAttributes.WeaknessTypes.append(DebuffAttributes.StrengthTypes[i])
                                DebuffAttributes.WeaknessTypesTurns.append(WeaknessTurnsToAdd)
                            }
                        }
                    }
                }
            }
        }
        
        for i in (newAttributeManager.StrengthTypes.count-1)...0 {
            if newAttributeManager.StrengthTypesTurns[i] <= 0 {
                newAttributeManager.StrengthTypes.remove(at: i)
                newAttributeManager.StrengthTypesTurns.remove(at: i)
            }
        }

        for i in 0..<DebuffAttributes.WeaknessTypes.count {
            if !newAttributeManager.WeaknessTypes.contains(DebuffAttributes.WeaknessTypes[i]) {
                newAttributeManager.WeaknessTypes.append(DebuffAttributes.WeaknessTypes[i])
                newAttributeManager.WeaknessTypesTurns.append(DebuffAttributes.WeaknessTypesTurns[i])
            } else {
                for j in 0..<newAttributeManager.WeaknessTypes.count {
                    if newAttributeManager.WeaknessTypes[j] == DebuffAttributes.StrengthTypes[i] {
                        newAttributeManager.WeaknessTypesTurns[j] += DebuffAttributes.WeaknessTypesTurns[i]
                    }
                }
            }
        }
        
        for i in (newAttributeManager.WeaknessTypes.count-1)...0 {
            if newAttributeManager.WeaknessTypesTurns[i] <= 0 {
                newAttributeManager.WeaknessTypes.remove(at: i)
                newAttributeManager.WeaknessTypesTurns.remove(at: i)
            }
        }
        
        newAttributeManager.MeleeImmuneTurns -= DebuffAttributes.MeleeImmuneTurns
        newAttributeManager.RangeImmuneTurns -= DebuffAttributes.RangeImmuneTurns
        
        if newAttributeManager.MeleeImmuneTurns <= 0 {
            newAttributeManager.MeleeImmune = false
            newAttributeManager.MeleeImmuneTurns = 0
        } else {
            newAttributeManager.MeleeImmune = true
        }
        
        if newAttributeManager.RangeImmuneTurns <= 0 {
            newAttributeManager.RangeImmune = false
            newAttributeManager.RangeImmuneTurns = 0
        } else {
            newAttributeManager.RangeImmune = true
        }

        return newAttributeManager
    }
    
    func combineAttributeManagers(AttributeManagersArray: [AttributesManager]) -> AttributesManager {
        let newAttributeManager: AttributesManager = AttributesManager()
        for i in 0..<AttributeManagersArray.count {
            newAttributeManager.Health += AttributeManagersArray[i].Health
            newAttributeManager.Energy += AttributeManagersArray[i].Energy
            newAttributeManager.Speed += AttributeManagersArray[i].Speed
            newAttributeManager.Initiative += AttributeManagersArray[i].Initiative
            newAttributeManager.HealthRecovery += AttributeManagersArray[i].HealthRecovery
            newAttributeManager.EnergyRecovery += AttributeManagersArray[i].EnergyRecovery
            newAttributeManager.Fighting += AttributeManagersArray[i].Fighting
            newAttributeManager.Sharpshooting += AttributeManagersArray[i].Sharpshooting
            newAttributeManager.CombatMagic += AttributeManagersArray[i].CombatMagic
            newAttributeManager.Attack += AttributeManagersArray[i].Attack
            newAttributeManager.Damage += AttributeManagersArray[i].Damage
            newAttributeManager.MeleeDefense += AttributeManagersArray[i].MeleeDefense
            newAttributeManager.RangeDefense += AttributeManagersArray[i].RangeDefense
            newAttributeManager.Toughness += AttributeManagersArray[i].Toughness
            newAttributeManager.Willpower += AttributeManagersArray[i].Willpower
            
            for i in 0..<AttributeManagersArray[i].ImmuneTypes.count {
                if !newAttributeManager.ImmuneTypes.contains(AttributeManagersArray[i].ImmuneTypes[i]) {
                    newAttributeManager.ImmuneTypes.append(AttributeManagersArray[i].ImmuneTypes[i])
                    newAttributeManager.ImmuneTypesTurns.append(AttributeManagersArray[i].ImmuneTypesTurns[i])
                } else {
                    for j in 0..<newAttributeManager.ImmuneTypes.count {
                        if newAttributeManager.ImmuneTypes[j] == AttributeManagersArray[i].ImmuneTypes[i] {
                            newAttributeManager.ImmuneTypesTurns[j] += AttributeManagersArray[i].ImmuneTypesTurns[i]
                        }
                    }
                }
            }
            
            for i in (newAttributeManager.ImmuneTypes.count-1)...0 {
                if newAttributeManager.ImmuneTypesTurns[i] <= 0 {
                    newAttributeManager.ImmuneTypes.remove(at: i)
                    newAttributeManager.ImmuneTypesTurns.remove(at: i)
                }
            }
            
            for i in 0..<AttributeManagersArray[i].StrengthTypes.count {
                if !newAttributeManager.StrengthTypes.contains(AttributeManagersArray[i].StrengthTypes[i]) {
                    newAttributeManager.StrengthTypes.append(AttributeManagersArray[i].StrengthTypes[i])
                    newAttributeManager.StrengthTypesTurns.append(AttributeManagersArray[i].StrengthTypesTurns[i])
                } else {
                    for j in 0..<newAttributeManager.StrengthTypes.count {
                        if newAttributeManager.StrengthTypes[j] == AttributeManagersArray[i].StrengthTypes[i] {
                            newAttributeManager.StrengthTypesTurns[j] += AttributeManagersArray[i].StrengthTypesTurns[i]
                        }
                    }
                }
            }
            
            for i in (newAttributeManager.StrengthTypes.count-1)...0 {
                if newAttributeManager.StrengthTypesTurns[i] <= 0 {
                    newAttributeManager.StrengthTypes.remove(at: i)
                    newAttributeManager.StrengthTypesTurns.remove(at: i)
                }
            }

            for i in 0..<AttributeManagersArray[i].WeaknessTypes.count {
                if !newAttributeManager.WeaknessTypes.contains(AttributeManagersArray[i].WeaknessTypes[i]) {
                    newAttributeManager.WeaknessTypes.append(AttributeManagersArray[i].WeaknessTypes[i])
                    newAttributeManager.WeaknessTypesTurns.append(AttributeManagersArray[i].WeaknessTypesTurns[i])
                } else {
                    for j in 0..<newAttributeManager.WeaknessTypes.count {
                        if newAttributeManager.WeaknessTypes[j] == AttributeManagersArray[i].StrengthTypes[i] {
                            newAttributeManager.WeaknessTypesTurns[j] += AttributeManagersArray[i].WeaknessTypesTurns[i]
                        }
                    }
                }
            }
            
            for i in (newAttributeManager.WeaknessTypes.count-1)...0 {
                if newAttributeManager.WeaknessTypesTurns[i] <= 0 {
                    newAttributeManager.WeaknessTypes.remove(at: i)
                    newAttributeManager.WeaknessTypesTurns.remove(at: i)
                }
            }
            
            newAttributeManager.MeleeImmune = newAttributeManager.MeleeImmune || AttributeManagersArray[i].MeleeImmune
            newAttributeManager.RangeImmune = newAttributeManager.RangeImmune || AttributeManagersArray[i].RangeImmune
        }
        return newAttributeManager
    }
    
    
    //MARK: - Weapon Functions
    
    
    //MARK: - Gear Functions
    func addGear(Gear: Gear) -> Gear {
        return ParagonGear.addGearToSet(GearToAdd: Gear)
    }
    
    
    //MARK: - Set Functions
    func setParagonStatus(Status: ParagonStatus, ForNumberOfTurns: Int, SelfInflicted: Bool) {
        self.ParagonStatusManager.setStatus(Status: Status, NumberOfTurns: ForNumberOfTurns, SelfInflicted: SelfInflicted)
    }
    
    func setEnergy(Value: Int) {
        self.ParagonTemporaryAttributes.Energy = 0
        self.ParagonCombatAttributes.Energy = 0
    }
    
    func setAttackBonus(Value: Int) {
        self.ParagonTemporaryAttributes.Attack = Value
    }
    
    func setAttackDamageBonus(Value: Int) {
        self.ParagonTemporaryAttributes.Damage = Value
    }
    
    func setMeleeDefenseBonus(Value: Int) {
        self.ParagonTemporaryAttributes.MeleeDefense = Value
    }
    
    func setRangeDefenseBonus(Value: Int) {
        self.ParagonTemporaryAttributes.RangeDefense = Value
    }
    
    func setDamageResistanceValueBonus(Value: Int) {
        self.ParagonTemporaryAttributes.Toughness = Value
    }
    
    
    //MARK: - Modify Functions
    func modifyAttackBonus(Value: Int) {
        self.ParagonTemporaryAttributes.Attack += Value
    }
    
    func modifyAttackDamageBonus(Value: Int) {
        self.ParagonTemporaryAttributes.Damage += Value
    }
    
    func modifyMeleeDefenseBonus(Value: Int) {
        self.ParagonTemporaryAttributes.MeleeDefense += Value
    }
    
    func modifyRangeDefenseBonus(Value: Int) {
        self.ParagonTemporaryAttributes.RangeDefense += Value
    }
    
    func modifyDamageResistanceValueBonus(Value: Int) {
        self.ParagonTemporaryAttributes.Toughness += Value
    }
}
