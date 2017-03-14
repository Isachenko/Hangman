//
//  AIBrain.swift
//  Hangman
//
//  Created by Andrey Isachenko on 05/03/2017.
//  Copyright © 2017 University of Groningen. All rights reserved.
//

import Foundation

class AIBrain {
    
    var usedLetters = ""
    var goodLetters = ""
    var wordRepresentation = ""
    var possibleLetters = "qwertyuiopasdfghjklzxcvbnm"
    
    var actrAI : Model
    
    init() {
        actrAI = Model()
        actrAI.loadModel(fileName: "hangman")
    }
    
    func getRandomLetter() -> Character {
        while true {
            let index:Int = Int(arc4random_uniform(UInt32(possibleLetters.characters.count)))
            let letter = possibleLetters.characters[possibleLetters.index(possibleLetters.startIndex, offsetBy: index)]
            if !usedLetters.contains(String(letter)) {
                usedLetters.append(letter)
                return letter
            }
        }
    }
    
    func getLetter() -> Character {
        actrAI.run()
        //print(actrAI.lastAction("choice2"))
        return actrAI.lastAction("choice")!.characters.first!
    }
    
    func setFeedback(value: String, gameEnd: String) {
        actrAI.modifyLastAction(slot: "feedback", value: value)
        actrAI.modifyLastAction(slot: "IfGameOver", value: gameEnd)
    }
    
}
