//
//  GameViewModel.swift
//  WordGame
//
//  Created by Shayan Ali on 19.07.22.
//

import Combine
import Foundation

protocol GameViewModelOutput {
  var answer: PassthroughSubject<String, Never> { get }
  var word: PassthroughSubject<String, Never> { get }
  var ShouldButtonEnabled: PassthroughSubject<Bool, Never> { get }
  var translation: PassthroughSubject<String, Never> { get }
  var score: PassthroughSubject<String, Never> { get }
  var lives: PassthroughSubject<Int, Never> { get }
  var translationPosition: (() -> ())? { get set }
  var showTranslation: (() -> ())? { get set }
  var hideTranslation: (() -> ())? { get set }
}

protocol GameViewModelInput {
  func viewDidLoad()
  func onViewAppear()
  func didPressOnRightAnswerButton()
  func didPressOnWrongAnswerButton()
  func calculateTranslationPosition(width: Double, maxWidth: Double) -> Double
  func didTranslationOutOfView()
  func didPressOnCloseButton()

  var anyCancellables: Set<AnyCancellable> { get set }
}

protocol GameViewModelProtocol: GameViewModelInput, GameViewModelOutput { }

final class GameViewModel: GameViewModelProtocol {
  var anyCancellables = Set<AnyCancellable>()

  var word = PassthroughSubject<String, Never>()
  var score = PassthroughSubject<String, Never>()
  var translation = PassthroughSubject<String, Never>()
  var lives = PassthroughSubject<Int, Never>()
  var answer = PassthroughSubject<String, Never>()
  var ShouldButtonEnabled = PassthroughSubject<Bool, Never>()
  var shouldAnimateTranslationView: Bool = false

  // Translation Label call backs
  var showTranslation: (() -> ())?
  var hideTranslation: (() -> ())?
  var translationPosition: (() -> ())?

  private var useCase: GamePlayable
  private let actions: GameViewModelActions

  // single game round
  private var round: Round

  // Words translation options index counter (e.g 0..3)
  private var optionsIndexCounter: Int = 0

  private var timerValue: TimeInterval = 0

  // Calculating next translation index counter
  private let nextTranslationIndex : ((Int, Int) -> Int) = { $0 % $1 }
  private var timer: Timer!

  init(useCase: GamePlayable, actions: GameViewModelActions) {
    self.useCase = useCase
    self.actions = actions
    self.round = useCase.setupRound
    self.useCase.updateRound = { [weak self] (gameData) in self?.updateGameRound(round: gameData) }
    self.useCase.endGame = { [weak self] in self?.actions.dismiss() }
  }

  private func handleUserResponse(action: PlayerAction) {
    checkPlayerAction(action: action)

    // resetting the floating label position
    hideTranslation?()
    translationPosition?()

    // updating the counter next translation based on user action
    optionsIndexCounter = nextTranslationIndex(optionsIndexCounter + 1, round.options.count)

    // send next translation from given options
    translation.send(round.options[optionsIndexCounter])

    showTranslation?()
    ShouldButtonEnabled.send(true)

    // resetting the timer
    invalidateTimer()
    startTimer()
  }

  private func updateGameRound(round: Round) {
    self.round = round
    optionsIndexCounter = 0
    word.send(round.word)
    translation.send(round.options[0])
    translationPosition?()
  }

  private func checkLives() {
    if self.useCase.lives == 0 {
      self.translation.send(completion: .finished)
      self.lives.send(completion: .finished)
    }
  }

  private func checkPlayerAction(action: PlayerAction) {
    useCase.checkAction(action: action) { [weak self] (result) in
      guard let self = self else { return }
      switch action {
      case .none:
        self.checkLives()
        self.answer.send("No Answer")

      default:
        self.checkLives()
        self.score.send("Score: \(self.useCase.score)")
        self.answer.send(result ? "Right Answer" : "Wrong Answer")
      }
    }
  }
}

// MARK: GameViewModel Inputs
extension GameViewModel {
  func viewDidLoad() {
    word.send(round.word)
    answer.send("")
    translation.send(round.options.first ?? "")
    ShouldButtonEnabled.send(false)
    translationPosition?()
  }

  func onViewAppear() {
    showTranslation?()
    ShouldButtonEnabled.send(true)
    startTimer()
  }

  func didPressOnRightAnswerButton() {
    let userChoice = round.options[optionsIndexCounter]
    handleUserResponse(action: .correct(answer: userChoice))
  }

  func didPressOnWrongAnswerButton() {
    let userChoice = round.options[optionsIndexCounter]
    handleUserResponse(action: .wrong(answer: userChoice))
  }

  func calculateTranslationPosition(width: Double, maxWidth:Double) -> Double {
    let randomValue = Double.random(in: 0...maxWidth)
    let difference = randomValue - width
    if randomValue >= 0 && randomValue <= (maxWidth - width) {
      return randomValue
    } else {
      return (difference < 0) ? randomValue + difference : (maxWidth - width - 20)
    }
  }

  func didTranslationOutOfView() {
    let option = round.options[optionsIndexCounter]
    handleUserResponse(action: .none(translation: option))
  }

  func didPressOnCloseButton() {
    actions.dismiss()
  }
}

// MARK: Timer configurations
private extension GameViewModel {
  func startTimer() {
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: updateTimer)
  }

  func updateTimer(timer: Timer) {
    timerValue += 1
    if timerValue == AppConstant.gameTime {
      invalidateTimer()
    }
  }

  func invalidateTimer() {
    timer.invalidate()
    timerValue = 0
  }
}
