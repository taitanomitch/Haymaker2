//
//  WeaponCollectionUtility.swift
//  Haymaker2
//
//  Created by Mitchell Taitano on 8/13/22.
//

import Foundation

class WeaponCollection {
    
    var WeaponCollectionArray: [[String]] = [[]]
    var WeaponDictionary: Dictionary = Dictionary<String, Weapon>()
    
    init() {
        let CardCSVReader = CSVReader()
        CardCSVReader.readWeaponCollectionCSV()
        self.WeaponCollectionArray = CardCSVReader.WeaponCollectionArray
        createWeaponDictionary()
    }
    
    func createWeaponDictionary() {
        for i in 1..<WeaponCollectionArray.count {
            var NextWeaponID = WeaponCollectionArray[i][0]
            NextWeaponID = NextWeaponID.replacingOccurrences(of: "\"", with: "")
            let NextWeapon: Weapon = parseWeaponCollectionCSV(forWeaponID: NextWeaponID)
            WeaponDictionary[NextWeaponID] = NextWeapon
        }
    }
    
    func parseWeaponCollectionCSV(forWeaponID: String) -> Weapon {
        let CSVPositions: CSVReaderPositionsUtility = CSVReaderPositionsUtility()
        var WeaponPosition = -1
        let WeaponIDRawValue = "\"\(forWeaponID)\""
        for i in 0..<WeaponCollectionArray.count {
            if WeaponCollectionArray[i][0] == WeaponIDRawValue {
                WeaponPosition = i
                break
            }
        }
        
        for i in 0..<WeaponCollectionArray[WeaponPosition].count {
            WeaponCollectionArray[WeaponPosition][i] = WeaponCollectionArray[WeaponPosition][i].replacingOccurrences(of: "\"", with: "", options: .literal, range: nil)
        }
        
        if WeaponPosition == -1 {
            return Weapon()
        }
        
        let CreatedWeaponHand: WeaponHand = WeaponHand(rawValue: WeaponCollectionArray[WeaponPosition][CSVPositions.WeaponHandPos])!
        let CreatedWeaponRarity: Rarity = Rarity(rawValue: WeaponCollectionArray[WeaponPosition][CSVPositions.WeaponRarityPos])!
        let CreatedWeaponSkillType: AttackClass = AttackClass(rawValue: WeaponCollectionArray[WeaponPosition][CSVPositions.WeaponSkillTypePos])!
        let CreatedWeaponDamageStatus: EquipmentDamageStatus = EquipmentDamageStatus(rawValue: WeaponCollectionArray[WeaponPosition][CSVPositions.WeaponDamageStatusPos])!
        
        let WeaponImmuneTypesStringArray: [String] = (WeaponCollectionArray[WeaponPosition][CSVPositions.WeaponImmuneTypesPos]).components(separatedBy: "|")
        var CreatedWeaponImmuneTypes: [AttackType] = []
        for i in 0..<WeaponImmuneTypesStringArray.count {
            CreatedWeaponImmuneTypes.append(AttackType(rawValue: WeaponImmuneTypesStringArray[i])!)
        }
        
        let WeaponImmuneTypesTurnsStringArray: [String] = (WeaponCollectionArray[WeaponPosition][CSVPositions.WeaponImmuneTypesTurnsPos]).components(separatedBy: "|")
        var CreatedWeaponImmuneTypesTurns: [Int] = []
        for i in 0..<WeaponImmuneTypesTurnsStringArray.count {
            CreatedWeaponImmuneTypesTurns.append(Int(WeaponImmuneTypesTurnsStringArray[i])!)
        }
        
        let WeaponStrengthTypesStringArray: [String] = (WeaponCollectionArray[WeaponPosition][CSVPositions.WeaponStengthTypesPos]).components(separatedBy: "|")
        var CreatedWeaponStrengthTypes: [AttackType] = []
        for i in 0..<WeaponStrengthTypesStringArray.count {
            CreatedWeaponStrengthTypes.append(AttackType(rawValue: WeaponStrengthTypesStringArray[i])!)
        }
        
        let WeaponStrengthTypesTurnsStringArray: [String] = (WeaponCollectionArray[WeaponPosition][CSVPositions.WeaponImmuneTypesTurnsPos]).components(separatedBy: "|")
        var CreatedWeaponStrengthTypesTurns: [Int] = []
        for i in 0..<WeaponStrengthTypesTurnsStringArray.count {
            CreatedWeaponStrengthTypesTurns.append(Int(WeaponStrengthTypesTurnsStringArray[i])!)
        }
        
        let WeaponWeaknessTypesStringArray: [String] = (WeaponCollectionArray[WeaponPosition][CSVPositions.WeaponStengthTypesPos]).components(separatedBy: "|")
        var CreatedWeaponWeaknessTypes: [AttackType] = []
        for i in 0..<WeaponWeaknessTypesStringArray.count {
            CreatedWeaponWeaknessTypes.append(AttackType(rawValue: WeaponWeaknessTypesStringArray[i])!)
        }
        
        let WeaponWeaknessTypesTurnsStringArray: [String] = (WeaponCollectionArray[WeaponPosition][CSVPositions.WeaponImmuneTypesTurnsPos]).components(separatedBy: "|")
        var CreatedWeaponWeaknessTypesTurns: [Int] = []
        for i in 0..<WeaponWeaknessTypesTurnsStringArray.count {
            CreatedWeaponWeaknessTypesTurns.append(Int(WeaponWeaknessTypesTurnsStringArray[i])!)
        }
        
        let WeaponType = WeaponCollectionArray[WeaponPosition][CSVPositions.WeaponAttackCollectionName]
        let AttacksCollection = AttackCollection()
        let CreatedWeaponAttacks: [ParagonAttack] = AttacksCollection.getAttacksForWeaponType(Weapon: WeaponType)
        
        let CreatedWeaponAttributes = AttributesManager(ID: WeaponCollectionArray[WeaponPosition][CSVPositions.WeaponIDPos], Image: WeaponCollectionArray[WeaponPosition][CSVPositions.WeaponImageStringPos], Name: WeaponCollectionArray[WeaponPosition][CSVPositions.WeaponName], Health: Int(WeaponCollectionArray[WeaponPosition][CSVPositions.WeaponHealthPos])!, Energy: Int(WeaponCollectionArray[WeaponPosition][CSVPositions.WeaponEnergyPos])!, Speed: Int(WeaponCollectionArray[WeaponPosition][CSVPositions.WeaponSpeedPos])!, Initiative: Int(WeaponCollectionArray[WeaponPosition][CSVPositions.WeaponInitiativePos])!, HealthRecovery: Int(WeaponCollectionArray[WeaponPosition][CSVPositions.WeaponHealthRecoveryPos])!, EnergyRecovery: Int(WeaponCollectionArray[WeaponPosition][CSVPositions.WeaponEnergyRecoveryPos])!, Attack: Int(WeaponCollectionArray[WeaponPosition][CSVPositions.WeaponAttackPos])!, Damage: Int(WeaponCollectionArray[WeaponPosition][CSVPositions.WeaponDamagePos])!, Fighting: Int(WeaponCollectionArray[WeaponPosition][CSVPositions.WeaponFightingPos])!, Sharpshooting: Int(WeaponCollectionArray[WeaponPosition][CSVPositions.WeaponSharpshootingPos])!, CombatMagic: Int(WeaponCollectionArray[WeaponPosition][CSVPositions.WeaponCombatMagicPos])!, MeleeDefense: Int(WeaponCollectionArray[WeaponPosition][CSVPositions.WeaponMeleeDefensePos])!, RangeDefense: Int(WeaponCollectionArray[WeaponPosition][CSVPositions.WeaponRangeDefensePos])!, Toughness: Int(WeaponCollectionArray[WeaponPosition][CSVPositions.WeaponToughnessPos])!, Willpower: Int(WeaponCollectionArray[WeaponPosition][CSVPositions.WeaponWillpowerPos])!, ImmuneTypes: CreatedWeaponImmuneTypes, ImmuneTypesTurns: CreatedWeaponImmuneTypesTurns, StrengthTypes: CreatedWeaponStrengthTypes, StrengthTypesTurns: CreatedWeaponStrengthTypesTurns, WeaknessTypes: CreatedWeaponWeaknessTypes, WeaknessTypesTurns: CreatedWeaponWeaknessTypesTurns, MeleeImmune: Bool(WeaponCollectionArray[WeaponPosition][CSVPositions.WeaponMeleeImmunePos])!, MeleeImmuneTurns: Int(WeaponCollectionArray[WeaponPosition][CSVPositions.WeaponMeleeImmuneTurnsPos])!, RangeImmune: Bool(WeaponCollectionArray[WeaponPosition][CSVPositions.WeaponRangeImmunePos])!, RangeImmuneTurns: Int(WeaponCollectionArray[WeaponPosition][CSVPositions.WeaponRangeImmuneTurnsPos])!)
        
        let CreatedWeapon: Weapon = Weapon(WeaponID: WeaponCollectionArray[WeaponPosition][CSVPositions.WeaponIDPos], WeaponImageString: WeaponCollectionArray[WeaponPosition][CSVPositions.WeaponImageStringPos], WeaponType: WeaponType, WeaponHand: CreatedWeaponHand, WeaponRarity: CreatedWeaponRarity, WeaponSkillType: CreatedWeaponSkillType, WeaponMinimumSkill: Int(WeaponCollectionArray[WeaponPosition][CSVPositions.WeaponMinimumSkillPos])!, WeaponCost: Int(WeaponCollectionArray[WeaponPosition][CSVPositions.WeaponCostPos])!, WeaponDurabilityHealth: Int(WeaponCollectionArray[WeaponPosition][CSVPositions.WeaponDurabilityHealth])!, WeaponDamageStatus: CreatedWeaponDamageStatus, WeaponAttacks: CreatedWeaponAttacks, WeaponAttributes: CreatedWeaponAttributes)
        
        return CreatedWeapon
    }
}
