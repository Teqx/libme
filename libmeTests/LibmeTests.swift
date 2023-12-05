//
//  libmeTests.swift
//  libmeTests
//
//  Created by Ian Macpherson Rojas on 11/13/23.
//

import XCTest
@testable import libme

final class LibmeTests: XCTestCase {
  // SwiftLint wants me to indent lines in a comment. Bug with SwiftLint?
  // swiftlint:disable indentation_width
  static let testResponse = """
{
    "numFound": 1,
    "start": 0,
    "numFoundExact": true,
    "docs": [
        {
            "key": "/works/OL28687735W",
            "type": "work",
            "seed": [
                "/books/OL39375228M",
                "/works/OL28687735W",
                "/authors/OL10221409A"
            ],
            "title": "Unbearable Lightness of Being",
            "title_suggest": "Unbearable Lightness of Being",
            "title_sort": "Unbearable Lightness of Being",
            "edition_count": 1,
            "edition_key": [
                "OL39375228M"
            ],
            "publish_date": [
                "2023"
            ],
            "publish_year": [
                2023
            ],
            "first_publish_year": 2023,
            "isbn": [
                "9780063290648",
                "0063290642"
            ],
            "last_modified_i": 1660827271,
            "ebook_count_i": 0,
            "ebook_access": "no_ebook",
            "has_fulltext": false,
            "public_scan_b": false,
            "readinglog_count": 4,
            "want_to_read_count": 4,
            "currently_reading_count": 0,
            "already_read_count": 0,
            "publisher": [
                "HarperCollins Publishers"
            ],
            "language": [
                "eng"
            ],
            "author_key": [
                "OL10221409A"
            ],
            "author_name": [
                "Milan Kundera"
            ],
            "publisher_facet": [
                "HarperCollins Publishers"
            ],
            "_version_": 1767923040868368386,
            "author_facet": [
                "OL10221409A Milan Kundera"
            ]
        }
  ]
}
""".data(using: .utf8)
  // swiftlint:enable indentation_width

  class FakeNetworkService: LibraryNetworkServiceProtocol {
    func fetchQueryResults(query: String) async throws -> libme.BookResults? {
      if let testResponse = LibmeTests.testResponse {
        return try JSONDecoder().decode(libme.BookResults.self, from: testResponse)
      }
      return nil
    }

    func fetchCoverImage(olid: String, size: libme.BookSearchViewModel.ImageSize) async throws -> Data? {
      return nil
    }
  }

  let fakeNetworkService = FakeNetworkService()
  // Disabling this rule to make initializing test variables not require init
  // swiftlint:disable implicitly_unwrapped_optional
  var bookVM: BookSearchViewModel!
  // swiftlint:enable implicitly_unwrapped_optional

  override func setUpWithError() throws {
    bookVM = BookSearchViewModel(service: fakeNetworkService)
  }

  func testRetrievingBookInfoValues () async throws {
    await bookVM.getBookResults(for: "not tested")
    let count = await bookVM.bookInfoArray.count
    XCTAssertGreaterThan(count, 0)
    let firstYearPublished = await bookVM.bookInfoArray[0].firstYearPublished
    XCTAssertEqual(firstYearPublished, "2023")
  }

  func testResolveOlid () async throws {
    await bookVM.getBookResults(for: "not tested")
    let bookInfo = await bookVM.bookInfoArray[0]
    XCTAssertEqual(bookInfo.id, "OL39375228M")
  }
}
