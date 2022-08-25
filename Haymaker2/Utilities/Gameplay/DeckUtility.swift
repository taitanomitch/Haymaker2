//
//  DeckUtility.swift
//  Haymaker2
//
//  Created by Mitchell Taitano on 8/12/22.
//

import Foundation

class DeckManager {

    var DeckCardUtility: CardCollectionUtility
    var Deck: [ParagonCard] = []
    var DiscardPile: [ParagonCard] = []
    
    init() {
        self.DeckCardUtility = CardCollectionUtility()
        Deck = DeckCardUtility.generateCardsForDeck()
    }
    
    func rebuildDeck() {
        Deck = DeckCardUtility.generateCardsForDeck()
        Deck.shuffle()
        DiscardPile = []
    }
    
    func lookAhead(Value: Int) -> [ParagonCard] {
        if Value > Deck.count {
            DiscardPile.shuffle()
            Deck.append(contentsOf: DiscardPile)
            DiscardPile = []
        }
        var PeekCards: [ParagonCard] = [ParagonCard](repeating: ParagonCard(), count: Value)
        for i in 0..<Value {
            PeekCards[i] = Deck[i]
        }
        return PeekCards
    }
    
    func drawCard() -> ParagonCard {
        if Deck.isEmpty {
            Deck = DiscardPile
            Deck.shuffle()
            DiscardPile = []
            
        }
        let CardToDraw = Deck.remove(at: 0)
        return CardToDraw
    }
    
    func discardCard(DiscardedCarad: ParagonCard) {
        DiscardPile.append(DiscardedCarad)
    }
}
