//
//  GameoverScreen.swift
//  Hackathon19GaucAMole
//
//  Created by Mohammed ALSarraf on 12/6/19.
//  Copyright © 2019 MasterCode Inc. All rights reserved.
//

import SwiftUI

struct GameoverScreen: View {
  @Binding var score: Int
  @Binding var gameover: Bool

  var body: some View {
    VStack {
      Text("GAME OVER!").bold().font(.largeTitle)
        .padding(.bottom, 2)
      Text("Your Score: \(score)pts")
        .padding(.bottom, 20)
      
      Button(action: {
        self.gameover = false
        self.score = 0
      }) {
        Text("Play Again").font(.caption).bold()
        
        .padding(11)
        .background(Color.blue)
        .foregroundColor(.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
      }
    }
  }
}

struct GameoverScreen_Previews: PreviewProvider {
  static var previews: some View {
    GameoverScreen(score: .constant(25), gameover: .constant(true))
      .previewLayout(.fixed(width: 568, height: 320)) // iPhone SE landscape size
  }
}
