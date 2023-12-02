//
//  BookDetailsView.swift
//  libme
//
//  Created by Ian Macpherson Rojas on 11/18/23.
//

import SwiftUI
import SwiftData

struct BookDetailsView: View {
  @Bindable var book: Book

  var body: some View {
    Form {
      Section("Main") {
        Text(book.title).font(.title)
        Text("by \(book.author)")
        Text("Published: \(book.publishedDate)")
      }
    }
    .navigationTitle("Book Details")
    .navigationBarTitleDisplayMode(.inline)
  }
}

#Preview {
  do {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try ModelContainer(for: Book.self, configurations: config)
    let example = Book(title: "Benjamin Franklin", author: "Morgan", publishedDate: "1990")
    return BookDetailsView(book: example)
      .modelContainer(container)
  } catch {
    fatalError("Failed to create model container.")
  }
}
