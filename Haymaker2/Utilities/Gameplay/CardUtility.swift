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
    case SetEnergy
    case Move
    case Buff
    case BuffSetValues
    case Status
    case None
}

enum CardTarget: String {
    case TargetSelf
    case TargetTarget
    case Both
    case AOEFromSelf
    case AOEFromTarget
    case None
}

enum MoveDirection: String {
    case Toward
    case Away
    case None
}


enum ValueType: String {
    case Number
    case Percent
    case Speed
    case None
}

enum CardBuffType: String {
    case Attack
    case Damage
    case Speed
    case HealthRecovery
    case EnergyRecovery
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
    
    var CardID: String
    var CardImageString: String
    var CardName: String
    var CardEffect: CardEffect
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
        self.CardEffect = .None
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
    

    init(CardID: String, CardImageString: String, CardName: String, CardEffect: CardEffect, CardTarget: CardTarget, CardBuffTypes: [CardBuffType], CardStatusToSelf: [ParagonStatus], CardStatusToSelfTurns: [Int], CardStatusToTarget: [ParagonStatus], CardStatusToTargetTurns: [Int], CardMoveDirection: MoveDirection, CardValue: Int, CardValueType: ValueType, CardMinimumRange: Int, CardMaximumRange: Int, CardEffectTextString: String) {
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
    
    func PlayCard(AttackingParagon: Paragon, DefendingParagon: Paragon) {
        
    }
}
