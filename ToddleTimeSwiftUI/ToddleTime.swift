//
//  ToddleTimeGame.swift
//  ToddleTimeSwiftUI
//
//  Created by J S on 4/24/21.
//

import SwiftUI

class ToddleTime: ObservableObject {
    @Published private var model: MemoryGame<Image> = ToddleTime.createMemoryGame()
    
    private static func createMemoryGame() -> MemoryGame<Image> {
        let images = [Image("cowImageLarge"), Image("dogImageLarge"), Image("chickenImageLarge"), Image("pigImageLarge"), Image("horseImageLarge"), Image("catImageLarge")]
        
        return MemoryGame<Image>(numberOfPairsOfCards: images.count) { pairIndex in
            return images[pairIndex]
        }
    }
    
    // MARK: - Access to the Model
    
    var cards: [MemoryGame<Image>.Card] {
        model.cards
    }
    
    // MARK: - Intent(s)
    
    func choose(card: MemoryGame<Image>.Card) {
        model.choose(card: card)
    }
    
    func resetGame() {
        model = ToddleTime.createMemoryGame()
    }
}
