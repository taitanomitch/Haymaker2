//
//  CardUtility.swift
//  Haymaker2
//
//  Created by Mitchell Taitano on 8/12/22.
//

import Foundation

enum CardEffect: String {
    case CardDraw
    case RestoreEnergy
    case RestoreHealth
    case RestoreAttackPoints
    case Move
    case Buff
    case Status
    case None
}

enum CardTarget: String {
    case TargetSelf
    case TargetTarget
    case None
}

enum MoveDirection: String {
    case TowardTarget
    case TowardAttacker
    case AwayFromTarget
    case AwayFromAttacker
    case None
}


enum ValueType: String {
    case Number
    case Percent
    case Speed
    case None
}

enum CardBuffType: String {
    case Health
    case Energy
    case Speed
    case HealthRecovery
    case EnergyRecovery
    case Attack
    case Damage
    case Fighting
    case Sharpshooting
    case CombatMagic
    case MeleeDefense
    case RangeDefense
    case Toughness
    case Willpower
    case None
}

class ParagonCard {
    
    var CardCombatProtocol: CombatProtocol?
    
    var CardID: String
    var CardImageString: String
    var CardName: String
    var CardEffect: [CardEffect]
    var CardTarget: CardTarget
    var CardBuffType: [CardBuffType]
    var CardStatusToSelf: [ParagonStatus]
    var CardStatusToSelfTurns: [Int]
    var CardStatusToTarget: [ParagonStatus]
    var CardStatusToTargetTurns: [Int]
    var CardMoveDirection: MoveDirection
    var CardValue: Int
    var CardValueType: ValueType
    var CardMinimumRange: Int
    var CardMaximumRange: Int
    var CardEffectTextString: String
    
    init() {
        self.CardID = ""
        self.CardImageString = ""
        self.CardName = ""
        self.CardEffect = []
        self.CardTarget = .None
        self.CardBuffType = []
        self.CardStatusToSelf = []
        self.CardStatusToSelfTurns = []
        self.CardStatusToTarget = []
        self.CardStatusToTargetTurns = []
        self.CardMoveDirection = .None
        self.CardValue = 0
        self.CardValueType = .None
        self.CardMinimumRange = 0
        self.CardMaximumRange = 0
        self.CardEffectTextString = ""
    }
    

    init(CardID: String, CardImageString: String, CardName: String, CardEffect: [CardEffect], CardTarget: CardTarget, CardBuffTypes: [CardBuffType], CardStatusToSelf: [ParagonStatus], CardStatusToSelfTurns: [Int], CardStatusToTarget: [ParagonStatus], CardStatusToTargetTurns: [Int], CardMoveDirection: MoveDirection, CardValue: Int, CardValueType: ValueType, CardMinimumRange: Int, CardMaximumRange: Int, CardEffectTextString: String) {
        self.CardID = CardID
        self.CardImageString = CardImageString
        self.CardName = CardName
        self.CardEffect = CardEffect
        self.CardTarget = CardTarget
        self.CardBuffType = CardBuffTypes
        self.CardStatusToSelf = CardStatusToSelf
        self.CardStatusToSelfTurns = CardStatusToSelfTurns
        self.CardStatusToTarget = CardStatusToTarget
        self.CardStatusToTargetTurns = CardStatusToTargetTurns
        self.CardMoveDirection = CardMoveDirection
        self.CardValue = CardValue
        self.CardValueType = CardValueType
        self.CardMinimumRange = CardMinimumRange
        self.CardMaximumRange = CardMaximumRange
        self.CardEffectTextString = CardEffectTextString
    }
    
    func PlayCard(AttackingParagon: Paragon, AttackingCombatant: Int, DefendingParagon: Paragon, DefendingCombatant: Int) {
        for i in 0..<CardEffect.count {
            switch  CardEffect[i] {
            case .CardDraw:
                return
            case .RestoreEnergy:
                var CombatantToRestoreEnergy: Int = -1
                var CombatantMaxEnergy: Int = -1
                if CardTarget == .TargetSelf {
                    CombatantToRestoreEnergy = AttackingCombatant
                    CombatantMaxEnergy = AttackingParagon.MaxEnergy
                } else if CardTarget == .TargetTarget {
                    CombatantToRestoreEnergy = DefendingCombatant
                    CombatantMaxEnergy = DefendingParagon.MaxEnergy
                }
                var AmountToRestore: Int = 0
                if CardValueType == .Percent {
                    AmountToRestore = (CombatantMaxEnergy * CardValue) / 100
                } else {
                    AmountToRestore = CardValue
                }
                CardCombatProtocol?.restoreEnergyToParagon(Combatant: CombatantToRestoreEnergy, EnergyAmount: AmountToRestore)
            case .RestoreHealth:
                var CombatantToRestoreHealth: Int = -1
                var CombatantMaxHealth: Int = -1
                if CardTarget == .TargetSelf {
                    CombatantToRestoreHealth = AttackingCombatant
                    CombatantMaxHealth = AttackingParagon.MaxHealth
                } else if CardTarget == .TargetTarget {
                    CombatantToRestoreHealth = DefendingCombatant
                    CombatantMaxHealth = DefendingParagon.MaxHealth
                }
                var AmountToRestore: Int = 0
                if CardValueType == .Percent {
                    AmountToRestore = (CombatantMaxHealth * CardValue) / 100
                } else {
                    AmountToRestore = CardValue
                }
                CardCombatProtocol?.restoreHealthToParagon(Combatant: CombatantToRestoreHealth, HealthAmount: AmountToRestore)
            case .RestoreAttackPoints:
                CardCombatProtocol?.restoreAttackPointsofAttacks(NumberOfAttacks: CardValue)
            case .Move:
                var DistanceToMove: Int = 0
                if CardValueType == .Number {
                    DistanceToMove = CardValue
                } else if CardValueType == .Speed {
                    DistanceToMove = AttackingParagon.getSpeed()
                }
                CardCombatProtocol?.moveParagonByProtocol(MoveDistance: DistanceToMove)
            case .Buff:
                let BuffAttributes: AttributesManager = AttributesManager()
                for i in 0..<CardBuffType.count {
                    switch CardBuffType[i] {
                    case .Health:
                        BuffAttributes.Health += CardValue
                    case .Energy:
                        BuffAttributes.Energy += CardValue
                    case .Speed:
                        BuffAttributes.Speed += CardValue
                    case .HealthRecovery:
                        BuffAttributes.HealthRecovery += CardValue
                    case .EnergyRecovery:
                        BuffAttributes.EnergyRecovery += CardValue
                    case .Attack:
                        BuffAttributes.Attack += CardValue
                    case .Damage:
                        BuffAttributes.Damage += CardValue
                    case .Fighting:
                        BuffAttributes.Fighting += CardValue
                    case .Sharpshooting:
                        BuffAttributes.Sharpshooting += CardValue
                    case .CombatMagic:
                        BuffAttributes.CombatMagic += CardValue
                    case .MeleeDefense:
                        BuffAttributes.MeleeDefense += CardValue
                    case .RangeDefense:
                        BuffAttributes.RangeDefense += CardValue
                    case .Toughness:
                        BuffAttributes.Toughness += CardValue
                    case .Willpower:
                        BuffAttributes.Willpower += CardValue
                    case .None:
                        continue
                    }
                }
                let Buff: Buff = Buff(BuffName: CardName, BuffTurns: 1, BuffAttributes: BuffAttributes)
                if CardTarget == .TargetSelf {
                    CardCombatProtocol?.addBuffToCombatant(Combatant: AttackingCombatant, Buff: Buff)
                } else if CardTarget == .TargetTarget {
                    CardCombatProtocol?.addBuffToCombatant(Combatant: DefendingCombatant, Buff: Buff)
                }
            case .Status:
                for i in 0..<CardStatusToSelf.count {
                    AttackingParagon.setParagonStatus(Status: CardStatusToSelf[i], ForNumberOfTurns: CardStatusToSelfTurns[i], SelfInflicted: true)
                }
                for i in 0..<CardStatusToTarget.count {
                    AttackingParagon.setParagonStatus(Status: CardStatusToTarget[i], ForNumberOfTurns: CardStatusToTargetTurns[i], SelfInflicted: false)
                }
            case .None:
                return
            }
        }
    }
}
