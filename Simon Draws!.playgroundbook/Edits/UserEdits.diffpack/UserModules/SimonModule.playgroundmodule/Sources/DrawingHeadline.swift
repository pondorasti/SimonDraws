

//
//  DrawingHeadline.swift
//  WWDC2020
//
//  Created by Alexandru Turcanu on 10/05/2020.
//  Copyright © 2020 CodingBytes. All rights reserved.
//

import SwiftUI
import UtilitiesModule

class DrawingHeadline: ObservableObject {
    
    // MARK: - Properties
    
    @Published var value = "Drawing Canvas"
    
    
    // MARK: - Initialization
    
    init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(newHeadline),
                                               name: .drawingHeadlineUpdate,
                                               object: nil
        )
    }
    
    
    // MARK: - Private Methods
    
    @objc private func newHeadline(_ notification: Notification) {
        guard let string = notification.object as? String else {
            fatalError("Invalid notification object")
        }
        
        withAnimation(.default) {
            value = string
        }
    }
}


