//
//  GameViewController.swift
//  WordGame
//
//  Created by Shayan Ali on 18.07.22.
//

import UIKit
import Combine

final class GameViewController: UIViewController {
  // MARK: Outlets

  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var wordLabel: UILabel!
  @IBOutlet private weak var resultLabel: UILabel!
  @IBOutlet private weak var correctButton: UIButton!
  @IBOutlet private weak var wrongButton: UIButton!

  private var translationLabel: UILabel!

  var viewModel: GameScreenViewModelProtocol!

  override func viewDidLoad() {
    super.viewDidLoad()
    setupTranslationLabel()
    bindViewModel()
    setActions()
    viewModel.viewDidLoad()
  }

  private func setupTranslationLabel() {
    translationLabel = UILabel(frame: CGRect(x: 150, y: -30, width: 200, height: 100))
    // translationLabel.font = .translationWordFont
    translationLabel.textColor = .white
    translationLabel.isHidden = true
    translationLabel.textAlignment = .center
    view.addSubview(translationLabel)
  }

  private func bindViewModel() {
    viewModel.answer.sink { [weak self] value in
      self?.resultLabel.text = value
    }.store(in: &viewModel.AnyCancellables)

    viewModel.word.sink { [weak self] word in
      self?.wordLabel.text = word
    }.store(in: &viewModel.AnyCancellables)

    viewModel.isButtonInteractionsEnabled.sink { [weak self] status in
      self?.setButtonInteraction(enabled: status)
    }.store(in: &viewModel.AnyCancellables)

    viewModel.translation.sink { [weak self] translation in
      self?.translationLabel.text = translation
    }.store(in: &viewModel.AnyCancellables)
    titleLabel.text = viewModel.wordTitle
  }

  private func setActions() {
    viewModel.showTranslation = { [weak self] in self?.animateTranslationLabel() }

    viewModel.positionTranslation = { [weak self] in self?.setTranslationPosition() }

    viewModel.hideTranslation = { [weak self] in
      self?.translationLabel.isHidden = true
      self?.translationLabel.layer.removeAllAnimations()
      self?.translationLabel.frame.origin = CGPoint(x: 150, y: -30)
    }
  }

  private func animateTranslationLabel() {
    translationLabel.isHidden = false
    UIView.animate(withDuration: 6, delay: 1, options: []
                   , animations: { self.translationLabel.frame.origin.y = UIScreen.main.bounds.height},
                   completion: { (isCompleted) in if isCompleted { self.viewModel.didTranslationOutOfScreen() } }
    )
  }

  private func setTranslationPosition() {
    let translationWidth = Double(translationLabel.frame.size.width)
    let totalWidth = Double(UIScreen.main.bounds.width)
    let xPos = viewModel.calculateTranslationPosition(translationWidth: translationWidth , totalWidth: totalWidth)
    translationLabel.frame.origin.x = CGFloat(xPos)
  }

  private func setButtonInteraction(enabled: Bool) {
    correctButton.isUserInteractionEnabled = enabled
    wrongButton.isUserInteractionEnabled = enabled
  }
}

private extension GameViewController {
  @IBAction func didPressedCloseButton(_ sender: UIButton) {
    viewModel.didTapOnCloseButton()
  }

  @IBAction func didPressedCorrectButton(_ sender: UIButton) {
    viewModel.didTapOnRightAnswerButton()
  }

  @IBAction func didPressedWrongButton(_ sender: UIButton) {
    viewModel.didTapOnWrongAnserButton()
  }
}
