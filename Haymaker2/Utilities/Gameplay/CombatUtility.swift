//
//  CombatUtility.swift
//  Haymaker2
//
//  Created by Mitchell Taitano on 8/9/22.
//

import Foundation
import UIKit

enum CurrentCombatantEnum {
    case FirstCombatant
    case SecondCombatant
}

protocol CombatProtocol {
    func moveParagonByProtocol(MoveDistance: Int)
    func restoreHealthToParagon(Combatant: Int, HealthAmount: Int)
    func restoreEnergyToParagon(Combatant: Int, EnergyAmount: Int)
    func restoreAttackPointsofAttacks(NumberOfAttacks: Int)
    func addBuffToCombatant(Combatant: Int, Buff: Buff)
}

class CombatOverseer: CombatProtocol {
    
    //MARK: - Variable Constants
    var MINIMUM_STARTING_POSISITION: Double = 0
    var MAXIMUM_STARTING_POSISITION: Double = 10
    var MINIMUM_COMBAT_DISTANCE: Double = 0
    
    //MARK: - Variables
    var FirstCombatants: [Paragon] = []
    var SecondCombatants: [Paragon] = []
    var ActiveCombatant: Paragon = Paragon(Name: "")
    var ActiveFirstCombatant: Int = 0
    var ActiveSecondCombatant: Int = 0
    
    var CombatDistance: Int = 0
    var FirstCombatantInitiative: Int = 0
    var SecondCombatantInitiative: Int = 0
    
    var StartingInitialCombatDistance: Int = 10
    var StraringSwapCombatDistance: Int = 10
    
    var CurrentCombatant: CurrentCombatantEnum = CurrentCombatantEnum.FirstCombatant
    var CombatantHasMoved: Bool = false
    
    
    //MARK: - Initialization Functions
    func InitializeCombatOverseer(InputFirstCombatants: [Paragon], InputSecondCombatants: [Paragon]) {
        InitializeCombatants(InputFirstCombatants: InputFirstCombatants, InputSecondCombatants: InputSecondCombatants)
        InitializeCombatDistance()
        InitializeInitiativeOrder()
    }
    
    func InitializeCombatants(InputFirstCombatants: [Paragon], InputSecondCombatants: [Paragon]) {
        FirstCombatants = InputFirstCombatants
        SecondCombatants = InputSecondCombatants
    }
    
    func InitializeCombatDistance() {
        
    }
    
    func InitializeInitiativeOrder() {
        let dieUtility = DiceUtility()
        var retryCount = 0
        FirstCombatantInitiative = 0
        SecondCombatantInitiative = 0
        while(FirstCombatantInitiative == SecondCombatantInitiative || retryCount < 10) {
            FirstCombatantInitiative = dieUtility.Roll_D20()
            SecondCombatantInitiative = dieUtility.Roll_D20()
            retryCount = retryCount + 1
        }
        if FirstCombatantInitiative >= SecondCombatantInitiative {
            ActiveCombatant = FirstCombatants[ActiveFirstCombatant]
            CurrentCombatant = .FirstCombatant
        } else {
            ActiveCombatant = SecondCombatants[ActiveSecondCombatant]
            CurrentCombatant = .SecondCombatant
        }
    }
    
    //MARK: - Get Functions
    func GetCurrentCombatant() -> Paragon {
        return CurrentCombatant == .FirstCombatant ? FirstCombatants[ActiveFirstCombatant] : SecondCombatants[ActiveSecondCombatant]
    }
    
    func GetCombatant(IsFirstCombatant: Bool, CombatantToReturn: Int) -> Paragon {
        return IsFirstCombatant ? FirstCombatants[CombatantToReturn] : SecondCombatants[CombatantToReturn]
    }
    
    func GetCombatantTarget() -> Paragon {
        return CurrentCombatant == .FirstCombatant ? SecondCombatants[ActiveSecondCombatant] : FirstCombatants[ActiveFirstCombatant]
    }
    
    func GetDistanceBetweenCombatants(CombatantA: Int, CombatantB: Int) -> Int {
        return CombatDistance
    }
    
    //MARK: - Recovery Check Functions
    func CanPerformRecovery() -> Bool {
        return !ActiveCombatant.ParagonStatusManager.hasStatus(Status: .Winded)
    }
    
    
    //MARK: - Move Check Functions
    func CanPerformMove() -> Bool {
        return !CombatantHasMoved
    }
    
    
    //MARK: - Attack Check Functions
    func CanPerformAttack(AttackUsed: Int) -> Bool {
        return CanPerformAttack(AttackingCombatant: ActiveCombatant, AttackUsed: AttackUsed)
    }
    
    func CanPerformAttack(AttackingCombatant: Paragon, AttackUsed: Int) -> Bool {
        return CanPerformAttack(AttackingCombatant: AttackingCombatant, DefendingCombatant: GetCombatantTarget(), AttackUsed: AttackUsed)
    }
    
    func CanPerformAttack(AttackingCombatant: Paragon, DefendingCombatant: Paragon, AttackUsed: Int) -> Bool {
        let DistanceToTarget: Int = CombatDistance
        let AttackRangeMinimum: Int = AttackingCombatant.ParagonAttackSet.Attacks[AttackUsed].AttackRangeMinumum
        let AttackRangeMaximum: Int = AttackingCombatant.ParagonAttackSet.Attacks[AttackUsed].AttackRangeMaximum
        let WithinRange: Bool = AttackRangeMinimum <= DistanceToTarget && AttackRangeMaximum >= DistanceToTarget
        let HasAttackPointsRemaining: Bool = AttackingCombatant.ParagonAttackSet.Attacks[AttackUsed].hasAttackPointsRemaining()
        let AttackEnergyCost: Int = AttackingCombatant.ParagonAttackSet.Attacks[AttackUsed].AttackEnergyCost
        let ParagonEnergy: Int = AttackingCombatant.ParagonCombatAttributes.Energy
        let HasEnoughEnergy: Bool = ParagonEnergy >= AttackEnergyCost
        
        return WithinRange && HasAttackPointsRemaining && HasEnoughEnergy
    }
    
    func WhyCannotPerformAttack(AttackingCombatant: Paragon, DefendingCombatant: Paragon, AttackUsed: Int) -> String {
        let DistanceToTarget: Int = CombatDistance
        let AttackRangeMinimum: Int = AttackingCombatant.ParagonAttackSet.Attacks[AttackUsed].AttackRangeMinumum
        let AttackRangeMaximum: Int = AttackingCombatant.ParagonAttackSet.Attacks[AttackUsed].AttackRangeMaximum
        let WithinRange: Bool = AttackRangeMinimum <= DistanceToTarget && AttackRangeMaximum >= DistanceToTarget
        let HasAttackPointsRemaining: Bool = AttackingCombatant.ParagonAttackSet.Attacks[AttackUsed].hasAttackPointsRemaining()
        let AttackEnergyCost: Int = AttackingCombatant.ParagonAttackSet.Attacks[AttackUsed].AttackEnergyCost
        let ParagonEnergy: Int = AttackingCombatant.ParagonCombatAttributes.Energy
        let HasEnoughEnergy: Bool = ParagonEnergy >= AttackEnergyCost
        
        if !WithinRange {
            return "Out of range of target"
        }
        if !HasAttackPointsRemaining {
            return "Not enough Attack Points"
        }
        if !HasEnoughEnergy {
            return "Not enough Energy"
        }
        return ""
    }
    
    
    //MARK: - Perform Action Functions
    func PerformMove(MoveDistance: Int) {
        CombatantHasMoved = true
        MoveCombatant(DistanceToMove: MoveDistance)
    }
    
    func PerformOpponentMove(MoveDistance: Int) {
        MoveCombatant(DistanceToMove: MoveDistance)
    }
    
    func PerformAttack(AttackingCombatant: Paragon, AttackUsed: Int) {
        PerformAttack(AttackingCombatant: AttackingCombatant, DefendingCombatant: GetCombatantTarget(), AttackUsed: AttackUsed)
    }
    
    func PerformAttack(AttackingCombatant: Paragon, DefendingCombatant: Paragon, AttackUsed: Int) {
        let DiceUtility = DiceUtility()
        
        var AttackValue: Int = AttackingCombatant.getAttackValueForAttack(AttackUsed: AttackUsed) + DiceUtility.Roll_D20()
        var DefenseValue: Int = 0
        if !DefendingCombatant.ParagonStatusManager.hasStatus(Status: .Defenseless){
            if AttackingCombatant.ParagonAttackSet.Attacks[AttackUsed].AttackDistance == .Melee {
                if DefendingCombatant.ParagonStatusManager.ImmuneToMeleeAttacks || DefendingCombatant.ParagonStatusManager.ImmuneToMeleeAttacksTemporary {
                    DefenseValue = AttackValue + 1
                } else {
                    DefenseValue = DefendingCombatant.getMeleeDefense() + DiceUtility.Roll_D20()
                }
            } else if AttackingCombatant.ParagonAttackSet.Attacks[AttackUsed].AttackDistance == .Range {
                if DefendingCombatant.ParagonStatusManager.ImmuneToRangedAttacks || DefendingCombatant.ParagonStatusManager.ImmuneToRangedAttacksTemporary {
                    DefenseValue = AttackValue + 1
                } else {
                    DefenseValue = DefendingCombatant.getRangeDefense() + DiceUtility.Roll_D20()
                }
            }
            if AttackingCombatant.ParagonAttackSet.Attacks[AttackUsed].AttackTypes.contains(.Mental) && DefendingCombatant.ParagonStatusManager.ImmuneToMentalAttacks || DefendingCombatant.ParagonStatusManager.ImmuneToMentalAttacksTemporary {
                DefenseValue = AttackValue + 1
            }
        } else {
            AttackValue = DefenseValue + 1
        }
        
        let AttackSuccess = AttackValue >= DefenseValue
        if AttackSuccess {
            CalculateAndInflictAttackDamage(AttackingCombatant: AttackingCombatant, DefendingCombatant: DefendingCombatant, AttackUsed: AttackUsed)
        } else if DefendingCombatant.ParagonStatusManager.hasStatus(Status: .Counterattacking) {
            let CounterAttackDamage = GetLowestDamageValueForParagonCounterAttack(Paragon: DefendingCombatant)
            InflictDamageFromCombatant(AttackingCombatant: DefendingCombatant, DefendingCombatant: AttackingCombatant, DamageToInflict: CounterAttackDamage)
        }
    }
    
    func CalculateAndInflictAttackDamage(AttackingCombatant: Paragon, DefendingCombatant: Paragon, AttackUsed: Int) {
        let DiceUtility = DiceUtility()
        
        DefendingCombatant.ParagonStatusManager.ReceivedDamageSinceLastTurn = true
        let BaseDamage = AttackingCombatant.getTotalBaseDamageForAttack(AttackUsed: AttackUsed)
        let DamageRoll = DiceUtility.Roll_DNUM(DieToRoll: AttackingCombatant.ParagonAttackSet.Attacks[AttackUsed].AttackDamageDie)
        let TotalDamageRoll = BaseDamage + DamageRoll
        let DefenderDamageResistance = DefendingCombatant.getDamageResistance()
        let FinalDamage = TotalDamageRoll - DefenderDamageResistance
        
        InflictDamageFromCombatant(AttackingCombatant: AttackingCombatant, DefendingCombatant: DefendingCombatant, DamageToInflict: FinalDamage)
    }
    
    func InflictDamageFromCombatant(AttackingCombatant: Paragon, DefendingCombatant: Paragon, DamageToInflict: Int) {
        InflictDamage(DefendingCombatant: DefendingCombatant, DamageToInflict: DamageToInflict)
    }
    
    func InflictDamage(DefendingCombatant: Paragon, DamageToInflict: Int) {
        let DiceUtility = DiceUtility()
        
        DefendingCombatant.ParagonCombatAttributes.Health -= DamageToInflict
        if DefendingCombatant.ParagonCombatAttributes.Health <= 0 {
            let OverDamage = 0 - DefendingCombatant.ParagonCombatAttributes.Health
            let WillpowerSaveValue = 10 + (2 * DefendingCombatant.ParagonStatusManager.UnconsciousCounter) + OverDamage
            let WillpowerSaveAttemptValue = DefendingCombatant.ParagonCombatAttributes.Willpower + DefendingCombatant.ParagonTemporaryAttributes.Willpower + DiceUtility.Roll_D20()
            if WillpowerSaveAttemptValue > WillpowerSaveValue {
                DefendingCombatant.ParagonCombatAttributes.Health = 1
                DefendingCombatant.ParagonStatusManager.UnconsciousCounter += 1
            } else {
                DefendingCombatant.ParagonCombatAttributes.Health = 0
                DefendingCombatant.ParagonStatusManager.setStatus(Status: .Unconscious, NumberOfTurns: 0, SelfInflicted: false)
            }
        }
    }
    
    func PerformRecovery() {
        PerformExtendedRecovery()
    }
    
    func PerformExtendedRecovery() {
        RestoreHealth(CombatantToHeal: ActiveCombatant, HealthToRestore: ActiveCombatant.ParagonCombatAttributes.HealthRecovery)
        RestoreEnergy(EnergyToRestore: ActiveCombatant.ParagonCombatAttributes.EnergyRecovery)
    }
    
    func PerformExtendedRecovery(Combatant: Paragon) {
        Combatant.ParagonCombatAttributes.Health += Combatant.ParagonCombatAttributes.HealthRecovery
        if Combatant.ParagonCombatAttributes.Health >= Combatant.ParagonTotalAttributes.Health {
            Combatant.ParagonCombatAttributes.Health = Combatant.ParagonTotalAttributes.Health
        }
        Combatant.ParagonCombatAttributes.Energy += Combatant.ParagonCombatAttributes.EnergyRecovery
        if Combatant.ParagonCombatAttributes.Energy >= Combatant.ParagonTotalAttributes.Energy {
            Combatant.ParagonCombatAttributes.Energy = Combatant.ParagonTotalAttributes.Energy
        }
    }
    
    
    //MARK: - Health and Energy Manipulation Functions
    func SpendEnergy(EnergyToSpend: Int) {
        ModifyEnergy(CombatantToModify: ActiveCombatant, Energy: (-1 * EnergyToSpend))
    }
    
    func SpendEnergyForCombatant(Combatant: Paragon, EnergyToSpend: Int) {
        ModifyEnergy(CombatantToModify: Combatant, Energy: (-1 * EnergyToSpend))
    }
    
    func RestoreEnergy(EnergyToRestore: Int) {
        ModifyEnergy(CombatantToModify: ActiveCombatant, Energy: EnergyToRestore)
    }
    
    func RestoreEnergyForCombatant(Combatant: Paragon, EnergyToRestore: Int) {
        ModifyEnergy(CombatantToModify: Combatant, Energy: EnergyToRestore)
    }
    
    func ModifyEnergy(CombatantToModify: Paragon, Energy: Int) {
        CombatantToModify.ParagonCombatAttributes.Energy += Energy
        if CombatantToModify.ParagonCombatAttributes.Energy >= CombatantToModify.ParagonTotalAttributes.Energy {
            CombatantToModify.ParagonCombatAttributes.Energy = CombatantToModify.ParagonTotalAttributes.Energy
        }
        if CombatantToModify.ParagonCombatAttributes.Energy < 0 {
            CombatantToModify.ParagonCombatAttributes.Energy = 0
        }
    }
    
    func SetEnergy(CombatantToSet: Paragon, EnergyValue: Int) {
        CombatantToSet.ParagonCombatAttributes.Energy = EnergyValue
    }
    
    func RestoreHealth(CombatantToHeal: Paragon, HealthToRestore: Int) {
        CombatantToHeal.ParagonCombatAttributes.Health += HealthToRestore
        if CombatantToHeal.ParagonCombatAttributes.Health >= CombatantToHeal.ParagonTotalAttributes.Health {
            CombatantToHeal.ParagonCombatAttributes.Health = CombatantToHeal.ParagonTotalAttributes.Health
        }
    }
    
    
    //MARK: - Attack Point Manipulation Functions
    func DecrementAttackPointsForAttack(Attack: Int) {
        ModifyAttackPointsForAttack(Attack: Attack, Value: -1)
    }
    
    func SetAttackPointsForAttack(Attack: Int, Value: Int) {
        ActiveCombatant.ParagonAttackSet.Attacks[Attack].setAttackPoints(ToValue: Value)
    }
    
    func ModifyAttackPointsForAttack(Attack: Int, Value: Int) {
        ActiveCombatant.ParagonAttackSet.Attacks[Attack].modifyAttackPoints(ByValue: Value)
    }
    
    
    //MARK: - Start Turn Functions
    func BeginParagonTurn() {
        ActiveCombatant.functionsForStartOfTurn()
        CombatantHasMoved = false
    }
    
    
    //MARK: - End Turn Functions
    func CompleteParagonTurn() {
        ActiveCombatant.functionsForEndOfTurn()
    }
    
    func PassTurnToNextCombatant() {
        CurrentCombatant = CurrentCombatant == .FirstCombatant ? .SecondCombatant : .FirstCombatant
        ActiveCombatant = CurrentCombatant == .FirstCombatant ? FirstCombatants[ActiveFirstCombatant] : SecondCombatants[ActiveSecondCombatant]
    }
    
    
    //MARK: - Utility Functions
    func MoveCombatant(DistanceToMove: Int) {
        if DistanceToMove >= CombatDistance {
            CombatDistance = 0
        } else {
            if DistanceToMove < 0 {
                CombatDistance = CombatDistance - DistanceToMove
            } else {
                CombatDistance = CombatDistance + DistanceToMove
            }
        }
    }
    
    func AddCombatant(ParagonToAdd: Paragon, AddToFirstCombatants: Bool) {
        if AddToFirstCombatants {
            FirstCombatants.append(ParagonToAdd)
        } else {
            SecondCombatants.append(ParagonToAdd)
        }
    }
    
    func GetLowestDamageValueForParagonCounterAttack(Paragon: Paragon) -> Int {
        let DiceUtility = DiceUtility()
        var LowestDamage = 9999
        for nextAttack in Paragon.ParagonAttackSet.Attacks {
            let nextDamage = nextAttack.AttackBaseDamage + DiceUtility.Roll_DNUM(DieToRoll: nextAttack.AttackDamageDie)
            if nextDamage < LowestDamage {
                LowestDamage = nextDamage
            }
        }
        return LowestDamage
    }
    
    
    //MARK: - Buff Debuff Functions
    
    
    
    //MARK: - Protocol Functions
    func moveParagonByProtocol(MoveDistance: Int) {
        MoveCombatant(DistanceToMove: MoveDistance)
    }
    
    func restoreHealthToParagon(Combatant: Int, HealthAmount: Int) {
        if CurrentCombatant == .FirstCombatant {
            FirstCombatants[Combatant].addHealth(Amount: HealthAmount)
        } else {
            SecondCombatants[Combatant].addHealth(Amount: HealthAmount)
        }
    }
    
    func restoreEnergyToParagon(Combatant: Int, EnergyAmount: Int) {
        if CurrentCombatant == .FirstCombatant {
            FirstCombatants[Combatant].addEnergy(Amount: EnergyAmount)
        } else {
            SecondCombatants[Combatant].addEnergy(Amount: EnergyAmount)
        }
    }
    
    func restoreAttackPointsofAttacks(NumberOfAttacks: Int) {
        
    }
    
    func addBuffToCombatant(Combatant: Int, Buff: Buff) {
        if CurrentCombatant == .FirstCombatant {
            FirstCombatants[Combatant].addBuffToBuffs(BuffToAdd: Buff)
        } else {
            SecondCombatants[Combatant].addBuffToBuffs(BuffToAdd: Buff)
        }
    }
}
