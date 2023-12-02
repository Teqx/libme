//
//  BookResults.swift
//  libme
//
//  Created by Ian Macpherson Rojas on 11/18/23.
//

import Foundation

struct BookResult: Decodable {
  let seed: [String]
  let title: String
  let authorName: [String]?
  let firstPublishYear: Int?
  let coverEditionKey: String?

  enum CodingKeys: String, CodingKey {
    case title
    case seed
    case authorName = "author_name"
    case firstPublishYear = "first_publish_year"
    case coverEditionKey = "cover_edition_key"
  }
}

struct BookResults: Decodable {
  let numFound: Int
  let docs: [BookResult]
}
