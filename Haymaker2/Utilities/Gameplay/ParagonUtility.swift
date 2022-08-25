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
    var ParagonWeaponAttributes: AttributesManager //Attributes Given By Gear
    var ParagonGearAttributes: AttributesManager //Attributes Given By Gear
    var ParagonTotalAttributes: AttributesManager //Attributes from Base + Gear
    var ParagonCombatAttributes: AttributesManager //Total Attributes Used For Combat
    var ParagonTemporaryAttributes: AttributesManager //Attributes gained during combat
    
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
    
    
    //MARK: - Start & End Turn Functions
    func functionsForStartOfTurn() {
        resetAttackBonuses()
        resetDefenseBonuses()
        self.ParagonStatusManager.decrementStatusCounters(SelfInflicted: true)
        self.ParagonTemporaryAttributes.decrementStrengthWeaknessTurns()
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
    
    
    //MARK: - Set Functions
    func addGear(Gear: Gear) -> Gear {
        return ParagonGear.addGearToSet(GearToAdd: Gear)
    }
    
    
    func calculateWeaponAttributes() {
        ParagonWeaponAttributes = ParagonWeapons.getTotalWeaponAttributes()
    }
    
    func calculateGearAttributes() {
        ParagonGearAttributes = ParagonGear.getTotalGearAttributes()
    }
    
    func calculateTotalAttributes() {
        ParagonTotalAttributes = ParagonBaseAttributes.combineWithAttributeManager(AttributesToAdd: ParagonGearAttributes)
    }
    
    func setAttackBonus(Value: Int) {
        self.ParagonTemporaryAttributes.Attack = Value
    }
    
    func modifyAttackBonus(Value: Int) {
        self.ParagonTemporaryAttributes.Attack += Value
    }
    
    func setAttackDamageBonus(Value: Int) {
        self.ParagonTemporaryAttributes.Damage = Value
    }
    
    func modifyAttackDamageBonus(Value: Int) {
        self.ParagonTemporaryAttributes.Damage += Value
    }
    
    func setMeleeDefenseBonus(Value: Int) {
        self.ParagonTemporaryAttributes.MeleeDefense = Value
    }
    
    func modifyMeleeDefenseBonus(Value: Int) {
        self.ParagonTemporaryAttributes.MeleeDefense += Value
    }
    
    func setRangeDefenseBonus(Value: Int) {
        self.ParagonTemporaryAttributes.RangeDefense = Value
    }
    
    func modifyRangeDefenseBonus(Value: Int) {
        self.ParagonTemporaryAttributes.RangeDefense += Value
    }
    
    func setDamageResistanceValueBonus(Value: Int) {
        self.ParagonTemporaryAttributes.Toughness = Value
    }
    
    func modifyDamageResistanceValueBonus(Value: Int) {
        self.ParagonTemporaryAttributes.Toughness += Value
    }
    
    func setParagonStatus(Status: ParagonStatus, ForNumberOfTurns: Int, SelfInflicted: Bool) {
        self.ParagonStatusManager.setStatus(Status: Status, NumberOfTurns: ForNumberOfTurns, SelfInflicted: SelfInflicted)
    }
    
    func becomeImmuneAll() {
        self.ParagonStatusManager.ImmuneToMeleeAttacks = true
        self.ParagonStatusManager.ImmuneToRangedAttacks = true
        self.ParagonStatusManager.ImmuneToMentalAttacks = true
    }
    
    func becomeImmuneMelee() {
        self.ParagonStatusManager.ImmuneToMeleeAttacks = true
    }
    
    func becomeImmuneRanged() {
        self.ParagonStatusManager.ImmuneToRangedAttacks = true
    }
    
    func becomeImmuneMental() {
        self.ParagonStatusManager.ImmuneToMentalAttacks = true
    }
    
    func becomeImmuneAllTemporary() {
        self.ParagonStatusManager.ImmuneToMeleeAttacksTemporary = true
        self.ParagonStatusManager.ImmuneToRangedAttacksTemporary = true
        self.ParagonStatusManager.ImmuneToMentalAttacksTemporary = true
    }
    
    func becomeImmuneMeleeTemporary() {
        self.ParagonStatusManager.ImmuneToMeleeAttacksTemporary = true
    }
    
    func becomeImmuneRangedTemporary() {
        self.ParagonStatusManager.ImmuneToRangedAttacksTemporary = true
    }
    
    func becomeImmuneMentalTemporary() {
        self.ParagonStatusManager.ImmuneToMentalAttacksTemporary = true
    }
}
