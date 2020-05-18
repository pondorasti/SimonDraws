

//
//  SymbolsOverlayViewModel.swift
//  WWDC2020
//
//  Created by Alexandru Turcanu on 15/05/2020.
//  Copyright © 2020 CodingBytes. All rights reserved.
//

import SwiftUI
import UtilitiesModule

public class SymbolsOverlayViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var show = true
    
    
    // MARK: - Initialization
    
    init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(toggleShow),
                                               name: .toggleSymbolsOverlay,
                                               object: nil
        )
    }
    
    
    // MARK: - Private Methods
    
    @objc private func toggleShow() {
        withAnimation(.default) {
            self.show.toggle()
        }
    }
}
