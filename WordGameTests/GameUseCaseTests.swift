//
//  GameUseCaseTests.swift
//  WordGameTests
//
//  Created by Shayan Ali on 20.07.22.
//

import XCTest
@testable import WordGame

class GameUseCaseTests: XCTestCase {
  private let useCase: GamePlayable = GameUseCase(wordsRepository: MockWordRepository())
  private let testDesc = "GameUseCaseTests"

  func testIntialScore() {
    XCTAssertTrue(useCase.score == 0)
  }

  func testWhenAnswerisRightOnCorrectButton() {
    let expectation = self.expectation(description: testDesc)
    useCase.checkAction(action: .correct(answer: "timbre")) { response in
      XCTAssertTrue(response)
      XCTAssertEqual(self.useCase.lives, 3)
      XCTAssertEqual(self.useCase.score, 1)
      expectation.fulfill()
    }
    waitForExpectations(timeout: 3, handler: nil)
  }

  func testWhenAnswerisNotCorrectOnCorrectPress() {
    let expectation = self.expectation(description: testDesc)
    useCase.checkAction(action: .correct(answer: "quieto")) { response in
      XCTAssertFalse(response)
      XCTAssertEqual(self.useCase.lives, 2)
      XCTAssertEqual(self.useCase.score, 0)
      expectation.fulfill()
    }
    waitForExpectations(timeout: 2, handler: nil)
  }

  func testWhenPlayerPressWrongAndIsCorrect() {
    let expectation = self.expectation(description: testDesc)
    useCase.checkAction(action: .wrong(answer: "grupo")) { response in
      XCTAssertTrue(response)
      XCTAssertEqual(self.useCase.score, 1)
      expectation.fulfill()
    }
    waitForExpectations(timeout: 2, handler: nil)
  }

  func testWhenPlayerDoesntAnswerScoreStaysSame() {
    let expectation = self.expectation(description: testDesc)
    useCase.checkAction(action: .none(translation: "timbre")) { response in
      XCTAssertFalse(response)
      XCTAssertEqual(self.useCase.lives, 2)
      XCTAssertEqual(self.useCase.score, 0)
      expectation.fulfill()
    }
    waitForExpectations(timeout: 2, handler: nil)
  }

  func testWhenPlayerAnswersAllTheTranslationsThenShouldEndGame() {
    let answersList = ["timbre", "grupo", "quieto", "Four", "director del colegio"]
    let viewModel = MockViewModel(useCase: useCase)
    for ans in answersList {
      useCase.checkAction(action: .correct(answer: ans)) { _ in }
    }
    XCTAssertTrue(viewModel.shouldEndGame)
  }

  func testWhenPlayerPressedWrongAndAnswerIsCorrectupdateRoundShouldCall() {
    let expectation = self.expectation(description: testDesc)
    let viewModel = MockViewModel(useCase: useCase)
    let oldRound = viewModel.round
    useCase.checkAction(action: .wrong(answer: "timbre")) { _ in
      XCTAssertEqual(viewModel.round.word, "group")
      XCTAssertNotEqual(viewModel.round.word, oldRound.word)
      expectation.fulfill()
    }
    waitForExpectations(timeout: 2, handler: nil)
  }
}
