//
//  libmeApp.swift
//  libme
//
//  Created by Ian Macpherson Rojas on 11/13/23.
//

import SwiftUI
import SwiftData

@main
struct LibmeApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
    .modelContainer(for: Book.self)
  }
}
