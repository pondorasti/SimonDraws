
//
//  NotificationCenter+Extension.swift
//  WWDC2020
//
//  Created by Alexandru Turcanu on 12/05/2020.
//  Copyright © 2020 CodingBytes. All rights reserved.
//

import Foundation

public extension Notification.Name {
    public static var drawingHeadlineUpdate: Notification.Name {
        return .init("drawingHeadlineUpdate")
    }
    
    public static var newDrawing: Notification.Name {
        return .init("newDrawing")
    }
    
    public static var toggleSymbolsOverlay: Notification.Name {
        return .init("gameOver")
    }
}
