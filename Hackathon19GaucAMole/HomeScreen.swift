//
//  HomeScreen.swift
//  GuacAMole
//
//  Created by Mohammed ALSarraf on 12/6/19.
//  Copyright © 2019 MasterCode Inc. All rights reserved.
//

import SwiftUI

struct HomeScreen: View {
  var body: some View {
    NavigationView {
      NavigationLink(destination: GameScreen()) {
        
        Text("Start")
          .font(.title)
          .bold()
          .padding(44)
          .background(Color.red)
          .foregroundColor(.white)
          .clipShape(Circle())
      }
      .navigationBarTitle("")
      .navigationBarHidden(true)
    }
  }
}

struct HomeScreen_Previews: PreviewProvider {
  static var previews: some View {
    HomeScreen()
      .previewLayout(.fixed(width: 568, height: 320)) // iPhone SE landscape size
  }
}
