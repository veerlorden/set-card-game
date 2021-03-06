//
//  SetCardGame.swift
//  Set
//
//  Created by Вадим Буркин on 12.07.2021.
//

import SwiftUI

class SetCardGame: ObservableObject {
    
    typealias Card = SetGame<Deck.SetCard>.Card
    
    private static var deck = Deck()
    private static var numberOfCardsFromStart = 12
    private static var numberOfCardsToDeal = 3
    @Published private var model: SetGame<Deck.SetCard> = SetCardGame.createSetGame()

    private static func createSetGame() -> SetGame<Deck.SetCard> {
        SetGame(numberOfCardsInDeck: deck.cards.count,
                numberOfCardsFromStart: numberOfCardsFromStart,
                numberOfCardsToDeal: numberOfCardsToDeal) { index in
            deck.cards[index]
        }
    }
    
    func createShape(for card: Card) -> some View {
        ZStack {
            switch card.content.shape {
            case .diamond: addShading(for: Diamond(), of: card)
            case .oval: addShading(for: Capsule(), of: card)
            case .squiggle: addShading(for: Squiggle(), of: card)
            }
        }
    }
    
    func addShading<SetShape>(for shape: SetShape, of card: Card) -> some View where SetShape: Shape {
        ZStack {
            switch card.content.shading {
            case .open: shape.open()
            case .striped: shape.striped()
            case .solid: shape.solid()
            }
        }
    }
    
    func chooseUIColor(for color: Deck.SetCard.Color) -> Color {
        switch color {
        case .pink: return Color.pink
        case .green: return Color.green
        case .purple: return Color.purple
        }
    }
    
    func chooseShadowColor(for card: Card) -> Color {
        if card.isDiscarded { return .clear }
        else if card.isMatched { return .green }
        else if card.isNotMatched { return .red }
        else { return .gray }
    }
    
    // MARK: - Access to the Model
    
    var cards: [Card] {
        model.cards
    }
    
    var undealtCards: [Card] {
        model.undealtCards
    }
    
    var discardPile: [Card] {
        model.discardPile
    }
    
    var matchedCards: [Card] {
        model.matchedCards
    }
    
    // MARK: - Intents
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func deal(_ numberOfCards: Int? = nil) {
        if matchedCards.count == 3 {
            self.discard()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation {
                    self.model.deal(3)
                }
            }
        } else {
            self.model.deal(3)
        }
    }
    
    func discard() {
        model.discard()
    }
    
    func restart() {
        model = SetCardGame.createSetGame()
    }
}
