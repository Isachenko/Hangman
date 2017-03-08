//
//  CurrentGameModel.swift
//  Hangman
//
//  Created by Andrey Isachenko on 27/02/2017.
//  Copyright © 2017 University of Groningen. All rights reserved.
//

import Foundation

class CurrentGameModel {
    
    let human = PlayerInfo()
    let ai = PlayerInfo()
    let aiBrain = AIBrain()
    
    enum GameState : String{
        case wordChosing = "word picking"
        case humanTurn = "human turn"
        case aiTurn = "ai turn"
        case aiJustWon = "ai won"
        case humanJustWon = "human won"
        case stoped = "game stoped"
    }
    
    var gameState = GameState.stoped
    
    func setWords(forHuman human: String, forAI ai: String) {
        if gameState == .wordChosing {
            self.human.word = human
            self.ai.word = ai
            gameState = .humanTurn
        }
    }
    
    func humanTryLetter(letter: Character){
        if (gameState == .humanTurn) {
            let result = human.tryLetter(letter: letter)
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
        }
    }
    
    func aiTryLetter(){
        if (gameState == .aiTurn) {
            let letter = aiBrain.getLetter()
            let result = ai.tryLetter(letter: letter)
            switch result {
            case .error:
                print("ai: try letter \(letter) error")
            case .rightLetter:
                print("ai: right letter \(letter)")
                gameState = .humanTurn
            case .wrongLetter:
                print("ai: wrong letter \(letter)")
                gameState = .humanTurn
            }
            checkForGameEnd()
        }
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
