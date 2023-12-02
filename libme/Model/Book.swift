//
//  Book.swift
//  libme
//
//  Created by Ian Macpherson Rojas on 11/18/23.
//

import Foundation
import SwiftData

@Model
class Book: Identifiable {
  enum Rating: Int, Codable {
    case notRated = 0, bad, okay, great
  }

  @Attribute(.unique)
  var id: String
  var title: String
  var author: String
  var firstPublishYear: String
  var ratingRawValue: Int
  // Storing rating as a raw Int since enums cannot be sorted in SwiftData
  var rating: Rating {
    get {
      .init(rawValue: ratingRawValue) ?? .notRated
    }
    set {
      ratingRawValue = newValue.rawValue
    }
  }
  @Attribute(.externalStorage)
  var largeImage: Data?

  init(
    id: String = UUID().uuidString,
    title: String = "",
    author: String = "",
    firstPublishYear: String = "N/A",
    largeImage: Data? = nil,
    rating: Rating = .notRated
  ) {
    self.id = id
    self.title = title
    self.author = author
    self.firstPublishYear = firstPublishYear
    self.ratingRawValue = rating.rawValue
    self.largeImage = largeImage
  }
}
