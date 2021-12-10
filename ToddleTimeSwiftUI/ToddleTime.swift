//
//  ToddleTimeGame.swift
//  ToddleTimeSwiftUI
//
//  Created by J S on 4/24/21.
//

import SwiftUI
import AVFoundation

class ToddleTime: ObservableObject {
  @Published var model: MemoryGame<Image> = ToddleTime.createMemoryGame()
  var audioPlayer: AVAudioPlayer?
  
  private static func createMemoryGame() -> MemoryGame<Image> {
    // Cards
    let numberOfCardPairs = [3, 4, 5, 6]
    
    // Content
    let animalImages = [Image("cowImageLarge"),
                        Image("dogImageLarge"),
                        Image("chickenImageLarge"),
                        Image("pigImageLarge"),
                        Image("horseImageLarge"),
                        Image("catImageLarge")]
    
    let foodImages = [Image("appleImageLarge"),
                      Image("bananaImageLarge"),
                      Image("broccoliImageLarge"),
                      Image("carrotImageLarge"),
                      Image("pepperImageLarge"),
                      Image("strawberryImageLarge")]
    
    let shapeImages = [Image("circleImageLarge"),
                       Image("squareImageLarge"),
                       Image("triangleImageLarge"),
                       Image("starImageLarge"),
                       Image("diamondImageLarge"),
                       Image("heartImageLarge")]
    
    let allImages = animalImages + foodImages + shapeImages
    
    let cardImageSets = [allImages.shuffled(), animalImages.shuffled(), foodImages.shuffled(), shapeImages.shuffled()]
    
    return MemoryGame<Image>(numberOfPairsOfCards: numberOfCardPairs[UserDefaults.standard.integer(forKey: "cardPairs")]) { pairIndex in
      return cardImageSets[UserDefaults.standard.integer(forKey: "cardImages")][pairIndex]
    }
  }
  
  func playSound(_ soundFile: String) {
    if UserDefaults.standard.bool(forKey: "isSoundOn") {
      guard let path = Bundle.main.url(forResource: soundFile, withExtension: "wav") else { return }
      do {
        audioPlayer = try AVAudioPlayer(contentsOf: path)
        guard let audioPlayer = audioPlayer else { return }
        audioPlayer.prepareToPlay()
        audioPlayer.play()
      } catch let error as NSError {
        print("error: \(error.localizedDescription)")
      }
    }
  }
  
  // MARK: - Access to the Model
  
  var cards: [MemoryGame<Image>.Card] {
    model.cards
  }
  
  // MARK: - Intent(s)
  
  func choose(card: MemoryGame<Image>.Card) {
    model.choose(card: card)
    
    if !card.isFaceUp {
      playSound("flipCard")
    }
    
    if model.cardMatchesNeededToWin == 0 && card.isFaceUp {
      resetGame()
    }
  }
  
  func resetGame() {
    model = ToddleTime.createMemoryGame()
    playSound("shuffleCards")
  }
}
