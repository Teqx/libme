//
//  BookInfo.swift
//  libme
//
//  Created by Ian Macpherson Rojas on 12/1/23.
//

import Foundation

struct BookInfo: Identifiable {
  let id: String
  let bookResult: BookResult
  let authorsString: String
  let firstYearPublished: String

  init(id: String, bookResult: BookResult) {
    self.id = id
    self.bookResult = bookResult
    self.authorsString = bookResult.authorName?.joined(separator: ", ") ?? "N/A"
    if let firstYearPublished = bookResult.firstPublishYear {
      self.firstYearPublished = String(firstYearPublished)
    } else {
      self.firstYearPublished = "Unknown"
    }
  }
}
