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
        let animalImages = [Image("cowImageLarge"), Image("dogImageLarge"), Image("chickenImageLarge"), Image("pigImageLarge"), Image("horseImageLarge"), Image("catImageLarge")]
        
        let foodImages = [Image("appleImageLarge"), Image("bananaImageLarge"), Image("broccoliImageLarge"), Image("carrotImageLarge"), Image("pepperImageLarge"), Image("strawberryImageLarge")]
        
        let shapeImages = [Image("circleImageLarge"), Image("squareImageLarge"), Image("triangleImageLarge"), Image("starImageLarge"), Image("diamondImageLarge"), Image("heartImageLarge")]
                
        let selectedImages = [animalImages, foodImages, shapeImages].randomElement()!
        
        return MemoryGame<Image>(numberOfPairsOfCards: selectedImages.count) { pairIndex in
            return selectedImages[pairIndex]
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
