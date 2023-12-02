//
//  Book.swift
//  libme
//
//  Created by Ian Macpherson Rojas on 11/18/23.
//

import Foundation
import SwiftData

@Model
class Book {
  enum Rating: Int, Codable {
    case bad = 0, okay, good, great
  }

  var title: String
  var author: String
  var publishedDate: String
  var rating: Rating?
  var stampImage: Data?
  var largeImage: Data?

  init(
    title: String = "",
    author: String = "",
    publishedDate: String = "",
    stampImage: Data? = nil,
    largeImage: Data? = nil,
    rating: Rating? = nil
  ) {
    self.title = title
    self.author = author
    self.publishedDate = publishedDate
    self.rating = rating
    self.stampImage = stampImage
    self.largeImage = largeImage
  }
}
