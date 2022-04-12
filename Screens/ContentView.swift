//
//  ContentView.swift
//  Slot_Machine
//
//  Created by 임성빈 on 2022/04/04.
//

import SwiftUI

struct ContentView: View {
    // MARK: Property
    
    let symbols = ["gfx-bell", "gfx-cherry", "gfx-coin", "gfx-grape", "gfx-seven", "gfx-strawberry"]
    
    @State private var highscore: Int = UserDefaults.standard.integer(forKey: "HighScore")
    @State private var coins: Int = 100
    @State private var betAmount: Int = 10
    @State private var reels: Array = [0, 1, 2]
    @State private var showingInfoView: Bool = false
    @State private var isActiveBet10: Bool = true
    @State private var isActiveBet20: Bool = false
    @State private var showingModel: Bool = false
    @State private var animatingSymbol: Bool = false
    @State private var animatingModel: Bool = false
    
    // MARK: Function
    
    func spinReels() {
//        reels[0] = Int.random(in: 0...symbols.count - 1)
//        reels[1] = Int.random(in: 0...symbols.count - 1)
//        reels[2] = Int.random(in: 0...symbols.count - 1)
        reels = reels.map({ _ in
            Int.random(in: 0...symbols.count - 1)
        })
    }
    
    func checkWining() {
        if reels[0] == reels[1] && reels[1] == reels[2] && reels[2] == reels[0] {
            playerWins()
            
            if coins > highscore {
                newHighScore()
            }
        } else {
            playerLoses()
        }
    }
    
    func playerWins() {
        coins += betAmount * 20
    }
    
    func newHighScore() {
        highscore = coins
        UserDefaults.standard.set(highscore, forKey: "HighScore")
    }
    
    func playerLoses() {
        coins -= betAmount
    }
    
    func activateBet20() {
        betAmount = 20
        isActiveBet10 = false
        isActiveBet20 = true
    }
    
    func activateBet10() {
        betAmount = 10
        isActiveBet10 = true
        isActiveBet20 = false
    }
    
    func isGameOver() {
        if coins <= 0 {
            showingModel = true
        }
    }
    
    func resetGame() {
        UserDefaults.standard.set(0, forKey: "HighScore")
        highscore = 0
        coins = 100
        activateBet10()
    }
    
    // MARK: Body
    var body: some View {
        ZStack {
            // MARK: Background
            LinearGradient(gradient: Gradient(colors: [Color("ColorPink"), Color("ColorPurple")]), startPoint: .topTrailing, endPoint: .bottomLeading)
                .ignoresSafeArea(.all)
            
            // MARK: Interface
            VStack(alignment: .center, spacing: 5, content: {
                // MARK: Header
                LogoView()
                
                Spacer()
                
                // MARK: Score
                HStack {
                    HStack(alignment: .center, spacing: 10, content: {
                        Text("Your\nCoins".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.trailing)
                        
                        Text("\(coins)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                    }) // END: HStack
                    .modifier(ScoreContainerModifier())
                    
                    Spacer()
                    
                    HStack(alignment: .center, spacing: 10, content: {
                        Text("\(highscore)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                        
                        Text("High\nScore".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.leading)
                    }) // END: HStack
                    .modifier(ScoreContainerModifier())
                    
                } // END: HStack
                // MARK: Slot Machine
                VStack(alignment: .center, spacing: 0, content: {
                    
                    // MARK: Reel
                    ZStack {
                        ReelView()
                        Image(symbols[reels[0]])
                            .resizable()
                            .modifier(ImageModifier())
                            .opacity(self.animatingSymbol ? 1 : 0)
                            .offset(y: self.animatingSymbol ? 0 : -30)
                            .animation(.easeOut(duration: Double.random(in: 0.5...0.7)), value: self.animatingSymbol)
                            .onAppear(perform: {
                                self.animatingSymbol.toggle()
                            })
                    } // END: ZStack
                    
                    HStack(alignment: .center, spacing: 0, content: {
                        
                        ZStack {
                            ReelView()
                            Image(symbols[reels[1]])
                                .resizable()
                                .modifier(ImageModifier())
                                .opacity(self.animatingSymbol ? 1 : 0)
                                .offset(y: self.animatingSymbol ? 0 : -30)
                                .animation(.easeOut(duration: Double.random(in: 0.7...0.9)), value: self.animatingSymbol)
                                .onAppear(perform: {
                                    self.animatingSymbol.toggle()
                                })
                        } // END: ZStack
                        
                        Spacer()
                        
                        ZStack {
                            ReelView()
                            Image(symbols[reels[2]])
                                .resizable()
                                .modifier(ImageModifier())
                                .opacity(self.animatingSymbol ? 1 : 0)
                                .offset(y: self.animatingSymbol ? 0 : -30)
                                .animation(.easeOut(duration: Double.random(in: 0.9...1.1)), value: self.animatingSymbol)
                                .onAppear(perform: {
                                    self.animatingSymbol.toggle()
                                })
                        } // END: ZStack
                        
                    }) // END: HStack
                    .frame(maxWidth: 500)
                    
                    // MARK: Spin Button
                    Button(action: {
                        self.animatingSymbol = false
                        
                        self.spinReels()
                        
                        withAnimation {
                            self.animatingSymbol = true
                        }
                        
                        self.checkWining()
                        
                        self.isGameOver()
                        
                        if coins <= 10 {
                            self.activateBet10()
                        }
                    }, label: {
                        Image("gfx-spin")
                            .renderingMode(.original)
                            .resizable()
                            .modifier(ImageModifier())
                    })
                    
                }) // END: VStack
                .layoutPriority(2)
                
                // MARK: Footer
                
                Spacer()
                
                HStack {
                    // MARK: Bet
                    HStack(alignment: .center, spacing: 10, content: {
                        Button(action: {
                            self.activateBet20()
                        }, label: {
                            Text("20")
                                .fontWeight(.heavy)
                                .foregroundColor(isActiveBet20 ? Color("ColorYellow") : Color.white)
                                .modifier(BetNumberModifier())
                        })
                        .modifier(BetCapsuleModifier())
                        
                        Image("gfx-casino-chips")
                            .resizable()
                            .opacity(isActiveBet20 ? 1 : 0)
                            .offset(x: isActiveBet20 ? 0 : 20)
                            .modifier(CasinoChipsModifier())
                    })
                    
                    Spacer()
                    
                    // MARK: Bet
                    HStack(alignment: .center, spacing: 10, content: {

                        Image("gfx-casino-chips")
                            .resizable()
                            .opacity(isActiveBet10 ? 1 : 0)
                            .offset(x: isActiveBet10 ? 0 : -20)
                            .modifier(CasinoChipsModifier())

                        Button(action: {
                            self.activateBet10()
                        }, label: {
                            Text("10")
                                .fontWeight(.heavy)
                                .foregroundColor(isActiveBet10 ? Color("ColorYellow") : Color.white)
                                .modifier(BetNumberModifier())
                        })
                        .modifier(BetCapsuleModifier())
                        
                    })
                    
                } // END: HStack

            }) // END: VStack
            .overlay(alignment: .topLeading, content: {
                // MARK: Reset Button
                Button(action: {
                    self.resetGame()
                }, label: {
                    Image(systemName: "arrow.2.circlepath.circle")
                })
                .modifier(ButtonModifier())
            })
            .overlay(alignment: .topTrailing, content: {
                Button(action: {
                    self.showingInfoView = true
                }, label: {
                    Image(systemName: "info.circle")
                })
                .modifier(ButtonModifier())
            })
            .padding()
            .frame(maxWidth: 720)
            .blur(radius: $showingModel.wrappedValue ? 5 : 0, opaque: false)
            
            // MARK:  Pop Up
            if $showingModel.wrappedValue {
                ZStack(alignment: .center, content: {
                    Color("ColorBlack").edgesIgnoringSafeArea(.all)
                    // MARK: Title
                    VStack(alignment: .center, spacing: 0, content: {
                        Text("GAME OVER")
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.heavy)
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(Color("ColorPink"))
                            .foregroundColor(Color.white)
                        
                        Spacer()
                        
                        // MARK: Message
                        VStack(alignment: .center, spacing: 16, content: {
                            Image("gfx-seven-reel")
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 72)
    
                            Text("Bad luck! You lost all of the coins.\nLet's play again!")
                                .font(.system(.body, design: .rounded))
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.gray)
                                .layoutPriority(1)
                            
                            Button(action: {
                                self.showingModel = false
                                self.activateBet10()
                                self.coins = 100
                            }, label: {
                                Text("NEW GAME")
                                    .font(.system(.body, design: .rounded))
                                    .fontWeight(.semibold)
                                    .tint(Color("ColorPink"))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .frame(minWidth: 128)
                                    .background(
                                        Capsule()
                                            .strokeBorder(lineWidth: 1.75)
                                            .foregroundColor(Color("ColorPink"))
                                    )
                            })
                        })
                        
                        Spacer()

                    }) // END: VStack
                    .frame(minWidth: 280, idealWidth: 280, maxWidth: 320, minHeight: 260, idealHeight: 280, maxHeight: 320, alignment: .center)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color("ColorBlack"), radius: 6, x: 0, y: 8)
                    .opacity($animatingModel.wrappedValue ? 1: 0)
                    .offset(y: $animatingModel.wrappedValue ? 0 : -100)
                    .animation(Animation.spring(response: 0.6, dampingFraction: 1.0, blendDuration: 1.0), value: self.animatingModel)
                    .onAppear(perform: {
                        self.animatingModel = true
                    })
                }) // END: ZStack
            }
            
        } // END: ZStack
        .sheet(isPresented: $showingInfoView, content: {
            InfoView()
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 13")
    }
}
