//
//  BookInfoViewModel.swift
//  libme
//
//  Created by Ian Macpherson Rojas on 11/30/23.
//

import Foundation
import SwiftUI

@Observable
class BookSearchViewModel {
  enum ImageSize {
    case small
    case large
  }

  var service: LibraryNetworkServiceProtocol
  @MainActor var bookInfoArray: [BookInfo] = []
  let bookRegex = /^\/books\/(.+)$/
  @MainActor var errorMessage = ""

  init(service: LibraryNetworkServiceProtocol) {
    self.service = service
  }


  func resolveOlid(for book: BookResult) -> String? {
    if let key = book.coverEditionKey {
      return key
    }

    if let firstOlidString = book.seed.first(where: { $0.contains("books") }) {
      if let match = firstOlidString.firstMatch(of: bookRegex) {
        return String(match.1)
      }
    }

    return nil
  }

  @MainActor
  func getCoverImage(for book: BookResult, size: ImageSize) async -> Data? {
    let olid = resolveOlid(for: book)
    guard let olid else {
      return nil
    }
    return try? await service.fetchCoverImage(olid: olid, size: size)
  }

  @MainActor
  func getBookResults(for query: String) async {
    var results: BookResults?
    do {
      results = try await service.fetchQueryResults(query: query)
    } catch {
      errorMessage = error.localizedDescription
    }
    if let results, results.numFound > 0 {
      bookInfoArray = results.docs.map {
        BookInfo(
          id: resolveOlid(for: $0) ?? UUID().uuidString,
          bookResult: $0)
      }
    } else {
      bookInfoArray = []
    }
  }
}
