//
//  MockWordsRepository.swift
//  WordGameTests
//
//  Created by Shayan Ali on 20.07.22.
//

@testable import WordGame

final class MockWordRepository: WordsProvidable {
  func getWords() -> [Word]? {
    TestConstant.testWords2
  }
}
