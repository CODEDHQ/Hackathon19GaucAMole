//
//  Board.swift
//  GuacAMole
//
//  Created by Mohammed ALSarraf on 12/6/19.
//  Copyright © 2019 MasterCode Inc. All rights reserved.
//

import SwiftUI

let SCORE: Int = 5

//class GameSettings: ObservableObject {
//    @Published var score : Int = 0
//}

extension Int {
  static func randomAvacadoNumber() -> Int {
    (1...5).randomElement()!
  }
}

private extension Image {
  func avocado() -> some View {
    self
      .resizable()
      .scaledToFit()
      .frame(maxHeight: 44, alignment: .center)
      .padding(16)
      .background(Color.blue)
      .clipShape(Circle())
      .padding(5)
  }
  
  static func activeAvocado(_ number: Int, isActive active: Bool = false, tapped: Bool = false) -> some View {
    if active {
      let name = tapped ? "guacamole" : "avocado"
      return Image(name).avocado()
    } else {
      return Image(systemName: "add").avocado()
    }
  }
}

struct Board: View {
  @Binding var score: Int
  
  @Binding var activeHoles: [Int]
  @Binding var tappedAvocados: [Int]
  
  @Binding var gameover: Bool
  @Binding var timeRemaining: CGFloat
  
  var body: some View {
    VStack {
      HStack {
        avocado(1).gesture(TapGesture().onEnded { _ in self.userTappedNumber(1) })
        avocado(2).gesture(TapGesture().onEnded { _ in self.userTappedNumber(2) })
      }
      HStack {
        avocado(3).gesture(TapGesture().onEnded { _ in self.userTappedNumber(3) })
        avocado(4).gesture(TapGesture().onEnded { _ in self.userTappedNumber(4) })
        avocado(5).gesture(TapGesture().onEnded { _ in self.userTappedNumber(5) })
      }
    }
  }
  
  func userTappedNumber(_ tappedNumber: Int) {
    if gameover { return }
    
    if !activeHoles.contains(tappedNumber) {
      self.gameover = true
      self.tappedAvocados = []
      self.activeHoles = []
      self.timeRemaining = TIME_MAX
    } else if !tappedAvocados.contains(tappedNumber) {
      self.score = self.score + SCORE
      tappedAvocados.append(tappedNumber)
    }
  }
  
  func avocado(_ number: Int, isActive active: Bool = false, tapped: Bool = false) -> some View {
    if tappedAvocados.contains(number) {
      Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { _ in
        self.activeHoles.removeAll(where: {$0 == number })
        self.tappedAvocados.removeAll(where: {$0 == number })
      }
      
      return Image("guacamole").avocado()
    }
    
    if activeHoles.contains(number) {
      return Image("avocado").avocado()
    }
    
    return Image(systemName: "").avocado()
  }
}

struct Board_Previews: PreviewProvider {
  static var previews: some View {
    Board(score: .constant(0),
          activeHoles: .constant([1,4]),
          tappedAvocados: .constant([1]),
          gameover: .constant(false),
          timeRemaining: .constant(TIME_MAX))
    .previewLayout(.fixed(width: 568, height: 320)) // iPhone SE landscape size
  }
}
