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
        AttackCSVReader.readAttackCollectionCSV()
        self.AttackCollectionArray = AttackCSVReader.AttackCollectionArray
        createAttackDictionaries()
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
        var AttackPosition = -1
        let AttackIDRawValue = "\"\(forAttackID)\""
        for i in 0..<AttackCollectionArray.count {
            if AttackCollectionArray[i][0] == AttackIDRawValue {
                AttackPosition = i
                break
            }
        }
        
        for i in 0..<AttackCollectionArray[AttackPosition].count {
            AttackCollectionArray[AttackPosition][i] = AttackCollectionArray[AttackPosition][i].replacingOccurrences(of: "\"", with: "", options: .literal, range: nil)
        }
        
        if AttackPosition == -1 {
            return ParagonAttack()
        }
        
        let CreatedAttackClass: AttackClass = AttackClass(rawValue: AttackCollectionArray[AttackPosition][CSVPositions.AttackClassPos])!
        
        let AttackTypesStringArray: [String] = (AttackCollectionArray[AttackPosition][CSVPositions.AttackTypesPos]).components(separatedBy: "|")
        var CreatedAttackTypes: [AttackType] = []
        var ShouldSkipNextItem: Bool = false
        for i in 0..<AttackTypesStringArray.count {
            if !ShouldSkipNextItem {
                if AttackTypesStringArray[i] == "Random" {
                    ShouldSkipNextItem = true
                    let randomTypesCount: Int = Int(AttackTypesStringArray[i+1])!
                    let attackType: AttackType = AttackType.None
                    var allMagicTypes = attackType.getMagicTypes()
                    allMagicTypes.shuffle()
                    for j in 0..<randomTypesCount {
                        CreatedAttackTypes.append(allMagicTypes[j])
                    }
                } else {
                    CreatedAttackTypes.append(AttackType(rawValue: AttackTypesStringArray[i])!)
                }
            } else {
                ShouldSkipNextItem = false
            }
            
        }
        
        let CreatedAttackID: String = String(AttackCollectionArray[AttackPosition][CSVPositions.AttackIDPos])
        let CreatedAttackParagonClass: String = String(AttackCollectionArray[AttackPosition][CSVPositions.AttackParagonClassPos])
        let CreatedAttackParagonClassAttackTier: String = String(AttackCollectionArray[AttackPosition][CSVPositions.AttackParagonClassAttackTierPos])
        let CreatedAttackName: String = String(AttackCollectionArray[AttackPosition][CSVPositions.AttackNamePos])
        let CreatedAttackDifficulty: Int = Int(AttackCollectionArray[AttackPosition][CSVPositions.AttackDifficultyPos])!
        let CreatedAttackValue: Int = Int(AttackCollectionArray[AttackPosition][CSVPositions.AttackValuePos])!
        let CreatedAttackBaseDamage: Int = Int(AttackCollectionArray[AttackPosition][CSVPositions.AttackBaseDamagePos])!
        let CreatedAttackDamageDie: String = String(AttackCollectionArray[AttackPosition][CSVPositions.AttackDamageDiePos])
        let CreatedBuffToSelf: Bool = Bool(AttackCollectionArray[AttackPosition][CSVPositions.AttackBuffToSelfPos])!
        let CreatedBuffIsForAlly: Bool = Bool(AttackCollectionArray[AttackPosition][CSVPositions.AttackBuffIsForAllyPos])!
        let CreatedBuffIsAOE: Bool = Bool(AttackCollectionArray[AttackPosition][CSVPositions.AttackBuffIsAOEPos])!
        let CreatedBuffAOERange: Int = Int(AttackCollectionArray[AttackPosition][CSVPositions.AttackBuffAOERangePos])!
        let CreatedDebuffToSelf: Bool = Bool(AttackCollectionArray[AttackPosition][CSVPositions.AttackDebuffToSelfPos])!
        let CreatedDebuffIsForAlly: Bool = Bool(AttackCollectionArray[AttackPosition][CSVPositions.AttackDebuffIsForAllyPos])!
        let CreatedDebuffIsAOE: Bool = Bool(AttackCollectionArray[AttackPosition][CSVPositions.AttackDebuffIsAOEPos])!
        let CreatedDebuffAOERange: Int = Int(AttackCollectionArray[AttackPosition][CSVPositions.AttackDebuffAOERangePos])!
        let CreatedAttackUsesPrimaryWeaponAttack: Bool = Bool(AttackCollectionArray[AttackPosition][CSVPositions.AttackUsesPrimaryWeaponPos])!
        let CreatedAttackEnergyCost: Int = Int(AttackCollectionArray[AttackPosition][CSVPositions.AttackEnergyCostPos])!
        let CreatedAttackPoints: Int = Int(AttackCollectionArray[AttackPosition][CSVPositions.AttackPointsMAXPos])!
        let CreatedUnlimitedAttackPoints: Bool = Bool(AttackCollectionArray[AttackPosition][CSVPositions.AttackUnlimitedAttackPointsPos])!
        let CreatedAttackRangeMinimum: Int = Int(AttackCollectionArray[AttackPosition][CSVPositions.AttackRangeMinimumPos])!
        let CreatedAttackRangeMaximum: Int = Int(AttackCollectionArray[AttackPosition][CSVPositions.AttackRangeMaximumPos])!
        let CreatedNumberOfAttacks: Int = Int(AttackCollectionArray[AttackPosition][CSVPositions.AttackNumberOfAttacksPos])!
        let CreatedisAOE: Bool = Bool(AttackCollectionArray[AttackPosition][CSVPositions.AttackisAOEPos])!
        let CreatedisUltimate: Bool = Bool(AttackCollectionArray[AttackPosition][CSVPositions.AttackisUltimatePos])!
        let CreatedisPrimaryAttack: Bool = Bool(AttackCollectionArray[AttackPosition][CSVPositions.AttackisPrimaryPos])!
        
        let CreatedAttackDistance: AttackDistance = AttackDistance(rawValue: AttackCollectionArray[AttackPosition][CSVPositions.AttackDistancePos])!
        let CreatedAttackMovementSpeedHinderance: AttackMovementSpeedHinderance = AttackMovementSpeedHinderance(rawValue: AttackCollectionArray[AttackPosition][CSVPositions.AttackMovementSpeedHinderancePos])!
        let CreatedAttackMovementOccasion: AttackMovementOccasion = AttackMovementOccasion(rawValue: AttackCollectionArray[AttackPosition][CSVPositions.AttackMovementOccasionPos])!
        let CreatedAttackActivationPhase: AttackActivationPhase = AttackActivationPhase(rawValue: AttackCollectionArray[AttackPosition][CSVPositions.AttackActivationPhasePos])!
        let CreatedAOEType: AOEType = AOEType(rawValue: AttackCollectionArray[AttackPosition][CSVPositions.AttackAOETypePos])!
        let BuffAOEType: AOEType = AOEType(rawValue: AttackCollectionArray[AttackPosition][CSVPositions.AttackBuffAOETypePos])!
        let DebuffAOEType: AOEType = AOEType(rawValue: AttackCollectionArray[AttackPosition][CSVPositions.AttackDebuffAOETypePos])!
    
        let AttackSelfStatusInflictionStringArray: [String] = (AttackCollectionArray[AttackPosition][CSVPositions.AttackSelfStatusInflictionPos]).components(separatedBy: "|")
        var CreatedAttackSelfStatusInfliction: [ParagonStatus] = []
        for i in 0..<AttackSelfStatusInflictionStringArray.count {
            CreatedAttackSelfStatusInfliction.append(ParagonStatus(rawValue: AttackSelfStatusInflictionStringArray[i])!)
        }
        
        let AttackSelfStatusInflictionTurnsStringArray: [String] = (AttackCollectionArray[AttackPosition][CSVPositions.AttackSelfStatusInflictionTurnsPos]).components(separatedBy: "|")
        var CreatedAttackSelfStatusInflictionTurns: [Int] = []
        for i in 0..<AttackSelfStatusInflictionTurnsStringArray.count {
            CreatedAttackSelfStatusInflictionTurns.append(Int(AttackSelfStatusInflictionTurnsStringArray[i])!)
        }
        
        let AttackStatusInflictionStringArray: [String] = (AttackCollectionArray[AttackPosition][CSVPositions.AttackStatusInflictionPos]).components(separatedBy: "|")
        var CreatedAttackStatusInfliction: [ParagonStatus] = []
        for i in 0..<AttackStatusInflictionStringArray.count {
            CreatedAttackStatusInfliction.append(ParagonStatus(rawValue: AttackStatusInflictionStringArray[i])!)
        }
        
        let AttackStatusInflictionTurnsStringArray: [String] = (AttackCollectionArray[AttackPosition][CSVPositions.AttackStatusInflictionTurnsPos]).components(separatedBy: "|")
        var CreatedAttackStatusInflictionTurns: [Int] = []
        for i in 0..<AttackStatusInflictionStringArray.count {
            CreatedAttackStatusInflictionTurns.append(Int(AttackStatusInflictionTurnsStringArray[i])!)
        }
        
        let BuffName = (CreatedAttackName + " Buff")
        let BuffHealth: Int = Int(AttackCollectionArray[AttackPosition][CSVPositions.AttackBuffHealthPos])!
        let BuffEnergy: Int = Int(AttackCollectionArray[AttackPosition][CSVPositions.AttackBuffEnergyPos])!
        let BuffSpeed: Int = Int(AttackCollectionArray[AttackPosition][CSVPositions.AttackBuffSpeedPos])!
        let BuffHealthRecovery: Int = Int(AttackCollectionArray[AttackPosition][CSVPositions.AttackBuffHealthRecoveryPos])!
        let BuffEnergyRecovery: Int = Int(AttackCollectionArray[AttackPosition][CSVPositions.AttackBuffEnergyRecoveryPos])!
        let BuffAttack: Int = Int(AttackCollectionArray[AttackPosition][CSVPositions.AttackBuffAttackPos])!
        let BuffDamage: Int = Int(AttackCollectionArray[AttackPosition][CSVPositions.AttackBuffDamagePos])!
        let BuffFighting: Int = Int(AttackCollectionArray[AttackPosition][CSVPositions.AttackBuffFightingPos])!
        let BuffSharpshooting: Int = Int(AttackCollectionArray[AttackPosition][CSVPositions.AttackBuffSharpshootingPos])!
        let BuffCombatMagic: Int = Int(AttackCollectionArray[AttackPosition][CSVPositions.AttackBuffCombatMagicPos])!
        let BuffMeleeDefense: Int = Int(AttackCollectionArray[AttackPosition][CSVPositions.AttackBuffMeleeDefensePos])!
        let BuffRangeDefense: Int = Int(AttackCollectionArray[AttackPosition][CSVPositions.AttackBuffRangeDefensePos])!
        let BuffToughness: Int = Int(AttackCollectionArray[AttackPosition][CSVPositions.AttackBuffToughnessPos])!
        let BuffWillpower: Int = Int(AttackCollectionArray[AttackPosition][CSVPositions.AttackBuffWillpowerPos])!
        
        let BuffImmuneTypesStringArray: [String] = (AttackCollectionArray[AttackPosition][CSVPositions.AttackBuffImmuneTypesPos]).components(separatedBy: "|")
        var BuffImmuneTypes: [AttackType] = []
        for i in 0..<BuffImmuneTypesStringArray.count {
            BuffImmuneTypes.append(AttackType(rawValue: BuffImmuneTypesStringArray[i])!)
        }
        let BuffImmuneTypesTurnsStringArray: [String] = (AttackCollectionArray[AttackPosition][CSVPositions.AttackBuffImmuneTypesTurnsPos]).components(separatedBy: "|")
        var BuffImmuneTypesTurns: [Int] = []
        for i in 0..<BuffImmuneTypesTurnsStringArray.count {
            BuffImmuneTypesTurns.append(Int(BuffImmuneTypesTurnsStringArray[i])!)
        }

        let BuffStrengthTypesStringArray: [String] = (AttackCollectionArray[AttackPosition][CSVPositions.AttackBuffStrengthTypesPos]).components(separatedBy: "|")
        var BuffStrengthTypes: [AttackType] = []
        for i in 0..<BuffStrengthTypesStringArray.count {
            BuffStrengthTypes.append(AttackType(rawValue: BuffStrengthTypesStringArray[i])!)
        }
        let BuffStrengthTypesTurnsStringArray: [String] = (AttackCollectionArray[AttackPosition][CSVPositions.AttackBuffStrengthTypesTurnsPos]).components(separatedBy: "|")
        var BuffStrengthTypesTurns: [Int] = []
        for i in 0..<BuffStrengthTypesTurnsStringArray.count {
            BuffStrengthTypesTurns.append(Int(BuffStrengthTypesTurnsStringArray[i])!)
        }
        
        let BuffWeaknessTypesStringArray: [String] = (AttackCollectionArray[AttackPosition][CSVPositions.AttackBuffWeaknessTypesPos]).components(separatedBy: "|")
        var BuffWeaknessTypes: [AttackType] = []
        for i in 0..<BuffWeaknessTypesStringArray.count {
            BuffWeaknessTypes.append(AttackType(rawValue: BuffWeaknessTypesStringArray[i])!)
        }
        let BuffWeaknessTypesTurnsStringArray: [String] = (AttackCollectionArray[AttackPosition][CSVPositions.AttackBuffWeaknessTypesTurnsPos]).components(separatedBy: "|")
        var BuffWeaknessTypesTurns: [Int] = []
        for i in 0..<BuffWeaknessTypesTurnsStringArray.count {
            BuffWeaknessTypesTurns.append(Int(BuffWeaknessTypesTurnsStringArray[i])!)
        }
        
        let BuffMeleeImmune: Bool = Bool(AttackCollectionArray[AttackPosition][CSVPositions.AttackBuffMeleeImmunePos])!
        let BuffMeleeImmuneTurns: Int = Int(AttackCollectionArray[AttackPosition][CSVPositions.AttackBuffMeleeImmuneTurnsPos])!
        let BuffRangeImmune: Bool = Bool(AttackCollectionArray[AttackPosition][CSVPositions.AttackBuffRangeImmunePos])!
        let BuffRangeImmuneTurns: Int = Int(AttackCollectionArray[AttackPosition][CSVPositions.AttackBuffRangeImmuneTurnsPos])!

        let CreatedBuffAttributes: AttributesManager = AttributesManager(ID: (CreatedAttackName+"Buff"), Image: CreatedAttackID, Name: BuffName, Health: BuffHealth, Energy: BuffEnergy, Speed: BuffSpeed, Initiative: 0, HealthRecovery: BuffHealthRecovery, EnergyRecovery: BuffEnergyRecovery, Attack: BuffAttack, Damage: BuffDamage, Fighting: BuffFighting, Sharpshooting: BuffSharpshooting, CombatMagic: BuffCombatMagic, MeleeDefense: BuffMeleeDefense, RangeDefense: BuffRangeDefense, Toughness: BuffToughness, Willpower: BuffWillpower, ImmuneTypes: BuffImmuneTypes, ImmuneTypesTurns: BuffImmuneTypesTurns, StrengthTypes: BuffStrengthTypes, StrengthTypesTurns: BuffStrengthTypesTurns, WeaknessTypes: BuffWeaknessTypes, WeaknessTypesTurns: BuffWeaknessTypesTurns, MeleeImmune: BuffMeleeImmune, MeleeImmuneTurns: BuffMeleeImmuneTurns, RangeImmune: BuffRangeImmune, RangeImmuneTurns: BuffRangeImmuneTurns)
        let BuffTurns: Int = Int(AttackCollectionArray[AttackPosition][CSVPositions.AttackBuffTurnsPos])!
        let CreatedBuff: Buff = Buff(BuffName: BuffName, BuffTurns: BuffTurns, BuffAttributes: CreatedBuffAttributes)
        
        let DebuffName = (CreatedAttackName + " Debuff")
        let DebuffHealth: Int = Int(AttackCollectionArray[AttackPosition][CSVPositions.AttackDebuffHealthPos])!
        let DebuffEnergy: Int = Int(AttackCollectionArray[AttackPosition][CSVPositions.AttackDebuffEnergyPos])!
        let DebuffSpeed: Int = Int(AttackCollectionArray[AttackPosition][CSVPositions.AttackDebuffSpeedPos])!
        let DebuffHealthRecovery: Int = Int(AttackCollectionArray[AttackPosition][CSVPositions.AttackDebuffHealthRecoveryPos])!
        let DebuffEnergyRecovery: Int = Int(AttackCollectionArray[AttackPosition][CSVPositions.AttackDebuffEnergyRecoveryPos])!
        let DebuffAttack: Int = Int(AttackCollectionArray[AttackPosition][CSVPositions.AttackDebuffAttackPos])! 
        let DebuffDamage: Int = Int(AttackCollectionArray[AttackPosition][CSVPositions.AttackDebuffDamagePos])!
        let DebuffFighting: Int = Int(AttackCollectionArray[AttackPosition][CSVPositions.AttackDebuffFightingPos])!
        let DebuffSharpshooting: Int = Int(AttackCollectionArray[AttackPosition][CSVPositions.AttackDebuffSharpshootingPos])!
        let DebuffCombatMagic: Int = Int(AttackCollectionArray[AttackPosition][CSVPositions.AttackDebuffCombatMagicPos])!
        let DebuffMeleeDefense: Int = Int(AttackCollectionArray[AttackPosition][CSVPositions.AttackDebuffMeleeDefensePos])!
        let DebuffRangeDefense: Int = Int(AttackCollectionArray[AttackPosition][CSVPositions.AttackDebuffRangeDefensePos])!
        let DebuffToughness: Int = Int(AttackCollectionArray[AttackPosition][CSVPositions.AttackDebuffToughnessPos])!
        let DebuffWillpower: Int = Int(AttackCollectionArray[AttackPosition][CSVPositions.AttackDebuffWillpowerPos])!
        
        let DebuffImmuneTypesStringArray: [String] = (AttackCollectionArray[AttackPosition][CSVPositions.AttackDebuffImmuneTypesPos]).components(separatedBy: "|")
        var DebuffImmuneTypes: [AttackType] = []
        for i in 0..<DebuffImmuneTypesStringArray.count {
            DebuffImmuneTypes.append(AttackType(rawValue: DebuffImmuneTypesStringArray[i])!)
        }
        let DebuffImmuneTypesTurnsStringArray: [String] = (AttackCollectionArray[AttackPosition][CSVPositions.AttackDebuffImmuneTypesTurnsPos]).components(separatedBy: "|")
        var DebuffImmuneTypesTurns: [Int] = []
        for i in 0..<DebuffImmuneTypesTurnsStringArray.count {
            DebuffImmuneTypesTurns.append(Int(DebuffImmuneTypesTurnsStringArray[i])!)
        }

        let DebuffStrengthTypesStringArray: [String] = (AttackCollectionArray[AttackPosition][CSVPositions.AttackDebuffStrengthTypesPos]).components(separatedBy: "|")
        var DebuffStrengthTypes: [AttackType] = []
        for i in 0..<DebuffStrengthTypesStringArray.count {
            DebuffStrengthTypes.append(AttackType(rawValue: DebuffStrengthTypesStringArray[i])!)
        }
        let DebuffStrengthTypesTurnsStringArray: [String] = (AttackCollectionArray[AttackPosition][CSVPositions.AttackDebuffStrengthTypesTurnsPos]).components(separatedBy: "|")
        var DebuffStrengthTypesTurns: [Int] = []
        for i in 0..<DebuffStrengthTypesTurnsStringArray.count {
            DebuffStrengthTypesTurns.append(Int(DebuffStrengthTypesTurnsStringArray[i])!)
        }
        
        let DebuffWeaknessTypesStringArray: [String] = (AttackCollectionArray[AttackPosition][CSVPositions.AttackDebuffWeaknessTypesPos]).components(separatedBy: "|")
        var DebuffWeaknessTypes: [AttackType] = []
        for i in 0..<DebuffWeaknessTypesStringArray.count {
            DebuffWeaknessTypes.append(AttackType(rawValue: DebuffWeaknessTypesStringArray[i])!)
        }
        let DebuffWeaknessTypesTurnsStringArray: [String] = (AttackCollectionArray[AttackPosition][CSVPositions.AttackDebuffWeaknessTypesTurnsPos]).components(separatedBy: "|")
        var DebuffWeaknessTypesTurns: [Int] = []
        for i in 0..<DebuffWeaknessTypesTurnsStringArray.count {
            DebuffWeaknessTypesTurns.append(Int(DebuffWeaknessTypesTurnsStringArray[i])!)
        }
        
        let DebuffMeleeImmune: Bool = Bool(AttackCollectionArray[AttackPosition][CSVPositions.AttackDebuffMeleeImmunePos])!
        let DebuffMeleeImmuneTurns: Int = Int(AttackCollectionArray[AttackPosition][CSVPositions.AttackDebuffMeleeImmuneTurnsPos])!
        let DebuffRangeImmune: Bool = Bool(AttackCollectionArray[AttackPosition][CSVPositions.AttackDebuffRangeImmunePos])!
        let DebuffRangeImmuneTurns: Int = Int(AttackCollectionArray[AttackPosition][CSVPositions.AttackDebuffRangeImmuneTurnsPos])!

        let CreatedDebuffAttributes: AttributesManager = AttributesManager(ID: (CreatedAttackName+"Debuff"), Image: CreatedAttackID, Name: DebuffName, Health: DebuffHealth, Energy: DebuffEnergy, Speed: DebuffSpeed, Initiative: 0, HealthRecovery: DebuffHealthRecovery, EnergyRecovery: DebuffEnergyRecovery, Attack: DebuffAttack, Damage: DebuffDamage, Fighting: DebuffFighting, Sharpshooting: DebuffSharpshooting, CombatMagic: DebuffCombatMagic, MeleeDefense: DebuffMeleeDefense, RangeDefense: DebuffRangeDefense, Toughness: DebuffToughness, Willpower: DebuffWillpower, ImmuneTypes: DebuffImmuneTypes, ImmuneTypesTurns: DebuffImmuneTypesTurns, StrengthTypes: DebuffStrengthTypes, StrengthTypesTurns: DebuffStrengthTypesTurns, WeaknessTypes: DebuffWeaknessTypes, WeaknessTypesTurns: DebuffWeaknessTypesTurns, MeleeImmune: DebuffMeleeImmune, MeleeImmuneTurns: DebuffMeleeImmuneTurns, RangeImmune: DebuffRangeImmune, RangeImmuneTurns: DebuffRangeImmuneTurns)
        let DebuffTurns: Int = Int(AttackCollectionArray[AttackPosition][CSVPositions.AttackDebuffTurnsPos])!
        let CreatedDebuff: Buff = Buff(BuffName: DebuffName, BuffTurns: DebuffTurns, BuffAttributes: CreatedDebuffAttributes)
        
        let CreatedAttack = ParagonAttack(AttackID: CreatedAttackID, AttackParagonClass: CreatedAttackParagonClass, AttackParagonClassAttackTier: CreatedAttackParagonClassAttackTier, AttackName: CreatedAttackName, AttackClass: CreatedAttackClass, AttackDifficulty: CreatedAttackDifficulty, AttackValue: CreatedAttackValue, AttackBaseDamage: CreatedAttackBaseDamage, AttackDamageDie: CreatedAttackDamageDie, BuffToSelf: CreatedBuffToSelf, BuffIsForAlly: CreatedBuffIsForAlly, BuffIsAOE: CreatedBuffIsAOE, BuffAOEType: BuffAOEType, BuffAOERange: CreatedBuffAOERange, DebuffToSelf: CreatedDebuffToSelf, DebuffIsForAlly: CreatedDebuffIsForAlly, DebuffIsAOE: CreatedDebuffIsAOE, DebuffAOEType: DebuffAOEType, DebuffAOERange: CreatedDebuffAOERange, AttackUsesPrimaryWeaponAttack: CreatedAttackUsesPrimaryWeaponAttack, AttackEnergyCost: CreatedAttackEnergyCost, AttackPoints: CreatedAttackPoints, UnlimitedAttackPoints: CreatedUnlimitedAttackPoints, AttackTypes: CreatedAttackTypes, AttackDistance: CreatedAttackDistance, AttackRangeMinimum: CreatedAttackRangeMinimum, AttackRangeMaximum: CreatedAttackRangeMaximum, AttackMovementSpeedHinderance: CreatedAttackMovementSpeedHinderance, AttackMovementOccasion: CreatedAttackMovementOccasion, AttackActivationPhase: CreatedAttackActivationPhase, AttackSelfStatusInfliction: CreatedAttackSelfStatusInfliction, AttackSelfStatusInflictionTurns: CreatedAttackSelfStatusInflictionTurns, AttackStatusInfliction: CreatedAttackStatusInfliction, AttackStatusInflictionTurns: CreatedAttackStatusInflictionTurns, NumberOfAttacks: CreatedNumberOfAttacks, isAOE: CreatedisAOE, AOEType: CreatedAOEType, isUltimate: CreatedisUltimate, isPrimaryAttack: CreatedisPrimaryAttack, Buff: CreatedBuff, Debuff: CreatedDebuff)
        
        let WeaponKey: String = String(AttackCollectionArray[AttackPosition][CSVPositions.AttackWeaponPos])
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
