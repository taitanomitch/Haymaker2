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
    var ParagonTemporaryAttributes: AttributesManager //Attributes from all Buffs and Debuffs gained during combat
    
    var ParagonBuffs: [Buff] = []
    var ParagonBuffAttributes: AttributesManager //Attributes from all Buffs
    var ParagonDebuffs: [Buff] = []
    var ParagonDebuffAttributes: AttributesManager //Attributes from all Debuffs
    
    var ParagonAttackSetFromBase: AttackSet
    var ParagonAttackSetFromWeapon: AttackSet
    var ParagonAttackSetFromClass: AttackSet
    var ParagonAttackSet: AttackSet
    
    var ParagonWeapons: WeaponSet = WeaponSet()
    var ParagonGear: GearSet = GearSet()
    var ParagonItems: ItemSet = ItemSet()
    
    var MaxHealth: Int = 0
    var MaxEnergy: Int = 0
    var XP: Int = 0
    var XPReward: Int = 0
    var Currency: Int = 0
    var CurrencyReward: Int = 0
    
    
    //MARK: - Paragon Initializer
    init(Name: String) {
        ParagonBaseAttributes = AttributesManager(Name: Name)
        ParagonWeaponAttributes = AttributesManager()
        ParagonGearAttributes = AttributesManager()
        ParagonTotalAttributes = AttributesManager()
        ParagonCombatAttributes = AttributesManager()
        ParagonTemporaryAttributes = AttributesManager()
        ParagonBuffAttributes = AttributesManager()
        ParagonDebuffAttributes = AttributesManager()
        ParagonStatusManager = StatusManager()
        ParagonAttackSet = AttackSet()
        ParagonAttackSetFromBase = AttackSet()
        ParagonAttackSetFromWeapon = AttackSet()
        ParagonAttackSetFromClass = AttackSet()
    }

    var Fighting: Int = 0
    var Sharpshooting: Int = 0
    var CombatMagic: Int = 0
    
    //MARK: - Get & Add Functions
    func getAttackValueForAttack(AttackUsed: Int) -> Int {
        return ParagonAttackSet.getAttackValueForAttack(Attack: AttackUsed) + ParagonCombatAttributes.Attack + ParagonTemporaryAttributes.Attack
    }
    
    func getTotalBaseDamageForAttack(AttackUsed: Int) -> Int {
        return ParagonAttackSet.getAttackValueForAttack(Attack: AttackUsed) + ParagonCombatAttributes.Damage + ParagonTemporaryAttributes.Damage
    }
    
    func getHealth() -> Int {
        return ParagonCombatAttributes.Health + ParagonTemporaryAttributes.Health
    }
    
    func addHealth(Amount: Int) {
        if !self.ParagonStatusManager.StatusList.contains(.Unconscious) {
            if getHealth() < MaxHealth {
                ParagonCombatAttributes.Health += Amount
                if ParagonCombatAttributes.Health > ParagonTotalAttributes.Health {
                    ParagonCombatAttributes.Health = ParagonTotalAttributes.Health
                }
            }
        }
    }
    
    func getEnergy() -> Int {
        return ParagonCombatAttributes.Energy + ParagonTemporaryAttributes.Energy
    }
    
    func addEnergy(Amount: Int) {
        if !self.ParagonStatusManager.StatusList.contains(.Unconscious) {
            if getEnergy() < MaxEnergy {
                ParagonCombatAttributes.Energy += Amount
                if ParagonCombatAttributes.Energy > ParagonTotalAttributes.Energy {
                    ParagonCombatAttributes.Energy = ParagonTotalAttributes.Energy
                }
            }
        }
    }
    
    func getSpeed() -> Int {
        return ParagonCombatAttributes.Speed + ParagonTemporaryAttributes.Speed
    }
    
    func getHealthRecovery() -> Int {
        return ParagonCombatAttributes.HealthRecovery + ParagonTemporaryAttributes.HealthRecovery
    }
    
    func getEnergyRecovery() -> Int {
        return ParagonCombatAttributes.EnergyRecovery + ParagonTemporaryAttributes.EnergyRecovery
    }
    
    func getFighting() -> Int {
        return ParagonCombatAttributes.Fighting + ParagonTemporaryAttributes.Fighting
    }
    
    func getSharpshooting() -> Int {
        return ParagonCombatAttributes.Sharpshooting + ParagonTemporaryAttributes.Sharpshooting
    }
    
    func getCombatMagic() -> Int {
        return ParagonCombatAttributes.CombatMagic + ParagonTemporaryAttributes.CombatMagic
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
    
    func getMentalDamageResistance() -> Int {
        return ParagonCombatAttributes.Willpower + ParagonTemporaryAttributes.Willpower
    }
    
    
    //MARK: - Start & End Combat Functions
    func functionsForStartOfCombat() {
        calculateWeaponAttributes()
        calculateGearAttributes()
        calculateTotalAttributes()
        prepareCombatAttributes()
        combineAllAttacksIntoAttackSet()
        calculateAttackValueForAttackSet()
    }
    
    func functionsForEndOfCombat() {
        calculateTotalAttributes()
        prepareCombatAttributes()
        calculateAttackValueForAttackSet()
    }
    
    func prepareCombatAttributes() {
        ParagonCombatAttributes = ParagonTotalAttributes
        ParagonTemporaryAttributes = AttributesManager()
        ParagonStatusManager = StatusManager()
        prepareBuffsAndDebuffs()
    }
    
    func prepareBuffsAndDebuffs() {
        ParagonBuffs = []
        ParagonDebuffs = []
    }
    
    
    //MARK: - Start & End Turn Functions
    func functionsForStartOfTurn() {
        self.ParagonStatusManager.decrementStatusCounters(SelfInflicted: true)
        
    }
    
    func functionsForEndOfTurn() {
        self.ParagonStatusManager.ReceivedDamageSinceLastTurn = false
        self.ParagonStatusManager.decrementStatusCounters(SelfInflicted: false)
        DecrementTurnCounters()
    }
    
    
    //MARK: - Attack Functions
    func combineAllAttacksIntoAttackSet() {
        ParagonAttackSet = AttackSet()
        ParagonAttackSet.addAttacksToAttackSet(ParagonAttacks: ParagonAttackSetFromBase.Attacks, ForParagon: self)
        ParagonAttackSet.addAttacksToAttackSet(ParagonAttacks: ParagonAttackSetFromWeapon.Attacks, ForParagon: self)
        ParagonAttackSet.addAttacksToAttackSet(ParagonAttacks: ParagonAttackSetFromClass.Attacks, ForParagon: self)
    }
    
    func calculateAttackValueForAttackSet() {
        for i in 0..<ParagonAttackSet.Attacks.count {
            ParagonAttackSet.Attacks[i].completeAttackValuesForParagon(Paragon: self)
        }
        for i in 0..<ParagonAttackSetFromBase.Attacks.count {
            ParagonAttackSetFromBase.Attacks[i].completeAttackValuesForParagon(Paragon: self)
        }
        for i in 0..<ParagonAttackSetFromWeapon.Attacks.count {
            ParagonAttackSetFromWeapon.Attacks[i].completeAttackValuesForParagon(Paragon: self)
        }
        for i in 0..<ParagonAttackSetFromClass.Attacks.count {
            ParagonAttackSetFromClass.Attacks[i].completeAttackValuesForParagon(Paragon: self)
        }
    }
    

    //MARK: - Weapon Functions
    func addWeapon(WeaponToAdd: Weapon, ToWeaponHand: WeaponHand) -> Weapon {
        return ParagonWeapons.addWeaponToSet(WeaponToAdd: WeaponToAdd, ToHand: ToWeaponHand)
    }
    
    
    //MARK: - Gear Functions
    func addGear(Gear: Gear) -> Gear {
        return ParagonGear.addGearToSet(GearToAdd: Gear)
    }
    
    
    //MARK: - Buff Debuff Functions
    func addBuffToBuffs(BuffToAdd: Buff) {
        ParagonBuffs.append(BuffToAdd)
        calculateBuffAttributes()
        recalculateTemporaryAttributes_SkipBuffDebuffCalculation()
    }
    
    func addDebuffToDebuffs(DebuffToAdd: Buff) {
        ParagonDebuffs.append(DebuffToAdd)
        calculateDebuffAttributes()
        recalculateTemporaryAttributes_SkipBuffDebuffCalculation()
    }
    
    func DecrementTurnCounters() {
        self.ParagonTemporaryAttributes.decrementResistanceAndWeaknessTurns()
        for i in 0..<ParagonBuffs.count {
            ParagonBuffs[i].BuffAttributes.decrementResistanceAndWeaknessTurns()
            ParagonBuffs[i].decrementBuffTurns()
        }
        for i in 0..<ParagonDebuffs.count {
            ParagonDebuffs[i].BuffAttributes.decrementResistanceAndWeaknessTurns()
            ParagonDebuffs[i].decrementBuffTurns()
        }
        clearOldBuffsDebuffs()
        calculateTemporaryAttributesWithBuffsDebuffs()
    }
    
    func clearOldBuffsDebuffs() {
        for i in ParagonBuffs.count...0 {
            if ParagonBuffs[i].BuffTurns <= 0 {
                ParagonBuffs.remove(at: i)
            }
        }
        for i in ParagonDebuffs.count...0 {
            if ParagonDebuffs[i].BuffTurns <= 0 {
                ParagonBuffs.remove(at: i)
            }
        }
    }
    
    
    //MARK: - Status Functions
    func setParagonStatus(Status: ParagonStatus, ForNumberOfTurns: Int, SelfInflicted: Bool) {
        self.ParagonStatusManager.setStatus(Status: Status, NumberOfTurns: ForNumberOfTurns, SelfInflicted: SelfInflicted)
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
        ParagonTemporaryAttributes = AttributesManager()
        calculateBuffDebuffAttributes()
        ParagonTemporaryAttributes = combineAttributeManagers(AttributeManagersArray: [ParagonTemporaryAttributes, ParagonBuffAttributes])
        ParagonTemporaryAttributes = combineAttributeManagerWithDebuffs(Attributes: ParagonTemporaryAttributes, DebuffAttributes: ParagonDebuffAttributes)
        calculateMaxHealthAndMaxEnergyForParagon()
        calculateAttackValueForAttackSet()
    }
    
    func recalculateTemporaryAttributes_SkipBuffDebuffCalculation() {
        ParagonTemporaryAttributes = AttributesManager()
        ParagonTemporaryAttributes = combineAttributeManagers(AttributeManagersArray: [ParagonTemporaryAttributes, ParagonBuffAttributes])
        ParagonTemporaryAttributes = combineAttributeManagerWithDebuffs(Attributes: ParagonTemporaryAttributes, DebuffAttributes: ParagonDebuffAttributes)
        calculateMaxHealthAndMaxEnergyForParagon()
        calculateAttackValueForAttackSet()
    }
    
    func calculateBuffDebuffAttributes() {
        combineBuffAttributes(Buffs: ParagonBuffs)
        combineDebuffAttributes(Buffs: ParagonDebuffs)
    }
    
    func calculateBuffAttributes() {
        combineBuffAttributes(Buffs: ParagonBuffs)
    }
    
    func calculateDebuffAttributes() {
        combineDebuffAttributes(Buffs: ParagonDebuffs)
    }
    
    func calculateMaxHealthAndMaxEnergyForParagon() {
        MaxHealth = ParagonTotalAttributes.Health + ParagonTemporaryAttributes.Health
        MaxEnergy = ParagonTotalAttributes.Energy + ParagonTemporaryAttributes.Energy
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
            
            for j in 0..<AttributeManagersArray[i].ResistanceAndWeaknessTypes.count {
                newAttributeManager.ResistanceAndWeaknessTypesTurns[j] = newAttributeManager.ResistanceAndWeaknessTypesTurns[j] + AttributeManagersArray[i].ResistanceAndWeaknessTypesTurns[j]
                
                newAttributeManager.ImmuneTypesTurns[j] = newAttributeManager.ImmuneTypesTurns[j] + AttributeManagersArray[i].ImmuneTypesTurns[j]
            }
            
            newAttributeManager.MeleeImmuneTurns = newAttributeManager.MeleeImmuneTurns + AttributeManagersArray[i].MeleeImmuneTurns
            newAttributeManager.RangeImmuneTurns = newAttributeManager.RangeImmuneTurns + AttributeManagersArray[i].RangeImmuneTurns
            newAttributeManager.MeleeImmune = newAttributeManager.MeleeImmuneTurns > 0
            newAttributeManager.RangeImmune = newAttributeManager.RangeImmuneTurns > 0
        }
        return newAttributeManager
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
        newAttributeManager.ResistanceAndWeaknessTypes = Attributes.ResistanceAndWeaknessTypes
        newAttributeManager.ResistanceAndWeaknessTypesTurns = Attributes.ResistanceAndWeaknessTypesTurns
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
        
        for j in 0..<newAttributeManager.ResistanceAndWeaknessTypes.count {
            newAttributeManager.ResistanceAndWeaknessTypesTurns[j] = newAttributeManager.ResistanceAndWeaknessTypesTurns[j] - DebuffAttributes.ResistanceAndWeaknessTypesTurns[j]
            
            newAttributeManager.ImmuneTypesTurns[j] = newAttributeManager.ImmuneTypesTurns[j] - DebuffAttributes.ImmuneTypesTurns[j]
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
}
