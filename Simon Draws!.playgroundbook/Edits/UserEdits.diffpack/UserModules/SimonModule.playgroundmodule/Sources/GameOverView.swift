
//
//  GameOverView.swift
//  WWDC2020
//
//  Created by Alexandru Turcanu on 11/05/2020.
//  Copyright © 2020 CodingBytes. All rights reserved.
//

import SwiftUI
import UtilitiesModule

struct GameOverView: View {
    
    // MARK: - Properties
    
    @ObservedObject var gameOverViewModel: GameOverViewModel
    
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: Constants.generalStackSpacing) {
            Text(gameOverViewModel.title)
                .titleStyle()
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer().frame(height: 8)
            
            Text(gameOverViewModel.subtitle)
                .subtitleStyle()
            Text("Thanks for playing!")
                .subtitleStyle()
        }
        .transition(.drop)
    }
}
