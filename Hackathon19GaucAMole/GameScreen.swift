//
//  GameScreen.swift
//  GuacAMole
//
//  Created by Mohammed ALSarraf on 12/6/19.
//  Copyright © 2019 MasterCode Inc. All rights reserved.
//

import SwiftUI
import Combine

let TIME_MAX: CGFloat = 60

class CombineTimer {
  private let intervalSubject: CurrentValueSubject<TimeInterval, Never>
  
  var interval: TimeInterval {
    get {
      intervalSubject.value
    }
    set {
      intervalSubject.send(newValue)
    }
  }
  
  var publisher: AnyPublisher<Date, Never> {
    intervalSubject
      .map {
        Timer.TimerPublisher(interval: $0, runLoop: .main, mode: .default).autoconnect()
    }
    .switchToLatest()
    .eraseToAnyPublisher()
  }
  
  init(interval: TimeInterval = 1.0) {
    intervalSubject = CurrentValueSubject<TimeInterval, Never>(interval)
  }
}

let combineTimer = CombineTimer()


struct GameScreen: View {
  
  @Environment(\.presentationMode) var presentationMode
  
  @State var activeHoles: [Int] = []
  @State var tappedAvocados: [Int] = []
  
  @State var score: Int = 0
  @State var timeRemaining: CGFloat = TIME_MAX //delay the game for 2 seconds
  
  @State var gameover: Bool = false
  
  //@State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
  
  var newTimer: Timer? = nil
  
  var timerString: String {
    if timeRemaining <= 0 {
      return "Time Over !"
    }
    
    if timeRemaining > 120 {
      return "Time Left: 2:00 min"
    }
    
    let minutes = Int(timeRemaining) / 60 % 60
    let seconds = Int(timeRemaining) % 60
    let secondsString = seconds < 10 ? "0\(seconds)" : "\(seconds)"
    return "Time Left: \(minutes):\(secondsString) min"
  }
  
  var body: some View {
    VStack {
      if self.gameover {
        GeometryReader { (geo) in
          GameoverScreen(score: self.$score, gameover: self.$gameover)
            .padding(40)
            .background(Color.init(white: 0.94))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
      }
      
      if !self.gameover {
        VStack(alignment: .center, spacing: 2) {
          VStack(alignment: .leading, spacing: 2) {
            Text(timerString)
              .bold()
              .font(.callout)
              .frame(minWidth: 400, alignment: .leading)
              .opacity(
                (self.timeRemaining <= 0 || self.timeRemaining > 10) ? 1 :
                  ((Int(self.timeRemaining) % 2 == 0) ? 0.2 : 1.0)
            )
              .foregroundColor(self.timeRemaining > 10 ? Color.black : Color.red)
              .animation(.linear(duration: 1.0))
              //.transition(.opacity)
              //.animation(AnyTransition.asymmetric(insertion: .opacity, removal: .opacity))
              //              .animation(
              //                Animation
              //                  .linear(duration: 1.0)
              //                  .repeatForever()
              //            )
              //.animation(.linear)
              .onReceive(combineTimer.publisher) { _ in
                if self.gameover { return }
                if self.timeRemaining > 0 && self.timeRemaining <= TIME_MAX {
                  self.timeRemaining -= 1
                  self.changeAvocado()
                  print("gamescreen \(self.timeRemaining)")
                } else if self.timeRemaining <= 0 {
                  self.gameover = true
                  //self.presentationMode.wrappedValue.dismiss()
                } else {
                  self.timeRemaining -= 1
                }
            }
            
            Text("Score: \(score)")
              .bold()
              .font(.callout)
          }
          .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
          
          
          Spacer()
          Board(score: $score,
                activeHoles: $activeHoles,
                tappedAvocados: $tappedAvocados,
                gameover: $gameover,
                timeRemaining: $timeRemaining)
          Spacer()
        }
        .padding(20)
        .background(Color.init(white: 0.96))
        .edgesIgnoringSafeArea(.all)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .onAppear {
          self.timeRemaining = TIME_MAX
        }
      }
    }
    .navigationBarTitle("")
    .navigationBarHidden(true)
  }
  
  func changeAvocado() {
    if gameover { return }
    var holes = self.activeHoles
    
    var randomNumbers: [Int] = [1,2,3,4,5]
    for number in holes {
      randomNumbers.removeAll(where: {$0 == number })
    }
    
    for number in tappedAvocados {
      randomNumbers.removeAll(where: {$0 == number })
    }
    
    let newNumber = randomNumbers.randomElement()!
    
    if holes.count >= 2 {
      holes.removeFirst()
    }
    
    holes.append(newNumber)
    activeHoles = holes
  }
}

struct GameScreen_Previews: PreviewProvider {
  static var previews: some View {
    GameScreen()
      .previewLayout(.fixed(width: 568, height: 320)) // iPhone SE landscape size
  }
}
