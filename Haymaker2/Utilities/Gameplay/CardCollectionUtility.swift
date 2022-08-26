//
//  CardCollectionUtility.swift
//  Haymaker2
//
//  Created by Mitchell Taitano on 8/24/22.
//

import Foundation

class CardCollectionUtility {
    
    var CardCollectionArray: [[String]] = [[]]
    var CardDictionary: Dictionary = Dictionary<String, ParagonCard>()
    var CardCountInDeckDictionary: Dictionary = Dictionary<String, Int>()
    
    init() {
        let CardCSVReader = CSVReader()
        CardCSVReader.readCardCollectionCSV()
        self.CardCollectionArray = CardCSVReader.CardCollectionArray
        createCardDictionaries()
    }
    
    func getCardFromDictionary(CardID: String) -> ParagonCard {
        if CardDictionary[CardID] != nil {
            return CardDictionary[CardID]!
        }
        return ParagonCard()
    }
    
    func createCardDictionaries() {
        for i in 1..<CardCollectionArray.count {
            var NextCardID = CardCollectionArray[i][0]
            NextCardID = NextCardID.replacingOccurrences(of: "\"", with: "")
            let NextCard: ParagonCard = parseCardCollectionCSV(forCardID: NextCardID)
            CardDictionary[NextCardID] = NextCard
        }
    }
    
    func generateCardsForDeck() -> [ParagonCard] {
        var Deck: [ParagonCard] = []
        for (nextCardID,nextCard) in CardDictionary {
            let nextCardCount = CardCountInDeckDictionary[nextCardID]!
            for _ in 0..<nextCardCount {
                Deck.append(nextCard)
            }
        }
        Deck.shuffle()
        return Deck
    }
    
    func parseCardCollectionCSV(forCardID: String) -> ParagonCard {
        let CSVPositions: CSVReaderPositionsUtility = CSVReaderPositionsUtility()
        var CardPosition = -1
        let CardIDRawValue = "\"\(forCardID)\""
        for i in 0..<CardCollectionArray.count {
            if CardCollectionArray[i][0] == CardIDRawValue {
                CardPosition = i
                break
            }
        }
        
        for i in 0..<CardCollectionArray[CardPosition].count {
            CardCollectionArray[CardPosition][i] = CardCollectionArray[CardPosition][i].replacingOccurrences(of: "\"", with: "", options: .literal, range: nil)
        }
        
        if CardPosition == -1 {
            return ParagonCard()
        }
        
        let CardID: String = String(CardCollectionArray[CardPosition][CSVPositions.CardIDPos])
        let CardsInDeckCount: Int = Int(CardCollectionArray[CardPosition][CSVPositions.CardsInDeckCountPos])!
        CardCountInDeckDictionary[CardID] = CardsInDeckCount
        
        let CreatedCardEffect: CardEffect = CardEffect(rawValue: CardCollectionArray[CardPosition][CSVPositions.CardEffectTypePos])!
        let CreatedCardTarget: CardTarget = CardTarget(rawValue: CardCollectionArray[CardPosition][CSVPositions.CardTargetPos])!
        let CreatedMoveDirection: MoveDirection = MoveDirection(rawValue: CardCollectionArray[CardPosition][CSVPositions.CardMoveDirectionPos])!
        let CreatedValueType: ValueType = ValueType(rawValue: CardCollectionArray[CardPosition][CSVPositions.CardValueTypePos])!
        
        let CardBuffTypesStringArray: [String] = (CardCollectionArray[CardPosition][CSVPositions.CardBuffTypePos]).components(separatedBy: "|")
        var CreatedCardBuffTypes: [CardBuffType] = []
        for i in 0..<CardBuffTypesStringArray.count {
            CreatedCardBuffTypes.append(CardBuffType(rawValue: CardBuffTypesStringArray[i])!)
        }
        
        let CardStatusToSelfStringArray: [String] = (CardCollectionArray[CardPosition][CSVPositions.CardStatusToSelfPos]).components(separatedBy: "|")
        var CreatedCardStatusToSelf: [ParagonStatus] = []
        for i in 0..<CardStatusToSelfStringArray.count {
            CreatedCardStatusToSelf.append(ParagonStatus(rawValue: CardStatusToSelfStringArray[i])!)
        }
        
        let CardStatusToSelfTurnsStringArray: [String] = (CardCollectionArray[CardPosition][CSVPositions.CardStatusToSelfTurnsPos]).components(separatedBy: "|")
        var CreatedCardStatusToSelfTurns: [Int] = []
        for i in 0..<CardStatusToSelfTurnsStringArray.count {
            CreatedCardStatusToSelfTurns.append(Int(CardStatusToSelfTurnsStringArray[i])!)
        }
        
        let CardStatusToTargetStringArray: [String] = (CardCollectionArray[CardPosition][CSVPositions.CardStatusToTargetPos]).components(separatedBy: "|")
        var CreatedCardStatusToTarget: [ParagonStatus] = []
        for i in 0..<CardStatusToTargetStringArray.count {
            CreatedCardStatusToTarget.append(ParagonStatus(rawValue: CardStatusToTargetStringArray[i])!)
        }
        
        let CardStatusToTargetTurnsStringArray: [String] = (CardCollectionArray[CardPosition][CSVPositions.CardStatusToTargetTurnsPos]).components(separatedBy: "|")
        var CreatedCardStatusToTargetTurns: [Int] = []
        for i in 0..<CardStatusToTargetTurnsStringArray.count {
            CreatedCardStatusToTargetTurns.append(Int(CardStatusToTargetTurnsStringArray[i])!)
        }
        
        let CreatedCard = ParagonCard(CardID: CardID, CardImageString: String(CardCollectionArray[CardPosition][CSVPositions.CardImageStringPos]), CardName: String(CardCollectionArray[CardPosition][CSVPositions.CardNamePos]), CardEffect: CreatedCardEffect, CardTarget: CreatedCardTarget, CardBuffTypes: CreatedCardBuffTypes, CardStatusToSelf: CreatedCardStatusToSelf, CardStatusToSelfTurns: CreatedCardStatusToSelfTurns, CardStatusToTarget: CreatedCardStatusToTarget, CardStatusToTargetTurns: CreatedCardStatusToTargetTurns, CardMoveDirection: CreatedMoveDirection, CardValue: Int(CardCollectionArray[CardPosition][CSVPositions.CardValuePos])!, CardValueType: CreatedValueType, CardMinimumRange: Int(CardCollectionArray[CardPosition][CSVPositions.CardMinimumRangePos])!, CardMaximumRange: Int(CardCollectionArray[CardPosition][CSVPositions.CardMaximumRangePos])!, CardEffectTextString: String(CardCollectionArray[CardPosition][CSVPositions.CardEffectTextPos]))
        
        return CreatedCard
    }
}
