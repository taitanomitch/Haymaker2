//
//  StatusUtility.swift
//  Haymaker2
//
//  Created by Mitchell Taitano on 8/13/22.
//

import Foundation

enum ParagonStatus: String {
    case Normal //Healthy
    case Unconscious //Knocked out in combat
    case Stunned //Attacks cost *2 Energy to perform
    case Burning //Take 1 Fire Type Damage at end of turn
    case Hurt //?
    case Prone //Movement Speed is 0
    case Defenseless //Make no defense roll. Automatically hit
    case WeaknessExploited //Melee and Range Defense is 1 and cannot be increased
    case Slowed //Movement is 50%
    case Held //Cannot Move
    case Petrified //Turned to stone. Cannot act.
    case Sleeping //Asleep. Cannot act.
    case Bleeding //Take 1 Pure Type Damage at end of turn
    case Poisoned //Take 1 Poison Type Damage at end of turn
    case Blind //
    case Winded //Skip Recovery Step of turn
    case Cursed //?
    case Counterattacking //Whenever an attack is dodged, deal Base Damage + Damage Die back to the attacker (ONLY if Primary Weapon is in range)
    case Healed //?
    case Restored //?
    case Revived //?
    case DivinlyBlessed //Super Buff to stats
    case Blessed //Buff to stats
    case Guided //Buff to Attack
    case ImmuneToMeleeAttacks
    case ImmuneToRangeAttacks
    case ImmuneToMentalAttacks
    case FireMagicShield //Deal 1 Fire Damage to any character successfully attacking or being attacked by you
    case WaterMagicShield
    case LightningMagicShield
    case IceMagicShield
    case EarthMagicShield
    case NatureMagicShield
    case EnergyMagicShield
    case CosmicMagicShield
    case HolyMagicShield
    case NecroticMagicShield
    case PoisonMagicShield
    case ChaosMagicShield
    case ArcaneMagicShield
    case LightMagicShield
    case DarkMagicShield
    case ForceMagicShield
    case TemporalMagicShield
    case SonicMagicShield
    case None
}

class StatusManager {
    
    var StatusList: [ParagonStatus] = [.Normal]
    var StatusCounter: [Int] = [0]
    var StatusSelfInflicted: [Bool] = [false]
    
    var ReceivedDamageSinceLastTurn: Bool = false
    var UnconsciousCounter: Int = 0
    
    var ImmuneToMeleeAttacks: Bool = false
    var ImmuneToMeleeAttacksTemporary: Bool = false
    var ImmuneToRangedAttacks: Bool = false
    var ImmuneToRangedAttacksTemporary: Bool = false
    var ImmuneToMentalAttacks: Bool = false
    var ImmuneToMentalAttacksTemporary: Bool = false
    
    func setStatusToNormal() {
        StatusList = [.Normal]
        StatusCounter = [0]
    }
    
    func resurrectParagon() {
        if StatusList.contains(.Unconscious) {
            setStatusToNormal()
        }
    }
    
    func hasStatus(Status: ParagonStatus) -> Bool {
        return StatusList.contains(Status)
    }
    
    func setStatus(Status: ParagonStatus, NumberOfTurns: Int, SelfInflicted: Bool) {
        if !StatusList.contains(.Unconscious) {
            if StatusList.contains(.Normal) {
                StatusList = [Status]
                StatusCounter = [NumberOfTurns]
                StatusSelfInflicted = [SelfInflicted]
            } else {
                if StatusList.contains(Status) {
                    for i in 0..<StatusList.count {
                        if StatusList[i] == Status {
                            StatusCounter[i] = StatusCounter[i] + NumberOfTurns
                        }
                    }
                } else {
                    StatusList.append(Status)
                    StatusCounter.append(NumberOfTurns)
                    StatusSelfInflicted.append(SelfInflicted)
                }
            }
        }
    }
    
    func decrementStatusCounters() {
        if !StatusList.contains(.Normal) && !StatusList.contains(.Unconscious) {
            for i in 0..<StatusCounter.count {
                StatusCounter[i] = StatusCounter[i] - 1
                if StatusCounter[i] <= 0 {
                    StatusCounter[i] = 0
                }
            }
            for i in (StatusCounter.count - 1)...0 {
                if StatusCounter[i] <= 0 {
                    StatusCounter.remove(at: i)
                    StatusList.remove(at: i)
                }
            }
            if StatusList.count == 0 {
                StatusList = [.Normal]
                StatusCounter = [0]
            }
        }
    }
    
    func decrementStatusCounters(SelfInflicted: Bool) {
        if !StatusList.contains(.Normal) && !StatusList.contains(.Unconscious) {
            for i in 0..<StatusCounter.count {
                if StatusSelfInflicted[i] == SelfInflicted {
                    StatusCounter[i] = StatusCounter[i] - 1
                    if StatusCounter[i] <= 0 {
                        StatusCounter[i] = 0
                    }
                }
            }
            for i in (StatusCounter.count - 1)...0 {
                if StatusCounter[i] <= 0 {
                    StatusCounter.remove(at: i)
                    StatusList.remove(at: i)
                }
            }
            if StatusList.count == 0 {
                StatusList = [.Normal]
                StatusCounter = [0]
            }
        }
    }
    
    func resetStatusManagerForCombatStartOrEnd() {
        StatusList = [.Normal]
        StatusCounter = [0]
        
        ReceivedDamageSinceLastTurn = false
        UnconsciousCounter = 0
        
        ImmuneToRangedAttacks = false
        ImmuneToRangedAttacksTemporary = false
        ImmuneToMeleeAttacks = false
        ImmuneToMeleeAttacksTemporary = false
        ImmuneToMentalAttacks = false
        ImmuneToMentalAttacksTemporary = false
    }
}
