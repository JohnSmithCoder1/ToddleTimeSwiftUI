//
//  ToddleTimeView.swift
//  ToddleTimeSwiftUI
//
//  Created by J S on 4/24/21.
//

import SwiftUI

struct ToddleTimeView: View {
    @ObservedObject var viewModel: ToddleTime
    @State private var isPresented = false
    
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
            
            HStack {
                Button(action: {
                    self.isPresented.toggle()
                }) {
                    Image(systemName: "gearshape")
                }
                .padding(.leading)
                .fullScreenCover(isPresented: $isPresented, content: SettingsView.init)
                
                Spacer()
                
                Button(action: {
                    withAnimation(.easeInOut) {
                        self.viewModel.resetGame()
                    }
                }) {
                    Image(systemName: "arrow.clockwise.circle")
                }
                .padding(.trailing)
            }
            .font(.system(.largeTitle))
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
                card.content
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .cardify(isFaceUp: card.isFaceUp)
            .transition(AnyTransition.opacity) // animation for clearing matched cards
        }
    }
}

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("Settings")
            
            Spacer()
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "checkmark.circle")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ToddleTimeView(viewModel: ToddleTime())
    }
}

