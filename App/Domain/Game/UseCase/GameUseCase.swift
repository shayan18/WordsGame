//
//  GameUseCase.swift
//  WordGame
//
//  Created by Shayan Ali on 18.07.22.
//

import Foundation

protocol GamePlayable {
  var updateGameData: ((Round)->())? { get set }
  var endGame: (()->())? { get set }
  var setupGame: Round { get }
  func checkAction(action: PlayerAction, result: @escaping (Bool) -> Void)
  func getScore() -> String
}

final class GameUseCase: GamePlayable {
  let wordsRepository: WordsProvidable
  var updateGameData: ((Round) -> ())?
  var endGame: (() -> ())?
  var setupGame: Round { gameService.rounds.first ?? Round(word: "Something went wrong, please check your internet connection", options: []) }

  private var score = 0
  private var counter = 0
  private var inProcessGameDataIndex = 0
  private let gameService: GameService

  init(wordsRepository: WordsProvidable, gameService: GameService = GameService()) {
    self.wordsRepository = wordsRepository
    self.gameService = gameService
    if let words = self.wordsRepository.getWords() {
      self.gameService.setupGame(words: words)
    }
  }

  func checkAction(action: PlayerAction, result: @escaping (Bool) -> Void) {
    guard !gameService.rounds.isEmpty else {
      result(false)
      return
    }
    checkPlayerAction(userChoice: action, result: result)
  }


  func getScore() -> String { "\(score)" }

  private func checkPlayerAction(userChoice: PlayerAction, result: @escaping (Bool) -> Void) {
    switch userChoice {
    case let .correct(answer):
      handleRightAnswerCase(answer: answer, result: result)

    case let .wrong(answer):
      handleWrongAnswerCase(answer: answer, result: result)

    case let .none(translation):
      handleNoAnswerCase(translation: translation, result: result)
    }
  }

  private func updateData() {
    inProcessGameDataIndex += 1
    updateGameData?(gameService.rounds[inProcessGameDataIndex])
  }

  private func handleRightAnswerCase(answer: String, result: @escaping (Bool) -> Void) {
    if (gameService.wordsDict[gameService.rounds[inProcessGameDataIndex].word]! == answer) {
      score += 1
      if inProcessGameDataIndex == (gameService.rounds.count - 1) { endGame?() }
      else { updateData() }
      result(true)
    }
    else { result(false) }
  }

  private func handleWrongAnswerCase(answer: String, result: @escaping (Bool) -> Void) {
    if (gameService.wordsDict[gameService.rounds[inProcessGameDataIndex].word]! != answer) {
      score += 1
      result(true)
    } else {
      if inProcessGameDataIndex == (gameService.rounds.count - 1) { endGame?() }
      else { updateData() }
      result(false)
    }
  }

  private func handleNoAnswerCase(translation: String, result: @escaping (Bool) -> Void) {
    if inProcessGameDataIndex == (gameService.rounds.count - 1) { endGame?() }
    else { if gameService.rounds[inProcessGameDataIndex].options.last! == translation { updateData() } }
    result(false)
  }
}

