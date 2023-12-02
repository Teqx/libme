//
//  ContentView.swift
//  libme
//

import SwiftUI
import Foundation
import SwiftData

enum Constants {
  static let numTimer = 4
}

struct ContentView: View {
  @State private var sortOrder = SortDescriptor(\Book.title)
  @State private var bookVM = BookSearchViewModel(service: NetworkService())
  @AppStorage("SelectedTab")
  var selectedTab: Int = 1
  @AppStorage("FirstRun")
  var isFirstRun = true
  @Binding var isDarkMode: Bool

  var body: some View {
    TabView(selection: $selectedTab) {
      BookSearchView(books: $bookVM.bookInfoArray, isFirstRun: $isFirstRun, bookVM: bookVM)
        .tabItem {
          Image(systemName: "magnifyingglass.circle.fill")
          Text("Search")
        }
        .tag(1)
      BookshelfView(sortOrder: $sortOrder, isDarkMode: $isDarkMode)
        .tabItem {
          Image(systemName: "books.vertical.circle.fill")
          Text("Bookshelf").font(Font.system(.title, design: .monospaced))
        }
        .tag(2)
    }
  }

  struct BookshelfView: View {
    @Binding var sortOrder: SortDescriptor<Book>
    @Binding var isDarkMode: Bool
    @Environment(\.modelContext)
    var modelContext

    let networkService = NetworkService()

    var body: some View {
      NavigationStack {
        BookSortView(sort: sortOrder)
          .navigationTitle("Bookshelf")
          .navigationDestination(for: Book.self, destination: BookDetailsView.init)
          .toolbar {
            Button("Switch Color", systemImage: "circle.lefthalf.filled") {
              isDarkMode.toggle()
            }
            Menu("Sort", systemImage: "arrow.up.arrow.down") {
              Picker("Sort", selection: $sortOrder) {
                Text("Title")
                  .tag(SortDescriptor(\Book.title))
                Text("Author")
                  .tag(SortDescriptor(\Book.author))
                Text("Published Year")
                  .tag(SortDescriptor(\Book.firstPublishYear))
                Text("Rating")
                  .tag(SortDescriptor(\Book.ratingRawValue, order: .reverse))
              }
            }
            .pickerStyle(.inline)
          }
      }
    }
  }
}

#Preview {
  return ContentView(isDarkMode: .constant(true))
}
