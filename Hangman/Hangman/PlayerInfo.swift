//
//  PlayerInfo.swift
//  Hangman
//
//  Created by Andrey Isachenko on 27/02/2017.
//  Copyright © 2017 University of Groningen. All rights reserved.
//

import Foundation

class PlayerInfo {
    
    init() {
        reset()
    }
    
    private var wordToGuess = "nothing"
    let maxLife: Int = 6
    var curlife: Int = 6
    private var usedLetters: String = ""
    private var allLetters: String = "qwertyuiopasdfghjklzxcvbnm"
    private var goodLetters: String = " "
    
    var wordFinished: Bool {
        for letter in wordToGuess.characters {
            if !goodLetters.contains(String(letter)) {
                return false
            }
        }
        return true
    }
    
    enum tryLetterResult {
        case rightLetter
        case wrongLetter
        case error
    }
    
    func tryLetter(letter: Character) -> tryLetterResult {
        if !usedLetters.contains(String(letter)){
            usedLetters.append(contentsOf: [letter])
            if wordToGuess.contains(String(letter)) {
                goodLetters.append(contentsOf: [letter])
                return .rightLetter
            } else {
                curlife -= 1
                return .wrongLetter
            }
        } else {
            return .error
        }
        
    }
    
    var word: String {
        get {
            return wordToGuess
        }
        set {
            wordToGuess = newValue.lowercased()
        }
    }
    
    var wordHiden: String {
        get {
            var hidenWord = ""
            for letter in wordToGuess.characters {
                if goodLetters.contains(String(letter)) {
                    hidenWord += String(letter) + " "
                } else {
                    hidenWord += "_ "
                }
            }
            return hidenWord
        }
    }
    
    func reset() {
        wordToGuess = "nothing"
        curlife = maxLife
        usedLetters = ""
        goodLetters = ""
    }

    
    
}
