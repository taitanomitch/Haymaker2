//
//  AttackCollectionUtility.swift
//  Haymaker2
//
//  Created by Mitchell Taitano on 8/13/22.
//

import Foundation

class AttackCollection {
    
    var AttackCollectionArray: [[String]] = [[]]
    var AttackDictionary: Dictionary = Dictionary<String, ParagonAttack>()
    var AttacksForWeaponTypeDictionary: Dictionary = Dictionary<String, [ParagonAttack]>()
    
    //MARK: - Initializer
    init() {
        let AttackCSVReader = CSVReader()
        let result = AttackCSVReader.readAttackCollectionCSV()
        if result {
            self.AttackCollectionArray = AttackCSVReader.AttackCollectionArray
            createAttackDictionaries()
        } else {
            print("Error reading Attack CSV")
        }
    }
    
    
    //MARK: - Collection and Dictionary Functions
    func getAttackFromDictionary(AttackID: String) -> ParagonAttack {
        if AttackDictionary[AttackID] != nil {
            return AttackDictionary[AttackID]!
        }
        return ParagonAttack()
    }
    
    func getAttacksForWeaponType(Weapon: String) -> [ParagonAttack] {
        if let AttackArray = AttacksForWeaponTypeDictionary[Weapon] {
            return AttackArray
        }
        return []
    }
    
    func createAttackDictionaries() {
        for i in 1..<AttackCollectionArray.count {
            var NextAttackID = AttackCollectionArray[i][0]
            NextAttackID = NextAttackID.replacingOccurrences(of: "\"", with: "")
            if NextAttackID == "MagicBlast1" {
                break
            }
            let NextAttack: ParagonAttack = parseAttackCollectionCSV(forAttackID: NextAttackID)
            AttackDictionary[NextAttackID] = NextAttack
        }
    }
    
    func parseAttackCollectionCSV(forAttackID: String) -> ParagonAttack {
        let CSVPositions: CSVReaderPositionsUtility = CSVReaderPositionsUtility()
        var attackPosition = -1
        let AttackIDRawValue = "\"\(forAttackID)\""
        for i in 0..<AttackCollectionArray.count {
            if AttackCollectionArray[i][0] == AttackIDRawValue {
                attackPosition = i
                break
            }
        }
        
        for i in 0..<AttackCollectionArray[attackPosition].count {
            AttackCollectionArray[attackPosition][i] = AttackCollectionArray[attackPosition][i].replacingOccurrences(of: "\"", with: "", options: .literal, range: nil)
        }
        
        if attackPosition == -1 {
            return ParagonAttack()
        }
        
        let CreatedAttackClass: AttackClass = AttackClass(rawValue: AttackCollectionArray[attackPosition][CSVPositions.AttackClassPos])!
        
        let AttackTypesStringArray: [String] = (AttackCollectionArray[attackPosition][CSVPositions.AttackTypesPos]).components(separatedBy: "|")
        var CreatedAttackTypes: [AttackType] = []
        for i in 0..<AttackTypesStringArray.count {
            CreatedAttackTypes.append(AttackType(rawValue: AttackTypesStringArray[i])!)
        }
        
        let CreatedAttackDistance: AttackDistance = AttackDistance(rawValue: AttackCollectionArray[attackPosition][CSVPositions.AttackDistancePos])!
        
        let CreatedAttackMovementSpeedHinderance: AttackMovementSpeedHinderance = AttackMovementSpeedHinderance(rawValue: AttackCollectionArray[attackPosition][CSVPositions.AttackMovementSpeedHinderancePos])!
        
        let CreatedAttackMovementOccasion: AttackMovementOccasion = AttackMovementOccasion(rawValue: AttackCollectionArray[attackPosition][CSVPositions.AttackMovementOccasionPos])!
        
        let AttackBenefitsStringArray: [String] = (AttackCollectionArray[attackPosition][CSVPositions.AttackBenefitsPos]).components(separatedBy: "|")
        var CreatedAttackBenefits: [AttackBenefits] = []
        for i in 0..<AttackBenefitsStringArray.count {
            CreatedAttackBenefits.append(AttackBenefits(rawValue: AttackBenefitsStringArray[i])!)
        }
        
        let AttackSelfStatusInflictionStringArray: [String] = (AttackCollectionArray[attackPosition][CSVPositions.AttackSelfStatusInflictionPos]).components(separatedBy: "|")
        var CreatedAttackSelfStatusInfliction: [ParagonStatus] = []
        for i in 0..<AttackSelfStatusInflictionStringArray.count {
            CreatedAttackSelfStatusInfliction.append(ParagonStatus(rawValue: AttackSelfStatusInflictionStringArray[i])!)
        }
        
        let AttackSelfStatusInflictionTurnsStringArray: [String] = (AttackCollectionArray[attackPosition][CSVPositions.AttackSelfStatusInflictionTurnsPos]).components(separatedBy: "|")
        var CreatedAttackSelfStatusInflictionTurns: [Int] = []
        for i in 0..<AttackSelfStatusInflictionTurnsStringArray.count {
            CreatedAttackSelfStatusInflictionTurns.append(Int(AttackSelfStatusInflictionTurnsStringArray[i])!)
        }
        
        let AttackStatusInflictionStringArray: [String] = (AttackCollectionArray[attackPosition][CSVPositions.AttackStatusInflictionPos]).components(separatedBy: "|")
        var CreatedAttackStatusInfliction: [ParagonStatus] = []
        for i in 0..<AttackStatusInflictionStringArray.count {
            CreatedAttackStatusInfliction.append(ParagonStatus(rawValue: AttackStatusInflictionStringArray[i])!)
        }
        
        let AttackStatusInflictionTurnsStringArray: [String] = (AttackCollectionArray[attackPosition][CSVPositions.AttackStatusInflictionTurnsPos]).components(separatedBy: "|")
        var CreatedAttackStatusInflictionTurns: [Int] = []
        for i in 0..<AttackStatusInflictionStringArray.count {
            CreatedAttackStatusInflictionTurns.append(Int(AttackStatusInflictionTurnsStringArray[i])!)
        }
        
        let CreatedAOEType: AOEType = AOEType(rawValue: AttackCollectionArray[attackPosition][CSVPositions.AttackAOETypePos])!
        
        let BuffAOEType: AOEType = AOEType(rawValue: AttackCollectionArray[attackPosition][CSVPositions.AttackBuffAOETypePos])!
        let DebuffAOEType: AOEType = AOEType(rawValue: AttackCollectionArray[attackPosition][CSVPositions.AttackDebuffAOETypePos])!
        
        let CreatedAttack = ParagonAttack(AttackID: String(AttackCollectionArray[attackPosition][CSVPositions.AttackIDPos]), AttackParagonClass: String(AttackCollectionArray[attackPosition][CSVPositions.AttackParagonClassPos]), AttackName: String(AttackCollectionArray[attackPosition][CSVPositions.AttackNamePos]), AttackClass: CreatedAttackClass, AttackDifficulty: Int(AttackCollectionArray[attackPosition][CSVPositions.AttackDifficultyPos])!, AttackValue: Int(AttackCollectionArray[attackPosition][CSVPositions.AttackValuePos])!, AttackBaseDamage: Int(AttackCollectionArray[attackPosition][CSVPositions.AttackBaseDamagePos])!, AttackDamageDie: AttackCollectionArray[attackPosition][CSVPositions.AttackDamageDiePos], BuffAttack: Int(AttackCollectionArray[attackPosition][CSVPositions.AttackBuffAttackPos])!, BuffDamage: Int(AttackCollectionArray[attackPosition][CSVPositions.AttackBuffDamagePos])!, BuffMeleeDefense: Int(AttackCollectionArray[attackPosition][CSVPositions.AttackBuffMeleeDefensePos])!, BuffRangeDefense: Int(AttackCollectionArray[attackPosition][CSVPositions.AttackBuffRangeDefensePos])!, BuffToughness: Int(AttackCollectionArray[attackPosition][CSVPositions.AttackBuffToughnessPos])!, BuffWillpower: Int(AttackCollectionArray[attackPosition][CSVPositions.AttackBuffWillpowerPos])!, BuffAttackToSelf: Bool(AttackCollectionArray[attackPosition][CSVPositions.AttackAttackBuffToSelfPos])!, BuffDamageToSelf: Bool(AttackCollectionArray[attackPosition][CSVPositions.AttackDamageBuffToSelfPos])!, BuffMeleeDefenseToSelf: Bool(AttackCollectionArray[attackPosition][CSVPositions.AttackMeleeDefenseBuffToSelfPos])!, BuffRangeDefenseToSelf: Bool(AttackCollectionArray[attackPosition][CSVPositions.AttackRangeDefenseBuffToSelfPos])!, BuffToughnessToSelf: Bool(AttackCollectionArray[attackPosition][CSVPositions.AttackToughnessBuffToSelfPos])!, BuffWillpowerToSelf: Bool(AttackCollectionArray[attackPosition][CSVPositions.AttackWilpowerBuffToSelfPos])!, BuffIsForAlly: Bool(AttackCollectionArray[attackPosition][CSVPositions.AttackBuffIsForAllyPos])!, BuffIsAOE: Bool(AttackCollectionArray[attackPosition][CSVPositions.AttackBuffIsAOEPos])!, BuffAOEType: BuffAOEType, BuffAOERange: Int(AttackCollectionArray[attackPosition][CSVPositions.AttackBuffAOERangePos])!, DebuffAttack: Int(AttackCollectionArray[attackPosition][CSVPositions.AttackDebuffAttackPos])!, DebuffDamage: Int(AttackCollectionArray[attackPosition][CSVPositions.AttackDebuffDamagePos])!, DebuffMeleeDefense: Int(AttackCollectionArray[attackPosition][CSVPositions.AttackDebuffMeleeDefensePos])!, DebuffRangeDefense: Int(AttackCollectionArray[attackPosition][CSVPositions.AttackDebuffRangeDefensePos])!, DebuffToughness: Int(AttackCollectionArray[attackPosition][CSVPositions.AttackDebuffToughnessPos])!, DebuffWillpower: Int(AttackCollectionArray[attackPosition][CSVPositions.AttackDebuffWillpowerPos])!, DebuffAttackToSelf: Bool(AttackCollectionArray[attackPosition][CSVPositions.AttackAttackDebuffToSelfPos])!, DebuffDamageToSelf: Bool(AttackCollectionArray[attackPosition][CSVPositions.AttackDamageDebuffToSelfPos])!, DebuffMeleeDefenseToSelf: Bool(AttackCollectionArray[attackPosition][CSVPositions.AttackMeleeDefenseDebuffToSelfPos])!, DebuffRangeDefenseToSelf: Bool(AttackCollectionArray[attackPosition][CSVPositions.AttackRangeDefenseDebuffToSelfPos])!, DebuffToughnessToSelf: Bool(AttackCollectionArray[attackPosition][CSVPositions.AttackToughnessDebuffToSelfPos])!, DebuffWillpowerToSelf: Bool(AttackCollectionArray[attackPosition][CSVPositions.AttackWilpowerDebuffToSelfPos])!, DebuffIsForAlly: Bool(AttackCollectionArray[attackPosition][CSVPositions.AttackDebuffIsForAllyPos])!, DebuffIsAOE: Bool(AttackCollectionArray[attackPosition][CSVPositions.AttackDebuffIsAOEPos])!, DebuffAOEType: DebuffAOEType, DebuffAOERange: Int(AttackCollectionArray[attackPosition][CSVPositions.AttackDebuffAOERangePos])!, AttackUsesPrimaryWeaponAttack: Bool(AttackCollectionArray[attackPosition][CSVPositions.AttackUsesPrimaryWeaponPos])!, AttackEnergyCost: Int(AttackCollectionArray[attackPosition][CSVPositions.AttackEnergyCostPos])!, AttackPoints: Int(AttackCollectionArray[attackPosition][CSVPositions.AttackPointsMAXPos])!, UnlimitedAttackPoints: Bool(AttackCollectionArray[attackPosition][CSVPositions.AttackUnlimitedAttackPointsPos])!, AttackTypes: CreatedAttackTypes, AttackDistance: CreatedAttackDistance, AttackRangeMinimum: Double(AttackCollectionArray[attackPosition][CSVPositions.AttackRangeMinimumPos])!, AttackRangeMaximum: Double(AttackCollectionArray[attackPosition][CSVPositions.AttackRangeMaximumPos])!, AttackMovementSpeedHinderance: CreatedAttackMovementSpeedHinderance, AttackMovementOccasion: CreatedAttackMovementOccasion, AttackBenefits: CreatedAttackBenefits, AttackSelfStatusInfliction: CreatedAttackSelfStatusInfliction, AttackSelfStatusInflictionTurns: CreatedAttackSelfStatusInflictionTurns, AttackStatusInfliction: CreatedAttackStatusInfliction, AttackStatusInflictionTurns: CreatedAttackStatusInflictionTurns, NumberOfAttacks: Int(AttackCollectionArray[attackPosition][CSVPositions.AttackNumberOfAttacksPos])!, isAOE: Bool(AttackCollectionArray[attackPosition][CSVPositions.AttackisAOEPos])!, AOEType: CreatedAOEType, isUltimate: Bool(AttackCollectionArray[attackPosition][CSVPositions.AttackisUltimatePos])!, isPrimaryAttack: Bool(AttackCollectionArray[attackPosition][CSVPositions.AttackisPrimaryPos])!)
        
        let WeaponKey: String = String(AttackCollectionArray[attackPosition][CSVPositions.AttackWeaponPos])
        if var AttackArray = AttacksForWeaponTypeDictionary[WeaponKey] {
            AttackArray.append(CreatedAttack)
            AttacksForWeaponTypeDictionary[WeaponKey] = AttackArray
        } else {
            let newAttackArray: [ParagonAttack] = [CreatedAttack]
            AttacksForWeaponTypeDictionary[WeaponKey] = newAttackArray
        }
        
        return CreatedAttack
    }
}
