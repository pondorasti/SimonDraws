
//
//  GuessingIcon.swift
//  WWDC2020
//
//  Created by Alexandru Turcanu on 07/05/2020.
//  Copyright © 2020 CodingBytes. All rights reserved.
//

import SwiftUI

public struct GuessingIcon: Identifiable, Hashable {
    
    // MARK: - Properties
    
    public let id = UUID()
    let label: String
    let imageName: String
    
    // MARK: - Computed Properties
    
    
    var image: Image {
        Image(systemName: imageName)
    }
    
    
    // MARK: - Hashable Conformance
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    
    // MARK: - Type Properties
    
    static let tuningfork = GuessingIcon(label: "Tuningfork", imageName: "tuningfork")
    static let hammer = GuessingIcon(label: "Hammer", imageName: "hammer")
    static let eyedropper = GuessingIcon(label: "Eyedropper", imageName: "eyedropper")
    static let wandAndStars = GuessingIcon(label: "Wand", imageName: "wand.and.stars")
    static let pin = GuessingIcon(label: "Pin", imageName: "pin")
    static let scissor = GuessingIcon(label: "Scissor", imageName: "scissors")
    static let magnifier = GuessingIcon(label: "Magnifier", imageName: "magnifyingglass")
    
    static let mic = GuessingIcon(label: "Mic", imageName: "mic")
    static let message = GuessingIcon(label: "Message", imageName: "message")
    static let phone = GuessingIcon(label: "Phone", imageName: "phone")
    static let video = GuessingIcon(label: "Video", imageName: "video")
    static let document = GuessingIcon(label: "Document", imageName: "doc.plaintext")
    static let character = GuessingIcon(label: "Character", imageName: "textformat.alt") // maybe remove this
    
    static let bolt = GuessingIcon(label: "Bolt", imageName: "bolt")
    static let star = GuessingIcon(label: "Star", imageName: "sparkles")
    static let cloud = GuessingIcon(label: "Cloud", imageName: "cloud")
    static let tornado = GuessingIcon(label: "Tornado", imageName: "tornado")
    static let snow = GuessingIcon(label: "Snow", imageName: "snow")
    
    static let tools = [
        tuningfork,
        hammer,
        eyedropper,
        wandAndStars,
        pin,
        scissor,
        magnifier
    ]
    
    static let nature = [
        bolt,
        star,
        cloud,
        tornado,
        snow
    ]
    
    static let communication = [
        mic,
        message,
        video,
        phone,
        character
    ]
    
    static let random = [
        hammer,
        magnifier,
        pin,
        scissor,
        mic,
        video,
        bolt,
        cloud,
        wandAndStars,
        tornado
    ]
}
