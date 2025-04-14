//
//  View+Background.swift
//  LockMyIOT
//
//  Created by Simon Malih on 04/03/2025.
//

import SwiftUI

extension View {
    /// Set background color
    /// - Parameter color: Background color
    /// - Parameter ignoreSafeArea: If background should cover the whole screen
    /// - Returns: View with background
    func addBackground(_ color: Color = .backgroundPrimary, ignoreSafeArea: Bool = false) -> some View {
        self
            .background(color)
            .ignoresSafeArea(edges: ignoreSafeArea ? .all : [])
    }
}
