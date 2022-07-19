//
//  GameService.swift
//  WordGame
//
//  Created by Shayan Ali on 19.07.22.
//

import Foundation

final class GameService {
  var originalWords = [String]()
  var translations = [String]()
  var rounds = [Round]()
  var wordsDict = [String: String]()

  func setupGame(words: [Word]) {
    words.forEach { word in wordsDict[word.word] = word.translation }
    originalWords = words.compactMap { $0.word }
    translations = words.compactMap { $0.translation }
    rounds = generateRandomWordsForGame(originalWords: originalWords, translations: translations)
  }

  private func generateRandomWordsForGame(originalWords: [String], translations: [String]) -> [Round] {
    var result = [Round]()
    let totalWords = originalWords.count
    let maxNum = min(4, totalWords)

    originalWords.forEach { word in
      var option = Set<String>()
      option.insert(wordsDict[word]!)
      var counter = 1
      while counter != maxNum {
        let translation = translations.randomElement() ?? ""
        if translation != wordsDict[word]! && !option.contains(translation) {
          option.insert(translation)
          counter += 1
        }
      }
      var optionsTemp = Array(option)
      optionsTemp.shuffle()
      result.append(Round(word: word, options: optionsTemp))
    }

    return result
  }
}

