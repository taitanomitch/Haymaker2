//
//  AttackUtility.swift
//  Haymaker2
//
//  Created by Mitchell Taitano on 4/20/22.
//

import Foundation

enum AttackType: String, CaseIterable, CustomStringConvertible {
    case Smashing
    case Piercing
    case Slashing
    case Knockback
    case Fire
    case Water
    case Lightning
    case Ice
    case Earth
    case Energy
    case Cosmic
    case Pure
    case Holy
    case Necrotic
    case Poison
    case Mental
    case Chaos
    case Arcane
    case Light
    case Dark
    case Force
    case Choose
    case Random
    case None
    
    var description: String {
        switch self {
        case .Smashing: return "Smashing"
        case .Piercing: return "Piercing"
        case .Slashing: return "Slashing"
        case .Knockback: return "Knockback"
        case .Fire: return "Fire"
        case .Water: return "Water"
        case .Lightning: return "Lightning"
        case .Ice: return "Ice"
        case .Earth: return "Earth"
        case .Energy: return "Energy"
        case .Cosmic: return "Cosmic"
        case .Pure: return "Pure"
        case .Holy: return "Holy"
        case .Necrotic: return "Necrotic"
        case .Poison: return "Poison"
        case .Mental: return "Mental"
        case .Chaos: return "Chaos"
        case .Arcane: return "Arcane"
        case .Light: return "Light"
        case .Dark: return "Dark"
        case .Force: return "Force"
        case .Choose: return "Choose"
        case .Random: return "Random"
        case .None: return "None"
        }
    }
    
    func getMagicTypes() -> [AttackType] {
        var MagicAttackTypes: [AttackType] = []
        MagicAttackTypes.append(.Fire)
        MagicAttackTypes.append(.Water)
        MagicAttackTypes.append(.Lightning)
        MagicAttackTypes.append(.Ice)
        MagicAttackTypes.append(.Earth)
        MagicAttackTypes.append(.Energy)
        MagicAttackTypes.append(.Cosmic)
        MagicAttackTypes.append(.Pure)
        MagicAttackTypes.append(.Holy)
        MagicAttackTypes.append(.Necrotic)
        MagicAttackTypes.append(.Poison)
        MagicAttackTypes.append(.Chaos)
        MagicAttackTypes.append(.Arcane)
        MagicAttackTypes.append(.Light)
        MagicAttackTypes.append(.Dark)
        MagicAttackTypes.append(.Force)
        return MagicAttackTypes
    }
    
    func getMagicStatusInfliction() -> ParagonStatus {
        switch self {
        case .Fire:
            return .Burning
        case .Water, .Ice, .Earth:
            return .Slowed
        case .Poison:
            return .Poisoned
        case .Light, .Dark, .Holy:
            return .Blind
        case .Necrotic:
            return .Bleeding
        case .Lightning:
            return .Stunned
        default:
            return .None
        }
    }
}

enum AttackClass: String {
    case Fighting
    case Sharpshooting
    case CombatMagic
    case None
}

enum AttackDistance: String {
    case Melee
    case Range
}

enum AttackMovementSpeedHinderance: String {
    case FullSpeed
    case ThreeFourSpeed
    case HalfSpeed
    case QuarterSpeed
    case ZeroSpeed
}

enum AttackMovementOccasion: String {
    case BeforeAttackOnly
    case AfterAttackOnly
    case BeforeOrAfterAttack
    case BeforeAndAfterAttack
    case Never
}

enum AOEType: String {
    case FromSelf
    case FromTarget
    case Chain
    case None
}

enum AttackBenefits: String {
    case Initiative
    case Damage
    case Defense
    case None
}

class AttackSet {
    
    var Attacks: [ParagonAttack] = []
    
    init() {
        Attacks = []
    }
    
    func getAttacks() -> [ParagonAttack] {
        return Attacks
    }
    
    func getAttackValueForAttack(Attack: Int) -> Int {
        return Attacks[Attack].AttackValue
    }
    
    func getDamageForAttack(Attack: Int) -> Int {
        return Attacks[Attack].AttackBaseDamage
    }
    
    func attackHasAttackPointsRemainingAt(Position: Int) -> Bool {
        return Attacks[Position].hasAttackPointsRemaining()
    }
    
    func spendAttackPointForAttackAt(Position: Int) {
        Attacks[Position].spendAttackPoint()
    }
    
    func prepareAttackSetForCombat() {
        for nextAttack in Attacks {
            nextAttack.prepareAttackForCombat()
        }
    }
    
    func setAttack(AtPosition: Int, Attack: ParagonAttack, ForParagon: Paragon) {
        Attack.completeAttackValuesForParagon(Paragon: ForParagon)
        Attacks[AtPosition] = Attack
    }
    
    
}

class ParagonAttack {
    
    var AttackID: String = ""
    var AttackParagonClass: String = ""
    var AttackName: String = ""
    var AttackClass: AttackClass = .Fighting
    var AttackDifficulty: Int = 0
    var AttackValue: Int = 0
    var AttackBaseDamage: Int = 0
    var AttackDamageDie: String = "0d0"
    var AttackBonusMeleeDefense: Int = 0
    var AttackBonusRangeDefense: Int = 0
    var AttackUsesPrimaryWeaponAttack: Bool = false
    var AttackEnergyCost: Int = 0
    var AttackPointsMAX: Int = 0
    var AttackPointsRemaining: Int = 0
    var UnlimitedAttackPoints: Bool = false
    var AttackTypes: [AttackType] = []
    var AttackDistance: AttackDistance = .Melee
    var AttackRangeMinumum: Double = 0
    var AttackRangeMaximum: Double = 0
    var AttackMovementDistance: Int = 0
    var AttackMovementSpeedHinderance: AttackMovementSpeedHinderance = .HalfSpeed
    var AttackMovementOccasion: AttackMovementOccasion = .BeforeOrAfterAttack
    var AttackBenefits: [AttackBenefits] = []
    var AttackSelfStatusInfliction: [ParagonStatus] = []
    var AttackSelfStatusInflictionTurns: [Int] = []
    var AttackStatusInfliction: [ParagonStatus] = []
    var AttackStatusInflictionTurns: [Int] = []
    var NumberOfAttacks: Int = 0
    var isAOE: Bool = false
    var AOEType: AOEType = .None
    var isUltimate: Bool = false
    var isPrimaryAttack: Bool = false
    
    var BuffAttack: Int = 0
    var BuffDamage: Int = 0
    var BuffMeleeDefense: Int = 0
    var BuffRangeDefense: Int = 0
    var BuffToughness: Int = 0
    var BuffWillpower: Int = 0
    
    var BuffAttackToSelf: Bool = true
    var BuffDamageToSelf: Bool = true
    var BuffMeleeDefenseToSelf: Bool = true
    var BuffRangeDefenseToSelf: Bool = true
    var BuffToughnessToSelf: Bool = true
    var BuffWillpowerToSelf: Bool = true
    
    var BuffIsForAlly: Bool = false
    var BuffIsAOE: Bool = false
    var BuffAOEType: AOEType = .None
    var BuffAOERange: Int = 0
    
    var DebuffAttack: Int = 0
    var DebuffDamage: Int = 0
    var DebuffMeleeDefense: Int = 0
    var DebuffRangeDefense: Int = 0
    var DebuffToughness: Int = 0
    var DebuffWillpower: Int = 0
    
    var DebuffAttackToSelf: Bool = true
    var DebuffDamageToSelf: Bool = true
    var DebuffMeleeDefenseToSelf: Bool = true
    var DebuffRangeDefenseToSelf: Bool = true
    var DebuffToughnessToSelf: Bool = true
    var DebuffWillpowerToSelf: Bool = true
    
    var DebuffIsForAlly: Bool = false
    var DebuffIsAOE: Bool = false
    var DebuffAOEType: AOEType = .None
    var DebuffAOERange: Int = 0
    
    init() {
        
    }
    
    init(AttackID: String, AttackParagonClass: String, AttackName: String, AttackClass: AttackClass, AttackDifficulty: Int, AttackValue: Int, AttackBaseDamage: Int, AttackDamageDie: String, BuffAttack: Int, BuffDamage: Int, BuffMeleeDefense: Int, BuffRangeDefense: Int, BuffToughness: Int, BuffWillpower: Int, BuffAttackToSelf: Bool, BuffDamageToSelf: Bool, BuffMeleeDefenseToSelf: Bool, BuffRangeDefenseToSelf: Bool, BuffToughnessToSelf: Bool, BuffWillpowerToSelf: Bool, BuffIsForAlly: Bool, BuffIsAOE: Bool, BuffAOEType: AOEType, BuffAOERange: Int, DebuffAttack: Int, DebuffDamage: Int, DebuffMeleeDefense: Int, DebuffRangeDefense: Int, DebuffToughness: Int, DebuffWillpower: Int, DebuffAttackToSelf: Bool, DebuffDamageToSelf: Bool, DebuffMeleeDefenseToSelf: Bool, DebuffRangeDefenseToSelf: Bool, DebuffToughnessToSelf: Bool, DebuffWillpowerToSelf: Bool, DebuffIsForAlly: Bool, DebuffIsAOE: Bool, DebuffAOEType: AOEType, DebuffAOERange: Int, AttackUsesPrimaryWeaponAttack: Bool, AttackEnergyCost: Int, AttackPoints: Int, UnlimitedAttackPoints: Bool, AttackTypes: [AttackType], AttackDistance: AttackDistance, AttackRangeMinimum: Double, AttackRangeMaximum: Double, AttackMovementSpeedHinderance: AttackMovementSpeedHinderance, AttackMovementOccasion: AttackMovementOccasion, AttackBenefits: [AttackBenefits], AttackSelfStatusInfliction: [ParagonStatus], AttackSelfStatusInflictionTurns: [Int], AttackStatusInfliction: [ParagonStatus], AttackStatusInflictionTurns: [Int], NumberOfAttacks: Int, isAOE: Bool, AOEType: AOEType, isUltimate: Bool, isPrimaryAttack: Bool) {
        self.AttackID = AttackID
        self.AttackParagonClass = AttackParagonClass
        self.AttackName = AttackName
        self.AttackClass = AttackClass
        self.AttackDifficulty = AttackDifficulty
        self.AttackValue = AttackValue
        self.AttackBaseDamage = AttackBaseDamage
        self.AttackDamageDie = AttackDamageDie
        self.BuffAttack = BuffAttack
        self.BuffDamage = BuffDamage
        self.BuffMeleeDefense = BuffMeleeDefense
        self.BuffRangeDefense = BuffRangeDefense
        self.BuffToughness = BuffToughness
        self.BuffWillpower = BuffWillpower
        self.BuffAttackToSelf = BuffAttackToSelf
        self.BuffDamageToSelf = BuffDamageToSelf
        self.BuffMeleeDefenseToSelf = BuffMeleeDefenseToSelf
        self.BuffRangeDefenseToSelf = BuffRangeDefenseToSelf
        self.BuffToughnessToSelf = BuffToughnessToSelf
        self.BuffWillpowerToSelf = BuffWillpowerToSelf
        self.BuffIsForAlly = BuffIsForAlly
        self.BuffIsAOE = BuffIsAOE
        self.BuffAOEType = BuffAOEType
        self.BuffAOERange = BuffAOERange
        self.DebuffAttack = DebuffAttack
        self.DebuffDamage = DebuffDamage
        self.DebuffMeleeDefense = DebuffMeleeDefense
        self.DebuffRangeDefense = DebuffRangeDefense
        self.DebuffToughness = DebuffToughness
        self.DebuffWillpower = DebuffWillpower
        self.DebuffAttackToSelf = DebuffAttackToSelf
        self.DebuffDamageToSelf = DebuffDamageToSelf
        self.DebuffMeleeDefenseToSelf = DebuffMeleeDefenseToSelf
        self.DebuffRangeDefenseToSelf = DebuffRangeDefenseToSelf
        self.DebuffToughnessToSelf = DebuffToughnessToSelf
        self.DebuffWillpowerToSelf = DebuffWillpowerToSelf
        self.DebuffIsForAlly = DebuffIsForAlly
        self.DebuffIsAOE = DebuffIsAOE
        self.DebuffAOEType = DebuffAOEType
        self.DebuffAOERange = BuffAOERange
        self.AttackUsesPrimaryWeaponAttack = AttackUsesPrimaryWeaponAttack
        self.AttackEnergyCost = AttackEnergyCost
        self.AttackPointsMAX = AttackPoints
        self.UnlimitedAttackPoints = UnlimitedAttackPoints
        self.AttackTypes = AttackTypes
        self.AttackDistance = AttackDistance
        self.AttackRangeMinumum = AttackRangeMinimum
        self.AttackRangeMaximum = AttackRangeMaximum
        self.AttackMovementSpeedHinderance = AttackMovementSpeedHinderance
        self.AttackMovementOccasion = AttackMovementOccasion
        self.AttackBenefits = AttackBenefits
        self.AttackSelfStatusInfliction = AttackSelfStatusInfliction
        self.AttackSelfStatusInflictionTurns = AttackSelfStatusInflictionTurns
        self.AttackStatusInfliction = AttackStatusInfliction
        self.AttackStatusInflictionTurns = AttackStatusInflictionTurns
        self.NumberOfAttacks = NumberOfAttacks
        self.isAOE = isAOE
        self.AOEType = AOEType
        self.isUltimate = isUltimate
        self.isPrimaryAttack = isPrimaryAttack
    }
    
    func prepareAttackForCombat() {
        self.AttackPointsRemaining = self.AttackPointsMAX
    }
    
    func spendAttackPoint() {
        self.AttackPointsRemaining -= 1
    }
    
    func setAttackPoints(ToValue: Int) {
        self.AttackPointsRemaining = ToValue
    }
    
    func modifyAttackPoints(ByValue: Int) {
        self.AttackPointsRemaining += ByValue
    }
    
    func hasAttackPointsRemaining() -> Bool {
        return self.AttackPointsRemaining > 0
    }
    
    func completeAttackValuesForParagon(Paragon: Paragon) {
        switch self.AttackClass {
        case .Fighting:
            self.AttackValue += (Paragon.ParagonTotalAttributes.Fighting - self.AttackDifficulty)
            self.AttackBaseDamage += (Paragon.ParagonTotalAttributes.Fighting / 2)
        case .Sharpshooting:
            self.AttackValue += (Paragon.ParagonTotalAttributes.Sharpshooting - self.AttackDifficulty)
            self.AttackBaseDamage += (Paragon.ParagonTotalAttributes.Sharpshooting / 2)
        case .CombatMagic:
            self.AttackValue += (Paragon.ParagonTotalAttributes.CombatMagic - self.AttackDifficulty)
            self.AttackBaseDamage += (Paragon.ParagonTotalAttributes.CombatMagic / 2)
        case .None:
            return
        }
        
        switch self.AttackMovementSpeedHinderance {
        case .FullSpeed:
            self.AttackMovementDistance = Paragon.ParagonTotalAttributes.Speed
        case .ThreeFourSpeed:
            self.AttackMovementDistance = (Paragon.ParagonTotalAttributes.Speed * 3) / 4
        case .HalfSpeed:
            self.AttackMovementDistance = (Paragon.ParagonTotalAttributes.Speed / 2)
        case .QuarterSpeed:
            self.AttackMovementDistance = (Paragon.ParagonTotalAttributes.Speed / 4)
        case .ZeroSpeed:
            self.AttackMovementDistance = 0
        }
    }
}
