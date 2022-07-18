//
//  GameRepository.swift
//  WordGame
//
//  Created by Shayan Ali on 18.07.22.
//

import Foundation
import Logging

protocol WordsProvidable {
  func getWords() -> [Word]?
}

struct WordsRepository: WordsProvidable {
  private let resourceName: String
  private let bundle: Bundle

  init(resourceName: String,
       bundle: Bundle = Bundle.main) {
    self.resourceName = resourceName
    self.bundle = bundle
  }

  func getWords() -> [Word]? {
    let result = FileReader(
      bundle: bundle,
      type: [Word].self,
      file: resourceName
    )

    switch result {
    case let .success(response):
      return response

    case let .failure(error):
      Logger.shared.error("\(error.localizedDescription)")
      return nil
    }
  }
}


