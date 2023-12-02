//
//  NetworkService.swift
//  libme
//

import Foundation

enum NetworkConstants {
  static let openLibrarySearchURLString = "https://openlibrary.org/search.json"
  static let openLibraryCoversURLString = "https://covers.openlibrary.org/b/olid/"
}

protocol LibraryNetworkServiceProtocol {
  func fetchQueryResults(query: String) async throws -> BookResults?
  func fetchCoverImage(olid: String, size: BookSearchViewModel.ImageSize) async throws -> Data?
}

enum NetworkError: Error {
  case badQuery(String)
  case badResponse(Int)
  case badServerPayload
  case unknown
}

class NetworkService: LibraryNetworkServiceProtocol {
  let session = URLSession(configuration: URLSessionConfiguration.default)
  let decoder = JSONDecoder()

  func fetchQueryResults(query: String) async throws -> BookResults? {
    var results: BookResults?
    let searchURLComponents = URLComponents(string: NetworkConstants.openLibrarySearchURLString)
    if var searchURLComponents {
      searchURLComponents.queryItems = [
        URLQueryItem(name: "q", value: query)
      ]
      guard let searchURL = searchURLComponents.url else {
        throw NetworkError.badQuery(query)
      }

      let (data, response) = try await session.data(from: searchURL)
      guard let httpResponse = response as? HTTPURLResponse else {
        throw NetworkError.unknown
      }
      guard httpResponse.statusCode == 200 else {
        throw NetworkError.badResponse(httpResponse.statusCode)
      }
      do {
        results = try decoder.decode(BookResults.self, from: data)
        if results?.numFound == 0 {
          results = nil
        }
      } catch {
        throw NetworkError.badServerPayload
      }
    } else {
      throw NetworkError.unknown
    }
    return results
  }

  func fetchCoverImage(olid: String, size: BookSearchViewModel.ImageSize = .small) async throws -> Data? {
    let smallSuffix = "-M.jpg"
    let largeSuffix = "-L.jpg"
    var pathSuffix = ""

    guard !olid.isEmpty else {
      return nil
    }

    switch size {
    case .small:
      pathSuffix = olid + smallSuffix
    case .large:
      pathSuffix = olid + largeSuffix
    }

    guard let url = URL(string: NetworkConstants.openLibraryCoversURLString + pathSuffix)
    else {
      return nil
    }

    let (imageData, response) = try await session.data(from: url)
    guard let httpResponse = response as? HTTPURLResponse else {
      throw NetworkError.unknown
    }
    guard httpResponse.statusCode == 200 else {
      throw NetworkError.badResponse(httpResponse.statusCode)
    }
    return imageData
  }
}
