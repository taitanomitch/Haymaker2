//
//  CombatUtility.swift
//  Haymaker2
//
//  Created by Mitchell Taitano on 8/9/22.
//

import Foundation
import UIKit

class CombatOverseer {
    
    //MARK: - Variable Constants
    var MINIMUM_STARTING_POSISITION: Double = 0
    var MAXIMUM_STARTING_POSISITION: Double = 10
    var MINIMUM_COMBAT_DISTANCE: Double = 0
    
    //MARK: - Variables
    var Combatants: [Paragon] = []
    var CombatantInitiativeRolls: [Int] = []
    var CombatantInitiativeOrder: [Int] = []
    var CombatantsCount: Int = 0
    var CurrentCombatant: Int = 0
    var CombatantTarget: [Int] = []
    var CombatantPositions: [[Double]] = [[]]
    var CombatDistances: [[Double]] = [[]]
    var CombatantAllies: [[Bool]] = [[]]
    var CombatantHasMoved: Bool = false
    var x: Int = 0
    var y: Int = 1
    
    
    //MARK: - Initialization Functions
    func InitializeCombatOverseer(InputCombatants: [Paragon]) {
        InitializeCombatants(InputCombatants: InputCombatants)
        InitializeCombatantStartingPositions()
        InitializeCombatDistances()
        InitializeCombatantTargets()
        InitializeCombatantAllies()
        InitializeInitiativeOrder()
    }
    
    func InitializeCombatants(InputCombatants: [Paragon]) {
        Combatants = InputCombatants
        CombatantsCount = Combatants.count
    }
    
    func InitializeCombatantAllies() {
        for i in 0..<CombatantsCount {
            var NewCombatantAllies: [Bool] = [Bool](repeating: false, count: CombatantsCount)
            NewCombatantAllies[i] = true
            CombatantAllies.append(NewCombatantAllies)
        }
    }
    
    func InitializeCombatantTargets() {
        for i in 0..<CombatantsCount {
            if i == CombatantsCount - 1 {
                CombatantTarget[i] = 0
            } else {
                CombatantTarget[i] = i + 1
            }
        }
    }
    
    func InitializeCombatDistances() {
        for i in 0..<CombatantsCount {
            for j in 0..<CombatantsCount {
                if i == j {
                    CombatDistances[i][j] = 0
                } else {
                    CombatDistances[i][j] = GetDistanceBetweenCombatants(CombatantA: i, CombatantB: j)
                    CombatDistances[j][i] = CombatDistances[i][j]
                }
            }
        }
    }
    
    func InitializeCombatantStartingPositions() {
        for i in 0..<Combatants.count {
            let newPosition: [Double] = [Double.random(in: MINIMUM_STARTING_POSISITION...MAXIMUM_STARTING_POSISITION).rounded(.down), Double.random(in: MINIMUM_STARTING_POSISITION...MAXIMUM_STARTING_POSISITION).rounded(.down)]
            CombatantPositions[i] = newPosition
        }
    }
    
    func InitializeInitiativeOrder() {
        let dieUtility = DiceUtility()
        for i in 0..<Combatants.count {
            CombatantInitiativeRolls[i] = Combatants[i].ParagonCombatAttributes.Initiative + Combatants[i].ParagonTemporaryAttributes.Initiative + dieUtility.Roll_D20()
        }
        var tempInitiativeRolls = CombatantInitiativeRolls
        for i in 0..<Combatants.count {
            var highestRoll: Int = -10
            var WinningCombatant: Int = -1
            for j in 0..<Combatants.count {
                if tempInitiativeRolls[j] > highestRoll {
                    highestRoll = tempInitiativeRolls[i]
                    WinningCombatant = j
                }
            }
            CombatantInitiativeOrder[i] = WinningCombatant
            tempInitiativeRolls[WinningCombatant] = -10
        }
    }
    
    //MARK: - Get Functions
    func GetCurrentCombatant() -> Paragon {
        return Combatants[CurrentCombatant]
    }
    
    func GetCombatant(CombatantToReturn: Int) -> Paragon {
        return Combatants[CombatantToReturn]
    }
    
    func GetCombatantTarget() -> Paragon {
        return Combatants[CombatantTarget[CurrentCombatant]]
    }
    
    func GetDistanceBetweenCombatants(CombatantA: Int, CombatantB: Int) -> Double {
        let xSquared: Double = pow((CombatantPositions[CombatantA][x] - CombatantPositions[CombatantB][x]), 2)
        let ySquared: Double = pow((CombatantPositions[CombatantA][y] - CombatantPositions[CombatantB][y]), 2)
        return (xSquared + ySquared).squareRoot()
    }

    func GetPrintableCombatDistanceBetweenCombatants(CombatantA: Int, CombatantB: Int) -> Double {
        return Double(round((CombatDistances[CombatantA][CombatantB]) * 100) / 100)
    }
    
    //MARK: - Recovery Check Functions
    func CanPerformRecovery() -> Bool {
        return !Combatants[CurrentCombatant].ParagonStatusManager.hasStatus(Status: .Winded)
    }
    
    
    //MARK: - Move Check Functions
    func CanPerformMove() -> Bool {
        return !CombatantHasMoved
    }
    
    
    //MARK: - Attack Check Functions
    func CanPerformAttack(AttackUsed: Int) -> Bool {
        return CanPerformAttack(AttackingCombatant: CurrentCombatant, AttackUsed: AttackUsed)
    }
    
    func CanPerformAttack(AttackingCombatant: Int, AttackUsed: Int) -> Bool {
        return CanPerformAttack(AttackingCombatant: AttackingCombatant, DefendingCombatant: CombatantTarget[AttackingCombatant], AttackUsed: AttackUsed)
    }
    
    func CanPerformAttack(AttackingCombatant: Int, DefendingCombatant: Int, AttackUsed: Int) -> Bool {
        let DistanceToTarget: Double = CombatDistances[AttackingCombatant][DefendingCombatant]
        let AttackRangeMinimum: Double = Combatants[AttackingCombatant].ParagonAttackSet.Attacks[AttackUsed].AttackRangeMinumum
        let AttackRangeMaximum: Double = Combatants[AttackingCombatant].ParagonAttackSet.Attacks[AttackUsed].AttackRangeMaximum
        let WithinRange: Bool = AttackRangeMinimum <= DistanceToTarget && AttackRangeMaximum >= DistanceToTarget
        let HasAttackPointsRemaining: Bool = Combatants[AttackingCombatant].ParagonAttackSet.Attacks[AttackUsed].hasAttackPointsRemaining()
        let AttackEnergyCost: Int = Combatants[AttackingCombatant].ParagonAttackSet.Attacks[AttackUsed].AttackEnergyCost
        let ParagonEnergy: Int = Combatants[AttackingCombatant].ParagonCombatAttributes.Energy
        let HasEnoughEnergy: Bool = ParagonEnergy >= AttackEnergyCost
        
        return WithinRange && HasAttackPointsRemaining && HasEnoughEnergy
    }
    
    func WhyCannotPerformAttack(AttackingCombatant: Int, DefendingCombatant: Int, AttackUsed: Int) -> String {
        let DistanceToTarget: Double = CombatDistances[AttackingCombatant][DefendingCombatant]
        let AttackRangeMinimum: Double = Combatants[AttackingCombatant].ParagonAttackSet.Attacks[AttackUsed].AttackRangeMinumum
        let AttackRangeMaximum: Double = Combatants[AttackingCombatant].ParagonAttackSet.Attacks[AttackUsed].AttackRangeMaximum
        let WithinRange: Bool = AttackRangeMinimum <= DistanceToTarget && AttackRangeMaximum >= DistanceToTarget
        let HasAttackPointsRemaining: Bool = Combatants[AttackingCombatant].ParagonAttackSet.Attacks[AttackUsed].hasAttackPointsRemaining()
        let AttackEnergyCost: Int = Combatants[AttackingCombatant].ParagonAttackSet.Attacks[AttackUsed].AttackEnergyCost
        let ParagonEnergy: Int = Combatants[AttackingCombatant].ParagonCombatAttributes.Energy
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
    func PerformMove(MoveDistance: Double) {
        CombatantHasMoved = true
        MoveCombatant(AttackingParagon: CurrentCombatant, DefendingParagon: CombatantTarget[CurrentCombatant], DistanceToMove: MoveDistance)
    }
    
    func PerformOpponentMove(MoveDistance: Double) {
        MoveCombatant(AttackingParagon: CombatantTarget[CurrentCombatant], DefendingParagon: CurrentCombatant, DistanceToMove: MoveDistance)
    }
    
    func PerformAttack(AttackingCombatant: Int, AttackUsed: Int) {
        PerformAttack(AttackingCombatant: AttackingCombatant, DefendingCombatant: CombatantTarget[AttackingCombatant], AttackUsed: AttackUsed)
    }
    
    func PerformAttack(AttackingCombatant: Int, DefendingCombatant: Int, AttackUsed: Int) {
        let DiceUtility = DiceUtility()
        
        var AttackValue: Int = Combatants[AttackingCombatant].getAttackValueForAttack(AttackUsed: AttackUsed) + DiceUtility.Roll_D20()
        var DefenseValue: Int = 0
        if !Combatants[DefendingCombatant].ParagonStatusManager.hasStatus(Status: .Defenseless){
            if Combatants[AttackingCombatant].ParagonAttackSet.Attacks[AttackUsed].AttackDistance == .Melee {
                if Combatants[DefendingCombatant].ParagonStatusManager.ImmuneToMeleeAttacks || Combatants[DefendingCombatant].ParagonStatusManager.ImmuneToMeleeAttacksTemporary {
                    DefenseValue = AttackValue + 1
                } else {
                    DefenseValue = Combatants[DefendingCombatant].getMeleeDefense() + DiceUtility.Roll_D20()
                }
            } else if Combatants[AttackingCombatant].ParagonAttackSet.Attacks[AttackUsed].AttackDistance == .Range {
                if Combatants[DefendingCombatant].ParagonStatusManager.ImmuneToRangedAttacks || Combatants[DefendingCombatant].ParagonStatusManager.ImmuneToRangedAttacksTemporary {
                    DefenseValue = AttackValue + 1
                } else {
                    DefenseValue = Combatants[DefendingCombatant].getRangeDefense() + DiceUtility.Roll_D20()
                }
            }
            if Combatants[AttackingCombatant].ParagonAttackSet.Attacks[AttackUsed].AttackTypes.contains(.Mental) && Combatants[DefendingCombatant].ParagonStatusManager.ImmuneToMentalAttacks || Combatants[DefendingCombatant].ParagonStatusManager.ImmuneToMentalAttacksTemporary {
                DefenseValue = AttackValue + 1
            }
        } else {
            AttackValue = DefenseValue + 1
        }
        
        let AttackSuccess = AttackValue >= DefenseValue
        if AttackSuccess {
            CalculateAndInflictAttackDamage(AttackingCombatant: AttackingCombatant, DefendingCombatant: DefendingCombatant, AttackUsed: AttackUsed)
        } else if Combatants[DefendingCombatant].ParagonStatusManager.hasStatus(Status: .Counterattacking) {
            let CounterAttackDamage = GetLowestDamageValueForParagonAttacks(Paragon: Combatants[DefendingCombatant])
            InflictDamageFromCombatant(AttackingCombatant: DefendingCombatant, DefendingCombatant: AttackingCombatant, DamageToInflict: CounterAttackDamage)
        }
    }
    
    func CalculateAndInflictAttackDamage(AttackingCombatant: Int, DefendingCombatant: Int, AttackUsed: Int) {
        let DiceUtility = DiceUtility()
        
        Combatants[DefendingCombatant].ParagonStatusManager.ReceivedDamageSinceLastTurn = true
        let BaseDamage = Combatants[AttackingCombatant].getTotalBaseDamageForAttack(AttackUsed: AttackUsed)
        let DamageRoll = DiceUtility.Roll_DNUM(DieToRoll: Combatants[AttackingCombatant].ParagonAttackSet.Attacks[AttackUsed].AttackDamageDie)
        let TotalDamageRoll = BaseDamage + DamageRoll
        let DefenderDamageResistance = Combatants[DefendingCombatant].getDamageResistance()
        let FinalDamage = TotalDamageRoll - DefenderDamageResistance
        
        InflictDamageFromCombatant(AttackingCombatant: AttackingCombatant, DefendingCombatant: DefendingCombatant, DamageToInflict: FinalDamage)
    }
    
    func InflictDamageFromCombatant(AttackingCombatant: Int, DefendingCombatant: Int, DamageToInflict: Int) {
        InflictDamage(DefendingCombatant: DefendingCombatant, DamageToInflict: DamageToInflict)
    }
    
    func InflictDamage(DefendingCombatant: Int, DamageToInflict: Int) {
        let DiceUtility = DiceUtility()
        
        Combatants[DefendingCombatant].ParagonCombatAttributes.Health -= DamageToInflict
        if Combatants[DefendingCombatant].ParagonCombatAttributes.Health <= 0 {
            let OverDamage = 0 - Combatants[DefendingCombatant].ParagonCombatAttributes.Health
            let WillpowerSaveValue = 10 + (2 * Combatants[DefendingCombatant].ParagonStatusManager.UnconsciousCounter) + OverDamage
            let WillpowerSaveAttemptValue = Combatants[DefendingCombatant].ParagonCombatAttributes.Willpower + Combatants[DefendingCombatant].ParagonTemporaryAttributes.Willpower + DiceUtility.Roll_D20()
            if WillpowerSaveAttemptValue > WillpowerSaveValue {
                Combatants[DefendingCombatant].ParagonCombatAttributes.Health = 1
                Combatants[DefendingCombatant].ParagonStatusManager.UnconsciousCounter += 1
            } else {
                Combatants[DefendingCombatant].ParagonCombatAttributes.Health = 0
                Combatants[DefendingCombatant].ParagonStatusManager.setStatus(Status: .Unconscious, NumberOfTurns: 0, SelfInflicted: false)
            }
        }
    }
    
    func PerformRecovery() {
        PerformExtendedRecovery()
    }
    
    func PerformExtendedRecovery() {
        RestoreHealth(HealthToRestore: Combatants[CurrentCombatant].ParagonCombatAttributes.HealthRecovery)
        RestoreEnergy(EnergyToRestore: Combatants[CurrentCombatant].ParagonCombatAttributes.EnergyRecovery)
    }
    
    func PerformExtendedRecovery(Combatant: Int) {
        Combatants[Combatant].ParagonCombatAttributes.Health += Combatants[Combatant].ParagonCombatAttributes.HealthRecovery
        if Combatants[Combatant].ParagonCombatAttributes.Health >= Combatants[Combatant].ParagonTotalAttributes.Health {
            Combatants[Combatant].ParagonCombatAttributes.Health = Combatants[Combatant].ParagonTotalAttributes.Health
        }
        Combatants[Combatant].ParagonCombatAttributes.Energy += Combatants[Combatant].ParagonCombatAttributes.EnergyRecovery
        if Combatants[Combatant].ParagonCombatAttributes.Energy >= Combatants[Combatant].ParagonTotalAttributes.Energy {
            Combatants[Combatant].ParagonCombatAttributes.Energy = Combatants[Combatant].ParagonTotalAttributes.Energy
        }
    }
    
    
    //MARK: - Health and Energy Manipulation Functions
    func SpendEnergy(EnergyToSpend: Int) {
        ModifyEnergy(Combatant: CurrentCombatant, Energy: (-1 * EnergyToSpend))
    }
    
    func SpendEnergyForCombatant(Combatant: Int, EnergyToSpend: Int) {
        ModifyEnergy(Combatant: Combatant, Energy: (-1 * EnergyToSpend))
    }
    
    func RestoreEnergy(EnergyToRestore: Int) {
        ModifyEnergy(Combatant: CurrentCombatant, Energy: EnergyToRestore)
    }
    
    func RestoreEnergyForCombatant(Combatant: Int, EnergyToRestore: Int) {
        ModifyEnergy(Combatant: Combatant, Energy: EnergyToRestore)
    }
    
    func ModifyEnergy(Combatant: Int, Energy: Int) {
        Combatants[Combatant].ParagonCombatAttributes.Energy += Energy
        if Combatants[Combatant].ParagonCombatAttributes.Energy >= Combatants[Combatant].ParagonTotalAttributes.Energy {
            Combatants[Combatant].ParagonCombatAttributes.Energy = Combatants[Combatant].ParagonTotalAttributes.Energy
        }
        if Combatants[Combatant].ParagonCombatAttributes.Energy < 0 {
            Combatants[Combatant].ParagonCombatAttributes.Energy = 0
        }
    }
    
    func SetEnergy(Combatant: Int, EnergyValue: Int) {
        Combatants[Combatant].ParagonCombatAttributes.Energy = EnergyValue
    }
    
    func RestoreHealth(HealthToRestore: Int) {
        Combatants[CurrentCombatant].ParagonCombatAttributes.Health += HealthToRestore
        if Combatants[CurrentCombatant].ParagonCombatAttributes.Health >= Combatants[CurrentCombatant].ParagonTotalAttributes.Health {
            Combatants[CurrentCombatant].ParagonCombatAttributes.Health = Combatants[CurrentCombatant].ParagonTotalAttributes.Health
        }
    }
    
    
    //MARK: - Attack Point Manipulation Functions
    func DecrementAttackPointsForAttack(Attack: Int) {
        ModifyAttackPointsForAttack(Attack: Attack, Value: -1)
    }
    
    func SetAttackPointsForAttack(Attack: Int, Value: Int) {
        Combatants[CurrentCombatant].ParagonAttackSet.Attacks[Attack].setAttackPoints(ToValue: Value)
    }
    
    func ModifyAttackPointsForAttack(Attack: Int, Value: Int) {
        Combatants[CurrentCombatant].ParagonAttackSet.Attacks[Attack].modifyAttackPoints(ByValue: Value)
    }
    
    
    //MARK: - Start Turn Functions
    func BeginParagonTurn() {
        Combatants[CurrentCombatant].functionsForStartOfTurn()
        CombatantHasMoved = false
    }
    
    
    //MARK: - End Turn Functions
    func CompleteParagonTurn() {
        Combatants[CurrentCombatant].functionsForEndOfTurn()
        PassTurnToNextCombatant()
    }
    
    func PassTurnToNextCombatant() {
        CurrentCombatant += 1
        if CurrentCombatant >= Combatants.count {
            CurrentCombatant = 0
        }
    }
    
    
    //MARK: - Utility Functions
    func MoveCombatant(AttackingParagon: Int, DefendingParagon: Int, DistanceToMove: Double) {
        if CombatDistances[AttackingParagon][DefendingParagon] <= DistanceToMove {
            CombatantPositions[AttackingParagon][x] = CombatantPositions[DefendingParagon][x]
            CombatantPositions[AttackingParagon][y] = CombatantPositions[DefendingParagon][y]
        } else if CombatantPositions[AttackingParagon][x] == CombatantPositions[DefendingParagon][x] && CombatantPositions[AttackingParagon][y] == CombatantPositions[DefendingParagon][y] {
            if CombatantPositions[AttackingParagon][x] < 0 {
                CombatantPositions[AttackingParagon][x] += DistanceToMove
            } else if CombatantPositions[AttackingParagon][y] < 0 {
                CombatantPositions[AttackingParagon][y] += DistanceToMove
            } else if CombatantPositions[AttackingParagon][x] > CombatantPositions[AttackingParagon][y] {
                if CombatantPositions[AttackingParagon][x] > DistanceToMove {
                    CombatantPositions[AttackingParagon][x] -= DistanceToMove
                } else {
                    CombatantPositions[AttackingParagon][x] += DistanceToMove
                }
            } else {
                if CombatantPositions[AttackingParagon][y] > DistanceToMove {
                    CombatantPositions[AttackingParagon][y] -= DistanceToMove
                } else {
                    CombatantPositions[AttackingParagon][y] += DistanceToMove
                }
            }
        } else if CombatantPositions[AttackingParagon][x] == CombatantPositions[DefendingParagon][x] {
            if CombatantPositions[AttackingParagon][y] > CombatantPositions[DefendingParagon][y] {
                if DistanceToMove > (CombatantPositions[AttackingParagon][y] - CombatantPositions[DefendingParagon][y]) {
                    CombatantPositions[AttackingParagon][y] = CombatantPositions[DefendingParagon][y]
                } else {
                    CombatantPositions[AttackingParagon][y] -= DistanceToMove
                }
            } else {
                if DistanceToMove > (CombatantPositions[DefendingParagon][y] - CombatantPositions[AttackingParagon][y]) {
                    CombatantPositions[AttackingParagon][y] = CombatantPositions[DefendingParagon][y]
                } else {
                    CombatantPositions[AttackingParagon][y] += DistanceToMove
                }
            }
        } else if CombatantPositions[AttackingParagon][y] == CombatantPositions[DefendingParagon][y] {
            if CombatantPositions[AttackingParagon][x] > CombatantPositions[DefendingParagon][x] {
                if DistanceToMove > (CombatantPositions[AttackingParagon][x] - CombatantPositions[DefendingParagon][x]) {
                    CombatantPositions[AttackingParagon][x] = CombatantPositions[DefendingParagon][x]
                } else {
                    CombatantPositions[AttackingParagon][x] -= DistanceToMove
                }
            } else {
                if DistanceToMove > (CombatantPositions[DefendingParagon][x] - CombatantPositions[AttackingParagon][x]) {
                    CombatantPositions[AttackingParagon][x] = CombatantPositions[DefendingParagon][x]
                } else {
                    CombatantPositions[AttackingParagon][x] += DistanceToMove
                }
            }
        } else {
            let xDistance: Double = (CombatantPositions[DefendingParagon][x] - CombatantPositions[AttackingParagon][x]).magnitude
            let yDistance: Double = (CombatantPositions[DefendingParagon][y] - CombatantPositions[AttackingParagon][y]).magnitude
            let hypotDistance: Double = CombatDistances[AttackingParagon][DefendingParagon]
            let newHypotDistance: Double = DistanceToMove
            let xShift: Double = ((hypotDistance - newHypotDistance) * xDistance) / hypotDistance
            let yShift: Double = ((hypotDistance - newHypotDistance) * yDistance) / hypotDistance
            if CombatantPositions[AttackingParagon][x] < CombatantPositions[DefendingParagon][x] {
                CombatantPositions[AttackingParagon][x] += xShift
            } else {
                CombatantPositions[AttackingParagon][x] -= xShift
            }
            
            if CombatantPositions[AttackingParagon][y] < CombatantPositions[DefendingParagon][y] {
                CombatantPositions[AttackingParagon][y] += yShift
            } else {
                CombatantPositions[AttackingParagon][y] -= yShift
            }
        }
        
        for i in 0..<CombatantsCount {
            if i == AttackingParagon {
                CombatDistances[i][i] = 0
            } else {
                CombatDistances[AttackingParagon][i] = GetDistanceBetweenCombatants(CombatantA: AttackingParagon, CombatantB: i)
                CombatDistances[i][AttackingParagon] = CombatDistances[AttackingParagon][i]
            }
        }
    }
    
    func AddCombatant(ParagonToAdd: Paragon) {
        Combatants.append(ParagonToAdd)
        CombatantsCount += 1
        let NewCombatant = (CombatantsCount - 1)
        
        let newPosition: [Double] = [Double.random(in: MINIMUM_STARTING_POSISITION...MAXIMUM_STARTING_POSISITION).rounded(.down), Double.random(in: MINIMUM_STARTING_POSISITION...MAXIMUM_STARTING_POSISITION).rounded(.down)]
        CombatantPositions.append(newPosition)
        
        for i in 0..<CombatantsCount {
            CombatDistances[i].append(GetDistanceBetweenCombatants(CombatantA: NewCombatant, CombatantB: i))
        }
        
        let NewCombatDistances: [Double] = [Double](repeating: 0, count: CombatantsCount)
        CombatDistances.append(NewCombatDistances)
        for i in 0..<CombatantsCount {
            if i == NewCombatant {
                CombatDistances[i][i] = 0
            } else {
                CombatDistances[NewCombatant][i] = CombatDistances[i][NewCombatant]
            }
        }
        
        CombatantTarget.append(0)
        AddCombatantToInitiativeOrder(ParagonToAdd: ParagonToAdd)
    }
    
    func AddCombatantWithAlly(ParagonToAdd: Paragon, Ally: Int) {
        Combatants.append(ParagonToAdd)
        CombatantsCount += 1
        let NewCombatant = (CombatantsCount - 1)
        
        CombatantPositions[NewCombatant][x] = CombatantPositions[Ally][x] + 1
        CombatantPositions[NewCombatant][y] = CombatantPositions[Ally][y]
        
        for i in 0..<CombatantsCount {
            if i != NewCombatant {
                CombatDistances[i].append(GetDistanceBetweenCombatants(CombatantA: NewCombatant, CombatantB: i))
            }
            if i == Ally {
                CombatantAllies[i].append(true)
            } else {
                CombatantAllies[i].append(CombatantAllies[Ally][i])
            }
        }
        
        let NewCombatDistances: [Double] = [Double](repeating: 0, count: CombatantsCount)
        CombatDistances.append(NewCombatDistances)
        for i in 0..<CombatantsCount {
            if i == NewCombatant {
                CombatDistances[i][i] = 0
            } else {
                CombatDistances[NewCombatant][i] = CombatDistances[i][NewCombatant]
            }
        }
        
        let NewCombatantAllies: [Bool] = CombatantAllies[Ally]
        CombatantAllies.append(NewCombatantAllies)
        
        CombatantTarget.append(CombatantTarget[Ally])
        AddCombatantToInitiativeOrder(ParagonToAdd: ParagonToAdd)
    }
    
    func AddCombatantToInitiativeOrder(ParagonToAdd: Paragon) {
        let dieUtility = DiceUtility()
        let newCombatant = Combatants.count - 1
        let InitiativeRoll = ParagonToAdd.ParagonCombatAttributes.Initiative + ParagonToAdd.ParagonTemporaryAttributes.Initiative + dieUtility.Roll_D20()
        
        var insertPosition = -1
        for i in 0..<CombatantInitiativeOrder.count {
            let nextRoll = CombatantInitiativeRolls[CombatantInitiativeOrder[i]]
            if nextRoll < InitiativeRoll {
                insertPosition = i
            }
        }
        if insertPosition == -1 {
            CombatantInitiativeOrder.append(newCombatant)
        } else {
            CombatantInitiativeOrder.insert(newCombatant, at: insertPosition)
        }
        CombatantInitiativeRolls.append(InitiativeRoll)
    }
    
    func IncrementCombatantTarget() {
        let InitialTarget: Int = CombatantTarget[CurrentCombatant]
        CombatantTarget[CurrentCombatant] += 1
        if CombatantTarget[CurrentCombatant] >= CombatantsCount {
            CombatantTarget[CurrentCombatant] = 0
        }
        while CombatantTarget[CurrentCombatant] == CurrentCombatant || CombatantAllies[CurrentCombatant][CombatantTarget[CurrentCombatant]] {
            CombatantTarget[CurrentCombatant] += 1
            if CombatantTarget[CurrentCombatant] >= CombatantsCount {
                CombatantTarget[CurrentCombatant] = 0
            }
            if CombatantTarget[CurrentCombatant] == InitialTarget {
                return
            }
        }
    }
    
    func DecrementCombatantTarget() {
        let InitialTarget: Int = CombatantTarget[CurrentCombatant]
        CombatantTarget[CurrentCombatant] -= 1
        if CombatantTarget[CurrentCombatant] < 0 {
            CombatantTarget[CurrentCombatant] = CombatantsCount - 1
        }
        while CombatantTarget[CurrentCombatant] == CurrentCombatant || CombatantAllies[CurrentCombatant][CombatantTarget[CurrentCombatant]] {
            CombatantTarget[CurrentCombatant] -= 1
            if CombatantTarget[CurrentCombatant] < 0 {
                CombatantTarget[CurrentCombatant] = CombatantsCount - 1
            }
            if CombatantTarget[CurrentCombatant] == InitialTarget {
                return
            }
        }
    }
    
    func GetLowestDamageValueForParagonAttacks(Paragon: Paragon) -> Int {
        var LowestDamage = 1000
        for nextAttack in Paragon.ParagonAttackSet.Attacks {
            if nextAttack.AttackBaseDamage < LowestDamage {
                LowestDamage = nextAttack.AttackBaseDamage
            }
        }
        return LowestDamage
    }
    
    func GetHighestDamageValueForParagonAttacks(Paragon: Paragon) -> Int {
        var HighestDamage = -1
        for nextAttack in Paragon.ParagonAttackSet.Attacks {
            if nextAttack.AttackBaseDamage > HighestDamage {
                HighestDamage = nextAttack.AttackBaseDamage
            }
        }
        return HighestDamage
    }
    
    //MARK: - Set Functions - Current Combatant
    func SetAttackBonusForCurrentCombatant(Value: Int) {
        SetAttackBonus(Combatant: CurrentCombatant, Value: Value)
    }
    
    func SetAttackDamageBonusForCurrentCombatant(Value: Int) {
        SetAttackDamageBonus(Combatant: CurrentCombatant, Value: Value)
    }
    
    func SetMeleeDefenseBonusForCurrentCombatant(Value: Int) {
        SetMeleeDefenseBonus(Combatant: CurrentCombatant, Value: Value)
    }
    
    func SetRangeDefenseBonusForCurrentCombatant(Value: Int) {
        SetRangeDefenseBonus(Combatant: CurrentCombatant, Value: Value)
    }
    
    func SetDamageResistanceValueBonusForCurrentCombatant(Value: Int) {
        SetDamageResistanceValueBonus(Combatant: CurrentCombatant, Value: Value)
    }
    
    func SetParagonStatusForCurrentCombatant(Status: ParagonStatus, Turns: Int, SelfInflicted: Bool) {
        SetParagonStatus(Combatant: CurrentCombatant, Status: Status, Turns: Turns, SelfInflicted: SelfInflicted)
    }
    
    
    //MARK: - Modify Functions - Current Combatant
    func ModifyAttackBonusForCurrentCombatant(Value: Int) {
        ModifyAttackBonus(Combatant: CurrentCombatant, Value: Value)
    }
    
    func ModifyAttackDamageBonusForCurrentCombatant(Value: Int) {
        ModifyAttackDamageBonus(Combatant: CurrentCombatant, Value: Value)
    }
    
    func ModifyMeleeDefenseBonusForCurrentCombatant(Value: Int) {
        ModifyMeleeDefenseBonus(Combatant: CurrentCombatant, Value: Value)
    }
    
    func ModifyRangeDefenseBonusForCurrentCombatant(Value: Int) {
        ModifyRangeDefenseBonus(Combatant: CurrentCombatant, Value: Value)
    }
    
    func ModifyDamageResistanceValueBonusForCurrentCombatant(Value: Int) {
        ModifyDamageResistanceValueBonus(Combatant: CurrentCombatant, Value: Value)
    }
    
    
    //MARK: - Set Functions - Target Combatant
    func SetAttackBonusForTarget(Value: Int) {
        SetAttackBonus(Combatant: CombatantTarget[CurrentCombatant], Value: Value)
    }
    
    func SetAttackDamageBonusForTarget(Value: Int) {
        SetAttackDamageBonus(Combatant: CombatantTarget[CurrentCombatant], Value: Value)
    }
    
    func SetMeleeDefenseBonusForTarget(Value: Int) {
        SetMeleeDefenseBonus(Combatant: CombatantTarget[CurrentCombatant], Value: Value)
    }
    
    func SetRangeDefenseBonusForTarget(Value: Int) {
        SetRangeDefenseBonus(Combatant: CombatantTarget[CurrentCombatant], Value: Value)
    }
    
    func SetDamageResistanceValueBonusForTarget(Value: Int) {
        SetDamageResistanceValueBonus(Combatant: CombatantTarget[CurrentCombatant], Value: Value)
    }
    
    func SetParagonStatusForTarget(Status: ParagonStatus, Turns: Int, SelfInflicted: Bool) {
        SetParagonStatus(Combatant: CombatantTarget[CurrentCombatant], Status: Status, Turns: Turns, SelfInflicted: SelfInflicted)
    }
    
    
    //MARK: - Modify Functions - Target Combatant
    func ModifyAttackBonusForTarget(Value: Int) {
        ModifyAttackBonus(Combatant: CombatantTarget[CurrentCombatant], Value: Value)
    }
    
    func ModifyAttackDamageBonusForTarget(Value: Int) {
        ModifyAttackDamageBonus(Combatant: CombatantTarget[CurrentCombatant], Value: Value)
    }
    
    func ModifyMeleeDefenseBonusForTarget(Value: Int) {
        ModifyMeleeDefenseBonus(Combatant: CombatantTarget[CurrentCombatant], Value: Value)
    }
    
    func ModifyRangeDefenseBonusForTarget(Value: Int) {
        ModifyRangeDefenseBonus(Combatant: CombatantTarget[CurrentCombatant], Value: Value)
    }
    
    func ModifyDamageResistanceValueBonusForTarget(Value: Int) {
        ModifyDamageResistanceValueBonus(Combatant: CombatantTarget[CurrentCombatant], Value: Value)
    }
    
    
    //MARK: - Set Functions - Any Combatant
    func SetAttackBonus(Combatant: Int, Value: Int) {
        Combatants[Combatant].setAttackBonus(Value: Value)
    }
    
    func SetAttackDamageBonus(Combatant: Int, Value: Int) {
        Combatants[Combatant].setAttackDamageBonus(Value: Value)
    }
    
    func SetMeleeDefenseBonus(Combatant: Int, Value: Int) {
        Combatants[Combatant].setMeleeDefenseBonus(Value: Value)
    }
    
    func SetRangeDefenseBonus(Combatant: Int, Value: Int) {
        Combatants[Combatant].setRangeDefenseBonus(Value: Value)
    }
    
    func SetDamageResistanceValueBonus(Combatant: Int, Value: Int) {
        Combatants[Combatant].setDamageResistanceValueBonus(Value: Value)
    }
    
    func SetParagonStatus(Combatant: Int, Status: ParagonStatus, Turns: Int, SelfInflicted: Bool) {
        Combatants[Combatant].setParagonStatus(Status: Status, ForNumberOfTurns: Turns, SelfInflicted: SelfInflicted)
    }
    
    
    //MARK: - Modify Functions - Any Combatant
    func ModifyAttackBonus(Combatant: Int, Value: Int) {
        Combatants[Combatant].modifyAttackBonus(Value: Value)
    }
    
    func ModifyAttackDamageBonus(Combatant: Int, Value: Int) {
        Combatants[Combatant].modifyAttackDamageBonus(Value: Value)
    }
    
    func ModifyMeleeDefenseBonus(Combatant: Int, Value: Int) {
        Combatants[Combatant].modifyMeleeDefenseBonus(Value: Value)
    }
    
    func ModifyRangeDefenseBonus(Combatant: Int, Value: Int) {
        Combatants[Combatant].modifyRangeDefenseBonus(Value: Value)
    }
    
    func ModifyDamageResistanceValueBonus(Combatant: Int, Value: Int) {
        Combatants[Combatant].modifyDamageResistanceValueBonus(Value: Value)
    }
}
