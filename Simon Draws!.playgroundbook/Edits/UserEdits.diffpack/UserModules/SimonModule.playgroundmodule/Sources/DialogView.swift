
//
//  DialogView.swift
//  WWDC2020
//
//  Created by Alexandru Turcanu on 09/05/2020.
//  Copyright © 2020 CodingBytes. All rights reserved.
//

import SwiftUI
import Combine

struct DialogView<Type>: View {
    
    // MARK: - Properties
    
    @Binding private var currentState: Type
    @State private var currentIndex = 0
    
    private let nextState: Type
    private let dialog: [String]
    private let timer: Publishers.Autoconnect<Timer.TimerPublisher>
    
    
    // MARK: - Initialization
    
    init(currentState: Binding<Type>, nextState: Type, dialog: [String], dialogBuffer: Double = Simon.dialogDuration) {
        self._currentState = currentState
        self.nextState = nextState
        self.dialog = dialog
        
        self.timer = Timer.publish(every: dialogBuffer, on: .main, in: .common).autoconnect()
    }
    
    
    // MARK: - Body
    
    var body: some View {
        Text(dialog[currentIndex])
            .titleStyle()
            .id("Introduction ID:" + dialog[currentIndex])
            
            .onReceive(timer) { (_) in
                self.handleDialogUpdate()
        }
    }
    
    
    // MARK: - Private Methods
    
    private func handleDialogUpdate() {
        if currentIndex + 1 == dialog.count {
            timer.upstream.connect().cancel()
            currentState = nextState
        } else {
            withAnimation (.default) {
                currentIndex += 1
            }
        }
    }
}
