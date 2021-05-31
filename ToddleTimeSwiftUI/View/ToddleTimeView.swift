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
    let cardColors = [Color.purple, Color.red, Color.blue, Color.yellow]
    
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
            .foregroundColor(cardColors[UserDefaults.standard.integer(forKey: "color")])
                        
            HStack {
                Button(action: {
                    self.isPresented.toggle()
                }) {
                    Image(systemName: "gearshape")
                }
                .padding(.leading)
                .fullScreenCover(isPresented: $isPresented, onDismiss: { viewModel.resetGame() }, content: SettingsView.init)
                
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
            .foregroundColor(cardColors[UserDefaults.standard.integer(forKey: "color")])
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
    #warning("add viewModel instance to reset game when options changed?")
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedNumberOfCardPairsIndex = UserDefaults.standard.integer(forKey: "cardPairs")
    @State private var selectedCardImagesIndex = UserDefaults.standard.integer(forKey: "cardImages")
    @State private var selectedColorIndex = UserDefaults.standard.integer(forKey: "color")
    @State private var isSoundOn = UserDefaults.standard.bool(forKey: "isSoundOn")
        
    var body: some View {
        VStack {
            Spacer()
            
            Group {
                Text("Cards")
                Picker(selection: $selectedNumberOfCardPairsIndex, label: Text("Cards")) {
                    Text("6").tag(0)
                    Text("8").tag(1)
                    Text("10").tag(2)
                    Text("12").tag(3)
                }
                .onChange(of: selectedNumberOfCardPairsIndex, perform: { (value) in
                    UserDefaults.standard.set(value, forKey: "cardPairs")
                })
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Text("Content")
                Picker(selection: $selectedCardImagesIndex, label: Text("Content")) {
                    Text("Animals").tag(0)
                    Text("Foods").tag(1)
                    Text("Shapes").tag(2)
                    Text("Random").tag(3)
                }
                .onChange(of: selectedCardImagesIndex, perform: { (value) in
                    UserDefaults.standard.set(value, forKey: "cardImages")
                })
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                
                Text("Color")
                Picker(selection: $selectedColorIndex, label: Text("Color")) {
                    Text("Purple").tag(0)
                    Text("Red").tag(1)
                    Text("Blue").tag(2)
                    Text("Yellow").tag(3)
                }
                .onChange(of: selectedColorIndex, perform: { (value) in
                    UserDefaults.standard.set(value, forKey: "color")
                })
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Toggle("Sound", isOn: $isSoundOn)
                    .onChange(of: isSoundOn, perform: { (value) in
                        UserDefaults.standard.set(value, forKey: "isSoundOn")
                    })
                    .padding()
            }
            
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

