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
    let cardColors = [Color(#colorLiteral(red: 1, green: 0.8235294118, blue: 0.01176470588, alpha: 1)), Color(#colorLiteral(red: 0.9254901961, green: 0.1098039216, blue: 0.1411764706, alpha: 1)), Color(#colorLiteral(red: 0.003921568627, green: 0.462745098, blue: 0.7647058824, alpha: 1)), Color(#colorLiteral(red: 0.4745098039, green: 0.1764705882, blue: 0.5725490196, alpha: 1))]
    let backgroundColors = [Color(#colorLiteral(red: 0.1921568627, green: 0.6392156863, blue: 0.2549019608, alpha: 1)), Color(#colorLiteral(red: 0.003921568627, green: 0.462745098, blue: 0.7647058824, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.8235294118, blue: 0.01176470588, alpha: 1)), Color(#colorLiteral(red: 0.9254901961, green: 0.1098039216, blue: 0.1411764706, alpha: 1))]
    
    var body: some View { 
        ZStack {
            backgroundColors[UserDefaults.standard.integer(forKey: "color")]
                .ignoresSafeArea()
        
            VStack {
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
                            
                HStack {
                    Button(action: {
                        self.isPresented.toggle()
                    }) {
                        Image(systemName: "gearshape")
                    }
                    .padding(.leading)
                    .padding(.bottom)
                    .fullScreenCover(isPresented: $isPresented, onDismiss: { game.resetGame() }, content: SettingsView.init)
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.easeInOut) {
                            self.game.resetGame()
                        }
                    }) {
                        Image(systemName: "arrow.clockwise.circle")
                    }
                    .padding(.trailing)
                    .padding(.bottom)
                }
                .font(.system(.largeTitle).weight(.semibold))
                .foregroundColor(cardColors[UserDefaults.standard.integer(forKey: "color")])
            }
        }
//        .overlay(
//            EmitterView(images: ["confetti"], particleCount: 50, creationPoint: .init(x: 0.5, y: -0.1), creationRange: CGSize(width: 1, height: 0), colors: [.red, .yellow, .blue, .green, .white, .orange, .purple], angle: Angle(degrees: 180), angleRange: Angle(radians: .pi / 4), rotationRange: Angle(radians: .pi * 2), rotationSpeed: Angle(radians: .pi), scale: 0.6, speed: 1200, speedRange: 800, animation: Animation.linear(duration: 5).repeatForever(autoreverses: false), animationDelayThreshold: 5)
//        )
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
    @State private var isSoundOn = UserDefaults.standard.object(forKey: "isSoundOn") as? Bool ?? true
            
    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0.003921568627, green: 0.462745098, blue: 0.7647058824, alpha: 1))
                .ignoresSafeArea()
            
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
                        Text("Yellow").tag(0)
                        Text("Red").tag(1)
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
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "checkmark.circle")
                        .imageScale(.large)
                }
                .foregroundColor(Color.green)
                .padding()
            }
        }
    }
}

/// A particle emitter that creates a series of `ParticleView` instances for individual particles.
struct EmitterView: View {
    /// A pair of values representing the before and after state for a given piece of particle data
    private struct ParticleState<T> {
        var start: T
        var end: T
        
        init(_ start: T, _ end: T) {
            self.start = start
            self.end = end
        }
    }
    
    /// One particle in the emitter
    private struct ParticleView: View {
        /// Flip to true to move this particle between its start and end state
        @State var isActive = true
        
        let image: Image
        let position: ParticleState<CGPoint>
        let opacity: ParticleState<Double>
        let scale: ParticleState<CGFloat>
        let rotation: ParticleState<Angle>
        let color: Color
        let animation: Animation
        let blendMode: BlendMode
        
        var body: some View {
            image
                .colorMultiply(color)
                .blendMode(blendMode)
                .opacity(isActive ? opacity.end : opacity.start)
                .scaleEffect(isActive ? scale.end : scale.start)
                .rotationEffect(isActive ? rotation.end : rotation.start)
                .position(isActive ? position.end : position.start)
                .onAppear {
                    withAnimation(self.animation) {
                        self.isActive = true
                    }
                }
        }
    }
    
    var images: [String]
    var particleCount = 100
    
    var creationPoint = UnitPoint.center
    var creationRange = CGSize.zero
    
    var colors = [Color.white]
    
    var alpha: Double = 1
    var alphaRange: Double = 0
    var alphaSpeed: Double = 0
    
    var angle = Angle.zero
    var angleRange = Angle.zero
    
    var rotation = Angle.zero
    var rotationRange = Angle.zero
    var rotationSpeed = Angle.zero
    
    var scale: CGFloat = 1
    var scaleRange: CGFloat = 0
    var scaleSpeed: CGFloat = 0
    
    var speed = 50.0
    var speedRange = 0.0
    
    var animation = Animation.linear(duration: 1).repeatForever(autoreverses: false)
    var animationDelayThreshold = 0.0
    
    var blendMode = BlendMode.normal
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<self.particleCount, id: \.self) { i in
                    ParticleView(
                        image: Image(self.images.randomElement()!),
                        position: self.position(in: geo),
                        opacity: self.makeOpacity(),
                        scale: self.makeScale(),
                        rotation: self.makeRotation(),
                        color: self.colors.randomElement() ?? .white,
                        animation: self.animation.delay(Double.random(in: 0...self.animationDelayThreshold)),
                        blendMode: self.blendMode
                    )
                }
            }
        }
    }
    
    private func position(in proxy: GeometryProxy) -> ParticleState<CGPoint> {
        let halfCreationRangeWidth = creationRange.width / 2
        let halfCreationRangeHeight = creationRange.height / 2
        
        let creationOffsetX = CGFloat.random(in: -halfCreationRangeWidth...halfCreationRangeWidth)
        let creationOffsetY = CGFloat.random(in: -halfCreationRangeHeight...halfCreationRangeHeight)
        
        let startX = (proxy.size.width * (creationPoint.x + creationOffsetX))
        let startY = (proxy.size.height * (creationPoint.y + creationOffsetY))
        let start = CGPoint(x: startX, y: startY)
        
        let halfSpeedRange = speedRange / 2
        let actualSpeed  = Double.random(in: speed - halfSpeedRange...speed + halfSpeedRange)
        
        let halfAngleRange = angleRange.radians / 2
        let totalRange = Double.random(in: angle.radians - halfAngleRange...angle.radians + halfAngleRange)
        
        let finalX = cos(totalRange - .pi / 2) * actualSpeed
        let finalY = sin(totalRange - .pi / 2) * actualSpeed
        let end = CGPoint(x: Double(startX) + finalX, y: Double(startY) + finalY)
        
        return ParticleState(start, end)
    }
    
    private func makeOpacity() -> ParticleState<Double> {
        let halfAlphaRange = alphaRange / 2
        let randomAlpha = Double.random(in: -halfAlphaRange...halfAlphaRange)
        return ParticleState(alpha + randomAlpha, alpha + alphaSpeed + randomAlpha)
    }
    
    private func makeScale() -> ParticleState<CGFloat> {
        let halfScaleRange = scaleRange / 2
        let randomScale = CGFloat.random(in: -halfScaleRange...halfScaleRange)
        return ParticleState(scale + randomScale, scale + scaleSpeed + randomScale)
    }
    
    private func makeRotation() -> ParticleState<Angle> {
        let halfRotationRange = (rotationRange / 2).degrees
        let randomRotation = Double.random(in: -halfRotationRange...halfRotationRange)
        let randomRotationAngle = Angle(degrees: randomRotation)
        return ParticleState(rotation + randomRotationAngle, rotation + rotationSpeed + randomRotationAngle)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ToddleTimeView(game: ToddleTime())
    }
}
