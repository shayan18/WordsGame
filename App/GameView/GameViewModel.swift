//
//  GameViewModel.swift
//  WordGame
//
//  Created by Shayan Ali on 19.07.22.
//

import Foundation
import Combine
struct GameScreenActions {
  let dismiss: (String) -> ()
}

protocol GameScreenViewModelOutput {
  var answer: PassthroughSubject<String, Never> { get }
  var word: PassthroughSubject<String, Never> { get }
  var translation: PassthroughSubject<String, Never> { get }
  var isButtonInteractionsEnabled: PassthroughSubject<Bool, Never> { get }
  var positionTranslation: (() -> ())? { get set }
  var wordTitle: String { get }
  var showTranslation: (() -> ())? { get set }
  var hideTranslation: (() -> ())? { get set }
}

protocol GameScreenViewModelInput {
  func viewDidLoad()
  func viewDidAppear()
  func calculateTranslationPosition(translationWidth: Double, totalWidth:Double) -> Double
  func didTranslationOutOfScreen()
  func didTapOnCloseButton()
  func didTapOnRightAnswerButton()
  func didTapOnWrongAnserButton()
  var AnyCancellables: Set<AnyCancellable> { get set }
}

protocol GameScreenViewModelProtocol: GameScreenViewModelInput, GameScreenViewModelOutput { }

final class GameScreenViewModel: GameScreenViewModelProtocol {
  var AnyCancellables = Set<AnyCancellable>()

  var word = PassthroughSubject<String, Never>()

  var translation = PassthroughSubject<String, Never>()

  var isButtonInteractionsEnabled = PassthroughSubject<Bool, Never>()

  private var ongoingEmployeesFetch: AnyCancellable?

  var answer = PassthroughSubject<String, Never>()

  var animateTranslaions: Bool = false
  var wordTitle: String { "Word" }

  var showTranslation: (() -> ())?
  var hideTranslation: (() -> ())?
  var positionTranslation: (() -> ())?

  var useCase: GamePlayable
  private let actions: GameScreenActions

  private var gameData: Round
  private var counter = 0
  private let nextVal :((Int, Int) -> Int) = { $0 % $1 }
  private var timerVal = 0
  private var timer: Timer!

  init(useCase: GamePlayable, actions: GameScreenActions) {
    self.useCase = useCase
    self.actions = actions
    self.gameData = useCase.setupGame
    self.useCase.updateGameData = { [weak self] (gameData) in self?.updateGameData(gameData: gameData) }
    self.useCase.endGame = { [weak self] in self?.actions.dismiss(self?.useCase.getScore() ?? "0") }
  }

  func viewDidLoad() {
    answer.send("")
    word.send(gameData.word)
    translation.send(gameData.options.first ?? "")
    isButtonInteractionsEnabled.send(false)
    positionTranslation?()
  }

  func viewDidAppear() {
    showTranslation?()
    isButtonInteractionsEnabled.send(true)
    startTimer()
  }

  func calculateTranslationPosition(translationWidth: Double, totalWidth:Double) -> Double {
    let randomVal = Double.random(in: 0...totalWidth)
    let diff = randomVal - translationWidth
    if randomVal >= 0 && randomVal <= (totalWidth - translationWidth) {
      return randomVal
    } else {
      return (diff < 0) ? randomVal + diff : (totalWidth - translationWidth - 20)
    }
  }

  func didTranslationOutOfScreen() {
    let option = gameData.options[counter]
    handleUserResponse(userChoice: .none(translation: option))
  }

  func didTapOnRightAnswerButton() {
    let userChoice = gameData.options[counter]
    handleUserResponse(userChoice: .correct(answer: userChoice))
  }

  func didTapOnWrongAnserButton() {
    let userChoice = gameData.options[counter]
    handleUserResponse(userChoice: .wrong(answer: userChoice))
  }

  private func handleUserResponse(userChoice: PlayerAction) {
    counter = nextVal(counter + 1, gameData.options.count)
    hideTranslation?()
    translation.send(gameData.options[counter])
    positionTranslation?()
    checkPlayerChoice(playerAction: userChoice)
    showTranslation?()
    isButtonInteractionsEnabled.send(true)
    invalidateTimer()
    startTimer()
  }

  func didTapOnCloseButton() {
    let totalScore = useCase.getScore()
    actions.dismiss(totalScore)
  }

  private func updateGameData(gameData: Round) {
    self.gameData = gameData
    counter = 0

    word.send(gameData.word)
    translation.send(gameData.options[0])
    positionTranslation?()
  }

  private func startTimer() {
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: handleTimer)
  }

  private func handleTimer(timer: Timer) {
    timerVal += 1
    if timerVal == 6 { invalidateTimer() }
  }

  private func invalidateTimer() {
    timer.invalidate()
    timerVal = 0
  }

  private func checkPlayerChoice(playerAction: PlayerAction) {
    useCase.checkAction(action: playerAction) { [weak self] (result) in
      switch playerAction {
      case .none:
        self?.answer.send("No Answer")
      default:
        self?.answer.send(result ? "Right Answer" : "Wrong Answer")
      }
    }
  }
}
