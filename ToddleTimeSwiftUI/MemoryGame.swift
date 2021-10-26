//
//  CardLogic.swift
//  ToddleTimeSwiftUI
//
//  Created by J S on 4/24/21.
//

import Foundation
import AVFoundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    
    private(set) var cards: [Card]
    var audioPlayer: AVAudioPlayer?
    var cardMatchesNeededToWin: Int
    
    var indexOfOnlyFaceUpCard: Int? {
        get { cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly }
        set { cards.indices.forEach { cards[$0].isFaceUp = $0 == newValue } }
    }
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = [Card]()
        cardMatchesNeededToWin = numberOfPairsOfCards
        
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(id: pairIndex * 2, content: content))
            cards.append(Card(id: pairIndex * 2 + 1, content: content))
        }
        
        cards.shuffle()
    }
    
    mutating func choose(card: Card) {
         if let chosenIndex = cards.firstIndex(matching: card),
            !cards[chosenIndex].isFaceUp,
            !cards[chosenIndex].isMatched
         {
            if let potentialMatchIndex = indexOfOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    cardMatchesNeededToWin -= 1
                    
                    if cardMatchesNeededToWin == 0 {
                        #warning("called on game win")
                        playSound("victorySound", withDelay: .now() + 0.55)
                    } else {
                        playSound("cardMatchSound", withDelay: .now() + 0.42)
                    }
                }
                
                self.cards[chosenIndex].isFaceUp = true
            } else {
                indexOfOnlyFaceUpCard = chosenIndex
            }
        }
    }
    
    mutating func playSound(_ soundFile: String, withDelay delay: DispatchTime = .now()) {
        if UserDefaults.standard.bool(forKey: "isSoundOn") {
            guard let path = Bundle.main.url(forResource: soundFile, withExtension: "wav") else { return }
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: path)
                guard let audioPlayer = audioPlayer else { return }
                audioPlayer.prepareToPlay()
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    audioPlayer.play()
                }
            } catch let error as NSError {
                print("error: \(error.localizedDescription)")
            }
        }
    }
    
    struct Card: Identifiable {
        var id: Int
        var content: CardContent
        var isFaceUp = false
        var isMatched = false
    }
}
