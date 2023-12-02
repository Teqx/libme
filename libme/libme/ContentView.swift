//
//  ContentView.swift
//  libme
//
//  Created by Ian Macpherson Rojas on 11/13/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
  @Environment(\.modelContext)
  var modelContext
  @Query var books: [Book]

  var body: some View {
    NavigationStack {
      List {
        ForEach(books) { book in
          NavigationLink(value: book) {
            VStack(alignment: .leading) {
              Text(book.title)
                .font(.headline)
              Text(book.author)
                .font(.subheadline)
            }
          }
        }
        .onDelete(perform: deleteBooks)
      }
      .navigationTitle("Bookshelf")
      .navigationDestination(for: Book.self) { book in
        BookDetailsView(book: book)
      }
      .toolbar {
        Button("Add Books", action: addBooks)
      }
    }
  }

  func addBooks() {
    let spqr = Book(title: "SPQR", author: "Mary Something")
    let lotr = Book(title: "Lord of the Rings", author: "JRR Tolkein")
    let scanner = Book(title: "A Scanner Darkly", author: "Philip K Dick")

    modelContext.insert(spqr)
    modelContext.insert(lotr)
    modelContext.insert(scanner)
  }

  func deleteBooks(_ indexSet: IndexSet) {
    for index in indexSet {
      let book = books[index]
      modelContext.delete(book)
    }
  }
}

#Preview {
  ContentView()
}
