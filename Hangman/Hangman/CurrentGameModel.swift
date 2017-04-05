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
    let playerName = UserDefaults.standard.value(forKey: "playername") as! String
    var wrongLetters = [Character]()
    var rightLetters = [Character]()

    
    init() {
        readWordsFromFile()
    }
    
    enum GameState : String{
        case wordChosing = "Word picking"
        case humanTurn = "Human turn"
        case aiTurn = "AI turn"
        case aiJustWon = "AI won"
        case humanJustWon = "Human won"
        case stoped = "Game stoped"
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
            aiBrain.setTheSizeOfHiddenWord(size: ai.characters.count)
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
            var letter = "a".characters.first!
            if(!aiBrain.getPossibleWordBool()){
                print("AI letter")
                letter = aiBrain.getLetter()
                print(letter)
            }
            else{
                print("SWIFT letter")
                letter = aiBrain.getLetterFromWord()
                print(letter)
            }
            let result = ai.tryLetter(letter: letter)
            var feedback = ""
            switch result {
            case .error:
                print("ai: try letter \(letter) error")
            case .rightLetter:
                print("ai: right letter \(letter)")
                feedback = "right"
                gameState = .humanTurn
                aiBrain.memorizeLetter(letter: letter)
                rightLetters.append(letter)
            case .wrongLetter:
                aiBrain.setPossibleWordBool(state: false)
                print("ai: wrong letter \(letter)")
                feedback = "wrong"
                gameState = .humanTurn
                wrongLetters.append(letter)
            }

            aiBrain.setUsedLetters(letter: String(letter))
            aiBrain.updateDictWrongLetters(dictionary: wrongLetters)
            aiBrain.updateDictRightLetters(dictionary: rightLetters)
            checkForGameEnd()
            aiBrain.setFeedback(value: feedback, enoughtLettersToGuessed: isItenoughtLettersToGuessed(), firstLetterKnown: isFirstletterGuessed(), firstLetter: getTheFirstLetter(), wordSize: wordSize())
            return (letter, result)
        }
        return ("x", .error)
    }
    
    func isItenoughtLettersToGuessed() -> Bool{
        let word = ai.wordHiden
        let lenght = word.characters.count / 2
        var n = 0
        for c in word.characters {
            if c == "_" {
                n = n + 1
            }
        }
        print("number of guessed letters ", lenght - n)
        return (n < (lenght / 2)) 
    }
    func getPossibleWordMVC()-> Bool{
        return aiBrain.getPossibleWordBool()
    }
    func isFirstletterGuessed() -> Bool {
        return ai.wordHiden.characters.first != "_"
    }
    
    func getTheFirstLetter() -> String{
            return "L" + String(describing: ai.word.characters.first!).capitalized
    }
    
    func wordSize() -> String{
        let n = ai.word.characters.count
        switch n {
        case let n where n<7:
            return("short")
        case let n where n>9:
            return("extraLong")
        default:
            return("long")
        }
    }
    
    func resetAiforNewTurn() {
        aiBrain.storePreviousGamesChunks()
        aiBrain.restoreChunkUsedValue()
        aiBrain.resetDictionaries()
        wrongLetters = [Character]()
        rightLetters = [Character]()
    }
    
    func checkForGameEnd() {
        if (human.curlife == 0 || ai.wordFinished) {
            gameState = .aiJustWon
        } else if (ai.curlife == 0 || human.wordFinished) {
            gameState = .humanJustWon
        }
    }
    
    func isGameEnd() -> Bool{
        return (gameState == .aiJustWon) || (gameState == .humanJustWon)
    }
    
    func reset() {
        gameState = GameState.wordChosing
        human.reset()
        ai.reset()
    }
}
