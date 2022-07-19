//
//  HomeViewModel.swift
//  WordGame
//
//  Created by Shayan Ali on 19.07.22.
//

import Foundation

protocol HomeViewModelProtocol {
  // Inputs
  func playPressed()
  func onAppear()

  // OutPuts
  var title: String { get }
  var buttonTitle:String { get }
}


final class HomeViewModel: HomeViewModelProtocol {
  private let actions: HomeViewModelActions

  init(actions: HomeViewModelActions) {
    self.actions = actions
  }

  var title: String { "Word Game" }
  var buttonTitle: String { "Play" }
  //  var score: Observable<String> = Observable("")

  func playPressed() {
    actions.showGameView()
  }

  func onAppear() {
  }
}

