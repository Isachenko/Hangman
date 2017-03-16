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
        //return getRandomLetter()
        actrAI.run()
        return actrAI.lastAction("choice")!.characters.first!
    }
    
    func setFeedback(value: String, gameEnd: Bool) {
        actrAI.modifyLastAction(slot: "feedback", value: value)
        if (gameEnd){
            for (key) in actrAI.dm.chunks {
                if (key.key.characters.first!.description == "L"){
                    actrAI.dm.chunks[key.key]?.setSlot(slot: "used", value: "false")
                    print(key.key)
                    print(actrAI.dm.chunks[key.key]?.activation() ?? "A")
                    print(actrAI.dm.chunks[key.key]?.baseLevelActivation() ?? "Q")
                    
                }
            }
        }

    }
    
}
