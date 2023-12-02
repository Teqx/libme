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
  @AppStorage("isDarkMode")
  var isDarkMode = true
  let modelContainer: ModelContainer
  init() {
    do {
      modelContainer = try ModelContainer(for: Book.self)
    } catch {
      fatalError("Could not start ModelContainer.")
    }
  }

  var body: some Scene {
    WindowGroup {
      ContentView(isDarkMode: $isDarkMode)
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
    .modelContainer(for: Book.self)
  }
}
