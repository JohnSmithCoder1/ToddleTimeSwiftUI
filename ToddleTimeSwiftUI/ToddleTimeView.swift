//
//  ToddleTimeView.swift
//  ToddleTimeSwiftUI
//
//  Created by J S on 4/24/21.
//

import SwiftUI

struct ToddleTimeView: View {
    @ObservedObject var viewModel: ToddleTime
    
    var body: some View {
        VStack {
            Grid(viewModel.cards) { card in
                CardView(card: card).onTapGesture {
                    withAnimation(.linear(duration: 0.6)) {
                        self.viewModel.choose(card: card)
                    }
                }
                .padding(5)
            }
            .padding()
            .foregroundColor(Color.purple)
            
            Button {
                withAnimation(.easeInOut) {
                    self.viewModel.resetGame()
                }
            } label: { Text("New Game") }
            .foregroundColor(Color.purple)
        }
    }
}

struct CardView: View {
    var card: MemoryGame<Image>.Card
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Text(card.content)
                    .font(Font.system(size: fontSize(for: size)))
            }
            .cardify(isFaceUp: card.isFaceUp)
            .transition(AnyTransition.opacity) // animation for clearing matched cards
        }
    }
    
    // MARK: - Drawing Constants
    
    func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.75
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ToddleTimeView(viewModel: ToddleTime())
    }
}

