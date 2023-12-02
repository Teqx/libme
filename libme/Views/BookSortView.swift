//
//  BookSortView.swift
//  libme
//

import SwiftData
import SwiftUI

struct BookSortView: View {
  @Environment(\.modelContext)
  var modelContext
  @Query var books: [Book]

  var body: some View {
    List {
      ForEach(books) { book in
        NavigationLink(value: book) {
          HStack(alignment: .center) {
            if let coverData = book.largeImage, let uiCover = UIImage(data: coverData) {
              Image(uiImage: uiCover)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 50)
                .padding(.trailing, 10)
            } else {
              Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 50)
                .padding(.trailing, 10)
            }
            VStack(alignment: .leading) {
              Text(book.title)
                .font(.headline)
              Text(book.author)
                .font(.subheadline)
            }
          }
        }
        .swipeActions {
          Button(role: .destructive) {
            modelContext.delete(book)
          } label: {
            Label("Delete", systemImage: "trash.fill")
          }.tint(.accentColor)
        }
      }
    }
    .overlay {
      if books.isEmpty {
        Text("Go to the search tab and add some books")
      }
    }
  }

  init(sort: SortDescriptor<Book>) {
    var sorts = [sort]
    if sort != SortDescriptor(\Book.title) {
      sorts.append(SortDescriptor(\Book.title))
    }
    _books = Query(sort: sorts)
  }

  func deleteBooks(_ indexSet: IndexSet) {
    for index in indexSet {
      let book = books[index]
      modelContext.delete(book)
    }
  }
}

#Preview {
  BookSortView(sort: SortDescriptor(\Book.title))
}
