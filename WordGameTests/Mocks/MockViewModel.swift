//
//  MockViewModel.swift
//  WordGameTests
//
//  Created by Shayan Ali on 20.07.22.
//

import Foundation
@testable import WordGame

final class MockViewModel {
  var useCase: GamePlayable
  var round: Round
  var shouldEndGame = false

  init(useCase: GamePlayable) {
    self.useCase = useCase
    self.round = useCase.setupRound
    self.useCase.endGame = { [weak self] in
      self?.shouldEndGame = true
    }
    self.useCase.updateRound = { [weak self] newRound in
      self?.round = newRound
    }
  }
}
