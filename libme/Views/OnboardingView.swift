//
//  OnboardingView.swift
//  libme
//

import SwiftUI

struct OnboardingView: View {
  @Binding var isFirstRun: Bool
  @MainActor @State private var haveTimersFinished = [Bool](
    repeating: false,
    count: Constants.numTimer
  )
    var body: some View {
      VStack(alignment: .leading) {
        HStack {
          Spacer()
          Button(action: {
            isFirstRun.toggle()
          }, label: {
            Image(systemName: "x.circle.fill").tint(.accent)
          })
        }
        Spacer()
        Text("Welcome to \(Text("Libme").monospaced().foregroundColor(Color("AccentColor"))).")
          .opacity(haveTimersFinished[0] ? 1 : 0)
          .animation(.easeIn(duration: 1), value: haveTimersFinished[0])
          .padding(.bottom, 50)
        Text("Search OpenLibrary's catalog of books and add them to your bookshelf.")
          .opacity(haveTimersFinished[1] ? 1 : 0)
          .animation(.easeIn(duration: 2), value: haveTimersFinished[1])
          .padding(.bottom, 50)
        Text("Check your bookshelf and sort to your heart's content.")
          .opacity(haveTimersFinished[2] ? 1 : 0)
          .animation(.easeIn(duration: 3), value: haveTimersFinished[2])
          .padding(.bottom, 50)
        Text("Delete books you no longer have by swiping left.")
          .opacity(haveTimersFinished[3] ? 1 : 0)
          .animation(.easeIn(duration: 3), value: haveTimersFinished[3])
        Spacer()
      }
      .padding()
      .task {
        try? await Task.sleep(nanoseconds: 500_000_00)
        haveTimersFinished[0] = true
        for timerIndex in 1..<Constants.numTimer {
          try? await Task.sleep(nanoseconds: 1_000_000_000)
          haveTimersFinished[timerIndex] = true
        }
      }
    }
}
