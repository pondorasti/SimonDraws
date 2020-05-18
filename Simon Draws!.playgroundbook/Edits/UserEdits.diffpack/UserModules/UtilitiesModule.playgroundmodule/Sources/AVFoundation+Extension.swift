
//
//  AVFoundation+Extension.swift
//  WWDC2020
//
//  Created by Alexandru Turcanu on 11/05/2020.
//  Copyright © 2020 CodingBytes. All rights reserved.
//

import AVFoundation
import UIKit

extension AVAudioPlayer {
    public enum Key: String {
        case woosh = "WooshSound"
        case cardsShuffling = "CardsShuffling"
        case wow = "WowSound"
        case ohNo = "OhNoSound"
        case pencil = "PencilSound"
        case snap = "SnappingSound"
        case success = "SuccessSound"
    }
    
    public static func sound(for soundKey: Key) -> AVAudioPlayer {
        guard let path = Bundle.main.path(forResource: soundKey.rawValue, ofType: "mp3") else {
            fatalError("Could not find path for audio file named: \(soundKey.rawValue)")
        }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.prepareToPlay()
            
            switch soundKey {
            case .pencil:
                audioPlayer.volume = 0.10
                audioPlayer.numberOfLoops = -1
            case .success:
                audioPlayer.volume = 0.25
            default:
                audioPlayer.volume = 0.30
            }
            
            return audioPlayer
        } catch {
            fatalError("Could not load audio file named: \(soundKey.rawValue)")
        }
    }
    
    public static func autoPlaySound(for soundKey: Key) -> AVAudioPlayer {
        let audioPlayer = sound(for: soundKey)
        audioPlayer.play()
        
        return audioPlayer
    }
}
