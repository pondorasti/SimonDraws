
//
//  Simon.swift
//  WWDC2020
//
//  Created by Alexandru Turcanu on 09/05/2020.
//  Copyright © 2020 CodingBytes. All rights reserved.
//

import Foundation

public struct Simon {
    
    // MARK: - Dialogs
    
    static let introductionDialog = [
        "Hey there! 👋",
        "My name is Simon",
        "I like to play a game called...",
        "Simon Draws!",
        "Here's the rules",
        "I show you a sequence of icons",
        "Then you draw them in the same order",
        "Let's begin by choosing a theme"
    ]
    
    static let playingDialogs = [
        ["Great!", "Now we are ready to play", "Prepare to memorize"],
        ["Easy round!", "Don't get your hopes too high"],
        ["Hmm", "This is just a fluke"],
        ["You are just geting lucky at this point!"],
        ["Not bad!"] 
    ]
    
    static let getReadyDialog = [
        "Ready",
        "Set",
        "Go!"
    ]
    
    
    // MARK: - Defaults
    
    public static var drawingBuffer = 0.75
    
    public static var dialogDuration = 2.5
    static let fastDialogDuration = 0.75
    
    static let numberOfGuessingIcons = 4
    public static let requiredTrainingData = 3
    static let numberOfRounds = 4
    
    
    // MARK: - State
    
    enum State {
        case introduction
        case themePicking
        case training
        case playing
    }
    
    
    // MARK: - PlayingState
    
    enum PlayingState: Equatable {
        case speakDialog
        case showIconSequence
        case getReady
        case playing
        case gameOver
    }
    
    
    // MARK: - Theme
    
    enum Theme: String {
        case nature = "Nature"
        case tools = "Tools"
        case communication = "Communication"
        case random = "Random"
        
        func guessingIcons(shuffled: Bool = true) -> [GuessingIcon] {
            let guessingIcons: [GuessingIcon]
            
            switch self {
            case .nature:
                guessingIcons = GuessingIcon.nature
            case .tools:
                guessingIcons = GuessingIcon.tools
            case .communication:
                guessingIcons = GuessingIcon.communication
            case .random:
                guessingIcons = GuessingIcon.random
            }
            
            if shuffled {
                return Array(guessingIcons.shuffled().prefix(Simon.numberOfGuessingIcons))
            } else {
                return Array(guessingIcons.prefix(Simon.numberOfGuessingIcons))
            }
        }
        
        mutating func next() {
            switch self {
            case .nature:
                self = .tools
            case .tools:
                self = .communication
            case .communication:
                self = .random
            case .random:
                self = .nature
            }
        }
        
        mutating func previous() {
            switch self {
            case .nature:
                self = .random
            case .tools:
                self = .nature
            case .communication:
                self = .tools
            case .random:
                self = .communication
            }
        }
    }
}
