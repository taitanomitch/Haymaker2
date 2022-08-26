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
    var AttackCSVColumnCount: Int = 93
    
    
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
    var AttackParagonClassAttackTierPos: Int = 2
    var AttackWeaponPos: Int = 3
    var AttackNamePos: Int = 4
    var AttackClassPos: Int = 5
    var AttackDifficultyPos: Int = 6
    var AttackValuePos: Int = 7
    var AttackBaseDamagePos: Int = 8
    var AttackDamageDiePos: Int = 9
    var AttackEnergyCostPos: Int = 10
    var AttackPointsMAXPos: Int = 11
    var AttackUnlimitedAttackPointsPos: Int = 12
    var AttackTypesPos: Int = 13
    var AttackDistancePos: Int = 14
    var AttackIsSelfBuffDebuffPos: Int = 15
    var AttackRangeMinimumPos: Int = 16
    var AttackRangeMaximumPos: Int = 17
    
    var AttackMovementSpeedHinderancePos: Int = 18
    var AttackMovementOccasionPos: Int = 19
    var AttackActivationPhasePos: Int = 20
    var AttackSelfStatusInflictionPos: Int = 21
    var AttackSelfStatusInflictionTurnsPos: Int = 22
    var AttackStatusInflictionPos: Int = 23
    var AttackStatusInflictionTurnsPos: Int = 24
    var AttackNumberOfAttacksPos: Int = 25
    var AttackisAOEPos: Int = 26
    var AttackAOETypePos: Int = 27
    var AttackisUltimatePos: Int = 28
    var AttackisPrimaryPos: Int = 29
    var AttackUsesPrimaryWeaponPos: Int = 30
    
    var AttackBuffTurnsPos: Int = 31
    var AttackBuffHealthPos: Int = 32
    var AttackBuffEnergyPos: Int = 33
    var AttackBuffSpeedPos: Int = 34
    var AttackBuffHealthRecoveryPos: Int = 35
    var AttackBuffEnergyRecoveryPos: Int = 36
    var AttackBuffAttackPos: Int = 37
    var AttackBuffDamagePos: Int = 38
    var AttackBuffFightingPos: Int = 39
    var AttackBuffSharpshootingPos: Int = 40
    var AttackBuffCombatMagicPos: Int = 41
    var AttackBuffMeleeDefensePos: Int = 42
    var AttackBuffRangeDefensePos: Int = 43
    var AttackBuffToughnessPos: Int = 44
    var AttackBuffWillpowerPos: Int = 45
    var AttackBuffImmuneTypesPos: Int = 46
    var AttackBuffImmuneTypesTurnsPos: Int = 47
    var AttackBuffStrengthTypesPos: Int = 48
    var AttackBuffStrengthTypesTurnsPos: Int = 49
    var AttackBuffWeaknessTypesPos: Int = 50
    var AttackBuffWeaknessTypesTurnsPos: Int = 51
    var AttackBuffMeleeImmunePos: Int = 52
    var AttackBuffMeleeImmuneTurnsPos: Int = 53
    var AttackBuffRangeImmunePos: Int = 54
    var AttackBuffRangeImmuneTurnsPos: Int = 55
    var AttackBuffRequiresAttackSuccessPos: Int = 56
    var AttackBuffToSelfPos: Int = 57
    var AttackBuffIsForAllyPos: Int = 58
    var AttackBuffIsAOEPos: Int = 59
    var AttackBuffAOETypePos: Int = 60
    var AttackBuffAOERangePos: Int = 61
    
    var AttackDebuffTurnsPos: Int = 62
    var AttackDebuffHealthPos: Int = 63
    var AttackDebuffEnergyPos: Int = 64
    var AttackDebuffSpeedPos: Int = 65
    var AttackDebuffHealthRecoveryPos: Int = 66
    var AttackDebuffEnergyRecoveryPos: Int = 67
    var AttackDebuffAttackPos: Int = 68
    var AttackDebuffDamagePos: Int = 69
    var AttackDebuffFightingPos: Int = 70
    var AttackDebuffSharpshootingPos: Int = 71
    var AttackDebuffCombatMagicPos: Int = 72
    var AttackDebuffMeleeDefensePos: Int = 73
    var AttackDebuffRangeDefensePos: Int = 74
    var AttackDebuffToughnessPos: Int = 75
    var AttackDebuffWillpowerPos: Int = 76
    var AttackDebuffImmuneTypesPos: Int = 77
    var AttackDebuffImmuneTypesTurnsPos: Int = 78
    var AttackDebuffStrengthTypesPos: Int = 79
    var AttackDebuffStrengthTypesTurnsPos: Int = 80
    var AttackDebuffWeaknessTypesPos: Int = 81
    var AttackDebuffWeaknessTypesTurnsPos: Int = 82
    var AttackDebuffMeleeImmunePos: Int = 83
    var AttackDebuffMeleeImmuneTurnsPos: Int = 84
    var AttackDebuffRangeImmunePos: Int = 85
    var AttackDebuffRangeImmuneTurnsPos: Int = 86
    var AttackDebuffRequiresAttackSuccessPos: Int = 87
    var AttackDebuffToSelfPos: Int = 88
    var AttackDebuffIsForAllyPos: Int = 89
    var AttackDebuffIsAOEPos: Int = 90
    var AttackDebuffAOETypePos: Int = 91
    var AttackDebuffAOERangePos: Int = 92
}
