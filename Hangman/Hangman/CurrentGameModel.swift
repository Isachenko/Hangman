//
//  CurrentGameModel.swift
//  Hangman
//
//  Created by Andrey Isachenko on 27/02/2017.
//  Copyright © 2017 University of Groningen. All rights reserved.
//

import Foundation

extension MutableCollection where Indices.Iterator.Element == Index {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled , unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            swap(&self[firstUnshuffled], &self[i])
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}

class CurrentGameModel {
    
    let human = PlayerInfo()
    let ai = PlayerInfo()
    let aiBrain = AIBrain()
    var words = [String]()
    
    init() {
        readWordsFromFile()
    }
    
    enum GameState : String{
        case wordChosing = "word picking"
        case humanTurn = "human turn"
        case aiTurn = "ai turn"
        case aiJustWon = "ai won"
        case humanJustWon = "human won"
        case stoped = "game stoped"
    }
    
    var gameState = GameState.stoped
    
    func readWordsFromFile(){
        if let path = Bundle.main.path(forResource: "Words", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                words = data.components(separatedBy: .newlines)
            } catch {
                print(error)
            }
        }
    }
    
    func getRandomWords(number: Int) -> [String]{
        words.shuffle()
        let randomSubset = [] + words[0...number]
        return randomSubset
    }
    
    func setWords(forHuman human: String, forAI ai: String) {
        if gameState == .wordChosing {
            self.human.word = human
            self.ai.word = ai
            gameState = .humanTurn
        }
    }
    
    func humanTryLetter(letter: Character) -> PlayerInfo.tryLetterResult{
        if (gameState == .humanTurn) {
            let result = human.tryLetter(letter: String(letter).lowercased().characters.first!)
            switch result {
            case .error:
                print("human: try letter \(letter) error")
            case .rightLetter:
                print("human: right letter \(letter)")
                gameState = .aiTurn
            case .wrongLetter:
                print("human: wrong letter \(letter)")
                gameState = .aiTurn
            }
            checkForGameEnd()
            return result
        }
        return .error
    }
    
    func aiTryLetter() -> (Character, PlayerInfo.tryLetterResult) {
        if (gameState == .aiTurn) {
            let letter = aiBrain.getLetter()
            let result = ai.tryLetter(letter: letter)
            var feedback = ""
            switch result {
            case .error:
                print("ai: try letter \(letter) error")
            case .rightLetter:
                print("ai: right letter \(letter)")
                feedback = "right"
                gameState = .humanTurn
            case .wrongLetter:
                print("ai: wrong letter \(letter)")
                feedback = "wrong"
                gameState = .humanTurn
            }
            checkForGameEnd()
            var gameEnd = "no"
            if (gameState == .aiJustWon) || (gameState == .humanJustWon) {
                gameEnd = "yes"
            }
            aiBrain.setFeedback(value: feedback, gameEnd: gameEnd)
            return (letter, result)
        }
        return ("x", .error)
    }
    
    func checkForGameEnd() {
        if (human.curlife == 0 || ai.wordFinished) {
            gameState = .aiJustWon
        } else if (ai.curlife == 0 || human.wordFinished) {
            gameState = .humanJustWon
        }
    }
    
    func reset() {
        gameState = GameState.wordChosing
        human.reset()
        ai.reset()
    }
}
