//
//  BookInfoView.swift
//  libme
//
//  Created by Ian Macpherson Rojas on 11/29/23.
//

import SwiftUI
import SwiftData

struct BookInfoView: View {
  @Environment(\.modelContext)
  var modelContext
  let book: BookInfo
  let bookSearchVM: BookSearchViewModel
  @MainActor @State var imageData: Data?
  @MainActor @State var bookCover: UIImage?
  @MainActor @State var isOnShelf = true
  @MainActor @State var isGettingCover = true
  // No clue how to query for a specific model object, so grab them all
  @Query private var books: [Book]

  var body: some View {
    VStack(alignment: .center) {
      if let bookCover {
        Image(uiImage: bookCover)
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
      Text("\(book.bookResult.title)")
        .font(.title)
        .monospaced()
        .bold()
        .lineLimit(3)
        .multilineTextAlignment(.center)
        .minimumScaleFactor(0.5)
      Text("by \(book.authorsString)")
        .font(.headline)
        .monospaced()
        .lineLimit(3)
      Text("Published in \(Text(book.firstYearPublished).foregroundColor(Color("AccentColor")))")
        .font(.subheadline)
        .monospaced()
        .padding(.vertical, 10)
      Spacer()
      Button {
        modelContext.insert(
          Book(
            id: book.id,
            title: book.bookResult.title,
            author: book.authorsString,
            firstPublishYear: book.firstYearPublished,
            largeImage: imageData)
        )
        isOnShelf = true
      } label: {
        if isGettingCover {
          ProgressView()
        } else if isOnShelf {
          Text("Already on shelf")
        } else {
          Text("Add to shelf")
        }
      }
      .frame(minWidth: 100)
      .buttonStyle(.borderedProminent)
      .disabled(isOnShelf)
      .padding(.vertical, 10)
    }
    .padding()
    .navigationTitle("Book Details")
    .task {
      imageData = await bookSearchVM.getCoverImage(for: book.bookResult, size: .large)
      if let imageData {
        let tempImage = UIImage(data: imageData)
        // Some images are 1x1, so lets only display an image if we can see it
        if let tempImage, tempImage.size.width > 50 && tempImage.size.height > 50 {
          bookCover = tempImage
        } else { // Unusable image, get rid of it
          self.imageData = nil
        }
      }
      isGettingCover = false
      // Check for existence of book on bookshelf
      if books.contains(where: { $0.id == book.id }) {
        isOnShelf = true
      } else {
        isOnShelf = false
      }
    }
  }
}

#Preview {
  let bookVM = BookSearchViewModel(service: NetworkService())
  let book = BookResult(
    seed: ["nada"],
    title: "Huckleberry Fin",
    authorName: ["Mark Twain"],
    firstPublishYear: 1707,
    coverEditionKey: "OL7062714M"
  )
  let bookInfo = BookInfo(id: book.coverEditionKey ?? UUID().uuidString, bookResult: book)
  return BookInfoView(book: bookInfo, bookSearchVM: bookVM)
}
