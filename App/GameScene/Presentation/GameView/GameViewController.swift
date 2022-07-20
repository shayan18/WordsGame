//
//  GameViewController.swift
//  WordGame
//
//  Created by Shayan Ali on 18.07.22.
//

import Combine
import Logging
import UIKit

final class GameViewController: UIViewController {
  // MARK: Outlets
  @IBOutlet private weak var wordLabel: UILabel!
  @IBOutlet private weak var scoreLabel: UILabel!
  @IBOutlet private weak var resultLabel: UILabel!
  @IBOutlet private weak var correctButton: UIButton!
  @IBOutlet private weak var wrongButton: UIButton!

  private var floatingLabel: UILabel!

  var viewModel: GameViewModelProtocol!

  override func viewDidLoad() {
    super.viewDidLoad()
    setupFloatingLabel()
    bindViewModel()
    setupFloatingLabelCallBacks()
    viewModel.viewDidLoad()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    viewModel.onViewAppear()
  }
}

// MARK: Translation label configurations
private extension GameViewController {
  func setupFloatingLabel() {
    floatingLabel = UILabel(frame: CGRect(x: 100, y: -50, width: 200, height: 100))
    floatingLabel.textColor = .red
    floatingLabel.textAlignment = .center
    floatingLabel.font = .systemFont(ofSize: AppConstant.fontSize)
    floatingLabel.isHidden = true
    view.addSubview(floatingLabel)
  }

  func setFloatingLabelPosition() {
    let translationWidth = Double(floatingLabel.frame.size.width)
    let totalWidth = Double(UIScreen.main.bounds.width)
    let xPos = viewModel.calculateTranslationPosition(width: translationWidth , maxWidth: totalWidth)
    floatingLabel.frame.origin.x = CGFloat(xPos)
  }

  func animateFloatingLabel() {
    floatingLabel.isHidden = false
    UIView.animate(
      withDuration: AppConstant.gameTime,
      delay: 0.5, options: [],
      animations: { self.floatingLabel.frame.origin.y = UIScreen.main.bounds.height },
      completion: { isCompleted in
      if isCompleted {
        self.viewModel.didTranslationOutOfView()
      }
    })
  }
}

// MARK: View bidings & call backs
private extension GameViewController {
  func bindViewModel() {
    viewModel.answer.sink { [weak self] value in
      self?.resultLabel.text = value
    }.store(in: &viewModel.anyCancellables)

    viewModel.word.sink { [weak self] word in
      self?.wordLabel.text = word
    }.store(in: &viewModel.anyCancellables)

    viewModel.ShouldButtonEnabled.sink { [weak self] status in
      self?.setActionButtonsInteraction(enabled: status)
    }.store(in: &viewModel.anyCancellables)

    viewModel.translation.sink { [weak self] completion in
      switch completion {
      case .finished:
        self?.floatingLabel.removeFromSuperview()
      }
    } receiveValue: { translation in
      self.floatingLabel.text = translation
    }
    .store(in: &viewModel.anyCancellables)

    viewModel.score.sink { [weak self] score in
      self?.scoreLabel.text = score
    }.store(in: &viewModel.anyCancellables)

    viewModel.lives.sink { completion in
      switch completion {
      case .finished:
        self.showAlert(
          with: "Game Over",
          and: self.scoreLabel.text,
          actionTitle: "Exit",
          handler: { _ in
            self.viewModel.didPressOnCloseButton()
          })
      }
    } receiveValue: { lives in
      Logger.shared.log(level: .info, "\(lives)")
    }
    .store(in: &viewModel.anyCancellables)
  }

  func setupFloatingLabelCallBacks() {
    viewModel.showTranslation = { [weak self] in self?.animateFloatingLabel() }

    viewModel.translationPosition = { [weak self] in self?.setFloatingLabelPosition() }

    viewModel.hideTranslation = { [weak self] in
      self?.floatingLabel.isHidden = true
      self?.floatingLabel.layer.removeAllAnimations()
      self?.floatingLabel.frame.origin = CGPoint(x: 100, y: -50)
    }
  }
}
// MARK: Button Actions
private extension GameViewController {
  func setActionButtonsInteraction(enabled: Bool) {
    correctButton.isUserInteractionEnabled = enabled
    wrongButton.isUserInteractionEnabled = enabled
  }

  @IBAction func didPressedCloseButton(_ sender: UIButton) {
    viewModel.didPressOnCloseButton()
  }

  @IBAction func didPressedCorrectButton(_ sender: UIButton) {
    viewModel.didPressOnRightAnswerButton()
  }

  @IBAction func didPressedWrongButton(_ sender: UIButton) {
    viewModel.didPressOnWrongAnswerButton()
  }
}
