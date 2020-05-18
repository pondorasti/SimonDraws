
//
//  Transition+Extension.swift
//  WWDC2020
//
//  Created by Alexandru Turcanu on 08/05/2020.
//  Copyright © 2020 CodingBytes. All rights reserved.
//

import SwiftUI

public extension AnyTransition {
    public static var horizontalSlide: AnyTransition {
        .asymmetric(
            insertion: move(edge: .leading)
                .combined(with: .opacity)
                .combined(with: .scale),
            removal: move(edge: .trailing)
                .combined(with: .opacity)
                .combined(with: .scale)
        )
    }
    
    public static var reversedHorizontalSlide: AnyTransition {
        .asymmetric(
            insertion: move(edge: .trailing)
                .combined(with: .opacity)
                .combined(with: .scale),
            removal: move(edge: .leading)
                .combined(with: .opacity)
                .combined(with: .scale)
        )
    }
    
    public static var drop: AnyTransition {
        .asymmetric(
            insertion: .modifier(
                active: DropViewModifier(isActive: true, insertion: true),
                identity: DropViewModifier(isActive: false, insertion: true)
            ),
            removal: .modifier(
                active: DropViewModifier(isActive: true, insertion: false),
                identity: DropViewModifier(isActive: false, insertion: false)
            )
        )
    }
    
    public static var verticalSlide: AnyTransition {
        .asymmetric(
            insertion: .modifier(
                active: VerticalSlideViewModifier(isActive: true, insertion: true),
                identity: VerticalSlideViewModifier(isActive: false, insertion: true)
            ),
            removal: .modifier(
                active: VerticalSlideViewModifier(isActive: true, insertion: false),
                identity: VerticalSlideViewModifier(isActive: false, insertion: false)
            )
        )
    }
}

fileprivate struct DropViewModifier: ViewModifier {
    let isActive: Bool
    let insertion: Bool
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isActive ? (insertion ? 3 : 0) : 1)
            .opacity(isActive ? 0 : 1)
    }
}

fileprivate struct VerticalSlideViewModifier: ViewModifier {
    let isActive: Bool
    let insertion: Bool
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isActive ? 0 : 1)
            .opacity(isActive ? 0 : 1)
            .offset(x: 0, y: isActive ? 0 : (insertion ? -64 : 64))
    }
}
