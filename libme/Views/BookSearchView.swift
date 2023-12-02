//
//  BookSearchView.swift
//  libme
//
//  Created by Ian Macpherson Rojas on 12/2/23.
//

import SwiftUI

struct BookSearchView: View {
  @Binding var books: [BookInfo]
  @Binding var isFirstRun: Bool
  @State private var query = ""
  @State private var errorToDisplay = ""
  @State private var fetchBookResultsTask: Task<Void, Error>?
  @State private var isSpinnerOn = false
  var bookVM: BookSearchViewModel

  var body: some View {
    VStack {
      NavigationStack {
        HStack {
          Image(systemName: "magnifyingglass")
          TextField("Search entry", text: $query, prompt: Text("Search..."))
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .onSubmit {
              errorToDisplay = ""
              fetchBookResultsTask?.cancel()
              fetchBookResultsTask = Task {
                isSpinnerOn = true
                await bookVM.getBookResults(for: query)
                isSpinnerOn = false
                if !bookVM.errorMessage.isEmpty {
                  errorToDisplay = bookVM.errorMessage
                  bookVM.errorMessage = ""
                }
              }
            }
          if !query.isEmpty {
            if isSpinnerOn {
              ProgressView()
                .tint(.accentColor)
            } else {
              Button {
                query = ""
                bookVM.bookInfoArray = []
              } label: {
                Image(systemName: "xmark.circle.fill")
              }
            }
          }
        }
        .padding([.top, .horizontal])

        List(books) { book in
          NavigationLink {
            BookInfoView(book: book, bookSearchVM: bookVM)
          } label: {
            HStack {
              // image here
              VStack(alignment: .leading) {
                Text(book.bookResult.title)
                  .font(.headline)
                Text(book.authorsString)
                  .font(.subheadline)
              }
            }
          }
        }
        .navigationTitle("Book Search")
        .overlay {
          if isSpinnerOn {
            Text("Searching...")
          } else if !errorToDisplay.isEmpty {
            Text("\(errorToDisplay)")
          } else if bookVM.bookInfoArray.isEmpty {
            Text("Please search for a book or author")
          }
        }
      }
    }
    .sheet(isPresented: $isFirstRun) {
      OnboardingView(isFirstRun: $isFirstRun)
    }
  }
}
