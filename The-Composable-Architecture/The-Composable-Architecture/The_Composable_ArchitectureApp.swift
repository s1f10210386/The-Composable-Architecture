//
//  The_Composable_ArchitectureApp.swift
//  The-Composable-Architecture
//
//  Created by 金澤帆高 on 2026/07/12.
//

import ComposableArchitecture
import SwiftUI

@main
struct The_Composable_ArchitectureApp: App {
    static let store = Store(initialState: CounterFeature.State()) {
      CounterFeature()
    }
    
    var body: some Scene {
      WindowGroup {
        CounterView(store: The_Composable_ArchitectureApp.store)
      }
    }
}
