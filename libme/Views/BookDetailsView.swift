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
    VStack(alignment: .center) {
      if let cover = book.largeImage, let uiCover = UIImage(data: cover) {
        Image(uiImage: uiCover)
          .resizable()
          .scaledToFit()
          .padding(.horizontal, 40)
          .padding(.bottom, 40)
      } else {
        Image(systemName: "photo")
          .resizable()
          .scaledToFit()
          .padding(.horizontal, 40)
          .padding(.vertical, 20)
      }
      Text("\(book.title)")
        .font(.title)
        .monospaced()
        .bold()
        .lineLimit(3)
        .multilineTextAlignment(.center)
        .minimumScaleFactor(0.5)
      Text("by \(book.author)")
        .font(.headline)
        .monospaced()
        .lineLimit(3)
      Text("Published in \(Text(book.firstPublishYear).foregroundColor(Color("AccentColor")))")
        .font(.subheadline)
        .monospaced()
        .padding(.vertical, 10)
    }
    .navigationTitle("Book Details")
    .navigationBarTitleDisplayMode(.inline)
  }
}

#Preview {
  do {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try ModelContainer(for: Book.self, configurations: config)
    let example = Book(title: "Benjamin Franklin", author: "Morgan", firstPublishYear: "1990")
    return BookDetailsView(book: example)
      .modelContainer(container)
  } catch {
    fatalError("Failed to create model container.")
  }
}
