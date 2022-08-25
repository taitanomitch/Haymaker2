//
//  CSVReaderPositionsUtility.swift
//  Haymaker2
//
//  Created by Mitchell Taitano on 8/23/22.
//

import Foundation

class CSVReaderPositionsUtility {
    
    //MARK: - Column Counts
    var CardCSVColumnCount: Int = 17
    var WeaponCSVColumnCount: Int = 36
    var AttackCSVColumnCount: Int = 61
    
    
    //MARK: - Card CSV Positions
    var CardIDPos: Int = 0
    var CardImageStringPos: Int = 1
    var CardNamePos: Int = 2
    var CardEffectTypePos: Int = 3
    var CardTargetPos: Int = 4
    var CardBuffTypePos: Int = 5
    var CardStatusToSelfPos: Int = 6
    var CardStatusToSelfTurnsPos: Int = 7
    var CardStatusToTargetPos: Int = 8
    var CardStatusToTargetTurnsPos: Int = 9
    var CardMoveDirectionPos: Int = 10
    var CardValuePos: Int = 11
    var CardValueTypePos: Int = 12
    var CardMinimumRangePos: Int = 13
    var CardMaximumRangePos: Int = 14
    var CardEffectTextPos: Int = 15
    var CardsInDeckCountPos: Int = 16
    
    //MARK: - Weapon CSV Positions
    var WeaponIDPos: Int = 0
    var WeaponImageStringPos: Int = 1
    var WeaponName: Int = 2
    var WeaponAttackCollectionName: Int = 3
    var WeaponHandPos: Int = 4
    var WeaponRarityPos: Int = 5
    var WeaponSkillTypePos: Int = 6
    var WeaponMinimumSkillPos: Int = 7
    var WeaponCostPos: Int = 8
    var WeaponDurabilityHealth: Int = 9
    var WeaponDamageStatusPos: Int = 10
    var WeaponHealthPos: Int = 11
    var WeaponEnergyPos: Int = 12
    var WeaponSpeedPos: Int = 13
    var WeaponInitiativePos: Int = 14
    var WeaponHealthRecoveryPos: Int = 15
    var WeaponEnergyRecoveryPos: Int = 16
    var WeaponAttackPos: Int = 17
    var WeaponDamagePos: Int = 18
    var WeaponFightingPos: Int = 19
    var WeaponSharpshootingPos: Int = 20
    var WeaponCombatMagicPos: Int = 21
    var WeaponMeleeDefensePos: Int = 22
    var WeaponRangeDefensePos: Int = 23
    var WeaponToughnessPos: Int = 24
    var WeaponWillpowerPos: Int = 25
    var WeaponImmuneTypesPos: Int = 26
    var WeaponImmuneTypesTurnsPos: Int = 27
    var WeaponStengthTypesPos: Int = 28
    var WeaponStrengthTypesTurnsPos: Int = 29
    var WeaponWeaknessTypesPos: Int = 30
    var WeaponWeaknessTypesTurnsPos: Int = 31
    var WeaponMeleeImmunePos: Int = 32
    var WeaponMeleeImmuneTurnsPos: Int = 33
    var WeaponRangeImmunePos: Int = 34
    var WeaponRangeImmuneTurnsPos: Int = 35
    
    //MARK: - Attack CSV Positions
    var AttackIDPos: Int = 0
    var AttackParagonClassPos: Int = 1
    var AttackWeaponPos: Int = 2
    var AttackNamePos: Int = 3
    var AttackClassPos: Int = 4
    var AttackDifficultyPos: Int = 5
    var AttackValuePos: Int = 6
    var AttackBaseDamagePos: Int = 7
    var AttackDamageDiePos: Int = 8
    var AttackEnergyCostPos: Int = 9
    var AttackPointsMAXPos: Int = 10
    var AttackUnlimitedAttackPointsPos: Int = 11
    var AttackTypesPos: Int = 12
    var AttackDistancePos: Int = 13
    var AttackRangeMinimumPos: Int = 14
    var AttackRangeMaximumPos: Int = 15
    
    var AttackMovementSpeedHinderancePos: Int = 16
    var AttackMovementOccasionPos: Int = 17
    var AttackBenefitsPos: Int = 18
    var AttackSelfStatusInflictionPos: Int = 19
    var AttackSelfStatusInflictionTurnsPos: Int = 20
    var AttackStatusInflictionPos: Int = 21
    var AttackStatusInflictionTurnsPos: Int = 22
    var AttackNumberOfAttacksPos: Int = 23
    var AttackisAOEPos: Int = 24
    var AttackAOETypePos: Int = 25
    var AttackisUltimatePos: Int = 26
    var AttackisPrimaryPos: Int = 27
    var AttackUsesPrimaryWeaponPos: Int = 28
    
    var AttackBuffMeleeDefensePos: Int = 29
    var AttackMeleeDefenseBuffToSelfPos: Int = 30
    var AttackBuffRangeDefensePos: Int = 31
    var AttackRangeDefenseBuffToSelfPos: Int = 32
    var AttackBuffToughnessPos: Int = 33
    var AttackToughnessBuffToSelfPos: Int = 34
    var AttackBuffWillpowerPos: Int = 35
    var AttackWilpowerBuffToSelfPos: Int = 36
    var AttackBuffAttackPos: Int = 37
    var AttackAttackBuffToSelfPos: Int = 38
    var AttackBuffDamagePos: Int = 39
    var AttackDamageBuffToSelfPos: Int = 40
    
    var AttackBuffIsForAllyPos: Int = 41
    var AttackBuffIsAOEPos: Int = 42
    var AttackBuffAOETypePos: Int = 43
    var AttackBuffAOERangePos: Int = 44
    
    var AttackDebuffMeleeDefensePos: Int = 45
    var AttackMeleeDefenseDebuffToSelfPos: Int = 46
    var AttackDebuffRangeDefensePos: Int = 47
    var AttackRangeDefenseDebuffToSelfPos: Int = 48
    var AttackDebuffToughnessPos: Int = 49
    var AttackToughnessDebuffToSelfPos: Int = 50
    var AttackDebuffWillpowerPos: Int = 51
    var AttackWilpowerDebuffToSelfPos: Int = 52
    var AttackDebuffAttackPos: Int = 53
    var AttackAttackDebuffToSelfPos: Int = 54
    var AttackDebuffDamagePos: Int = 55
    var AttackDamageDebuffToSelfPos: Int = 56
    
    var AttackDebuffIsForAllyPos: Int = 57
    var AttackDebuffIsAOEPos: Int = 58
    var AttackDebuffAOETypePos: Int = 59
    var AttackDebuffAOERangePos: Int = 60
}
