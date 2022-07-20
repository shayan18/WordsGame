//
//  HomeViewController.swift
//  WordGame
//
//  Created by Shayan Ali on 18.07.22.
//

import UIKit

class HomeViewController: UIViewController {

  // MARK: Outlets
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var playButton: UIButton!

  var viewModel: HomeViewModelProtocol!

  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    viewModel.onAppear()
  }

  private func setupView() {
      titleLabel.text = viewModel.title
      playButton.setTitle(viewModel.buttonTitle, for: .normal)
  }

  @IBAction func playPressed(_ sender: UIButton) {
      viewModel.playPressed()
  }
}


