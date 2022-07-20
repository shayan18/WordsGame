//
//  GameRepositoryTests.swift
//  WordGameTests
//
//  Created by Shayan Ali on 20.07.22.
//

import XCTest
@testable import WordGame

class WordsRepositoryTests: XCTestCase {
  func testWordsWithValidJson() {
    let testRepository: WordsRepository = WordsRepository(resourceName: "testWords", bundle: Bundle(for: GameUseCaseTests.self))
    XCTAssertTrue(testRepository.getWords()?.count == 3)
    XCTAssertTrue(testRepository.getWords()?.first?.word == "primary school")
  }

  func testWordsWithInvalidResource() {
    let testRepository: WordsRepository = WordsRepository(resourceName: "wordsFake", bundle: Bundle(for: GameUseCaseTests.self))
    XCTAssertNil(testRepository.getWords())
  }

  func testWordsWithInvalidJson() {
    let testRepository: WordsRepository = WordsRepository(resourceName: "restaurantInvalid", bundle: Bundle(for: GameUseCaseTests.self))
    XCTAssertNil(testRepository.getWords())
  }
}
