//
//  ToddleTimeView.swift
//  ToddleTimeSwiftUI
//
//  Created by J S on 4/24/21.
//

import SwiftUI

struct ToddleTimeView: View {
  @ObservedObject var game: ToddleTime
  @State private var isPresented = false
  let cardColors = [Color(#colorLiteral(red: 1, green: 0.8235294118, blue: 0.01176470588, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.5137254902, blue: 0, alpha: 1)), Color(#colorLiteral(red: 0.003921568627, green: 0.462745098, blue: 0.7647058824, alpha: 1)), Color(#colorLiteral(red: 0.4745098039, green: 0.1764705882, blue: 0.5725490196, alpha: 1))]
  let backgroundColors = [Color(#colorLiteral(red: 0.1921568627, green: 0.6392156863, blue: 0.2549019608, alpha: 1)), Color(#colorLiteral(red: 0.003921568627, green: 0.462745098, blue: 0.7647058824, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.8235294118, blue: 0.01176470588, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.5137254902, blue: 0, alpha: 1))]
  
  var body: some View {
    ZStack {
      backgroundColors[UserDefaults.standard.integer(forKey: "color")]
        .ignoresSafeArea()
      
      VStack {
        HStack {
          Button(action: {
            self.isPresented.toggle()
          }) {
            Image(systemName: "gearshape")
          }
          .padding(.top)
          .padding(.leading)
          .sheet(isPresented: $isPresented, onDismiss: { game.resetGame() }, content: SettingsView.init)
          .font(.system(.title))
          .foregroundColor(cardColors[UserDefaults.standard.integer(forKey: "color")])
          
          Spacer()
        }
        
        Grid(game.cards) { card in
          CardView(card: card).onTapGesture {
            withAnimation(.linear(duration: 0.6)) {
              self.game.choose(card: card)
            }
          }
          .padding(5)
        }
        .padding()
        .foregroundColor(cardColors[UserDefaults.standard.integer(forKey: "color")])
      }
    }
    .onTapGesture(count: 1) {
      withAnimation(.easeInOut) {
        if self.game.model.cardMatchesNeededToWin == 0 {
          self.game.resetGame()
        }
      }
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
      .transition(.scale) // animation for clearing matched cards
    }
  }
}

struct SettingsView: View {
  @Environment(\.presentationMode) var presentationMode
  
  @State private var selectedNumberOfCardPairsIndex = UserDefaults.standard.integer(forKey: "cardPairs")
  @State private var selectedCardImagesIndex = UserDefaults.standard.integer(forKey: "cardImages")
  @State private var selectedColorIndex = UserDefaults.standard.integer(forKey: "color")
  @State private var isSoundOn = UserDefaults.standard.bool(forKey: "isSoundOn")
  
  var body: some View {
    ZStack {
      Color(#colorLiteral(red: 0.003921568627, green: 0.462745098, blue: 0.7647058824, alpha: 1))
        .ignoresSafeArea()
      
      VStack {
        HStack {
          Button(action: {
            presentationMode.wrappedValue.dismiss()
          }) {
            Image(systemName: "chevron.down")
          }
          .font(.system(.title))
          .foregroundColor(Color.white)
          .padding(20)
          
          Spacer()
        }
        
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
          
          Text("Images")
          Picker(selection: $selectedCardImagesIndex, label: Text("Images")) {
            Text("All").tag(0)
            Text("Animals").tag(1)
            Text("Foods").tag(2)
            Text("Shapes").tag(3)
          }
          .onChange(of: selectedCardImagesIndex, perform: { (value) in
            UserDefaults.standard.set(value, forKey: "cardImages")
          })
          .pickerStyle(SegmentedPickerStyle())
          .padding()
          
          
          Text("Color")
          Picker(selection: $selectedColorIndex, label: Text("Color")) {
            Text("Yellow").tag(0)
            Text("Orange").tag(1)
            Text("Blue").tag(2)
            Text("Purple").tag(3)
          }
          .onChange(of: selectedColorIndex) { (value) in
            UserDefaults.standard.set(value, forKey: "color")
          }
          .pickerStyle(SegmentedPickerStyle())
          .padding()
          
          Toggle("Sound", isOn: $isSoundOn)
            .onChange(of: isSoundOn, perform: { (value) in
              UserDefaults.standard.set(value, forKey: "isSoundOn")
            })
            .padding()
        }
        .foregroundColor(Color.white)
        
        Spacer()
        Spacer()
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ToddleTimeView(game: ToddleTime())
    SettingsView()
  }
}
