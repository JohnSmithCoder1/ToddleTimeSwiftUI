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
            .foregroundColor(.purple)
            
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
            .foregroundColor(.purple)
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
    @State private var cards = 2
    @State private var content = 3
    @State private var color = 3
    @State private var isSoundOn = true
    
    var body: some View {
        VStack {
            Spacer()
            
            Group {
                Text("Cards")
                Picker(selection: $cards, label: Text("Cards")) {
                    Text("6").tag(0)
                    Text("10").tag(1)
                    Text("12").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Text("Content")
                Picker(selection: $content, label: Text("Content")) {
                    Text("Animals").tag(0)
                    Text("Foods").tag(1)
                    Text("Shapes").tag(2)
                    Text("Random").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                
                Text("Color")
                Picker(selection: $color, label: Text("Color")) {
                    Text("Yellow").tag(0)
                    Text("Red").tag(1)
                    Text("Blue").tag(2)
                    Text("Purple").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Toggle("Sound", isOn: $isSoundOn)
                    .toggleStyle(SwitchToggleStyle(tint: .purple))
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

